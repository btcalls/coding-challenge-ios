import SwiftUI
import Combine
import os

// Simple in-memory image cache keyed by URL.
private actor ImageCache {
    static let shared = ImageCache()
    
    private var storage: [URL: UIImage] = [:]

    func image(for url: URL) -> UIImage? {
        return storage[url]
    }
    
    func insert(_ image: UIImage, for url: URL) {
        storage[url] = image
    }
}

// Loader that downloads and caches images. Supports downscaling for thumbnails.
@MainActor
private final class ImageLoader: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case success(UIImage)
        case failure

        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle), (.loading, .loading), (.failure, .failure):
                return true
            
            case let (.success(li), .success(ri)):
                return li.pngData() == ri.pngData()
            default:
                return false
            }
        }
    }

    @Published var state: State = .idle
    private var task: Task<Void, Never>?

    func load(from url: URL?, thumbnailMaxDimension: CGFloat?) {
        task?.cancel()
        
        guard let url else {
            state = .failure
            
            return
        }
        
        state = .loading

        task = Task { [weak self] in
            // Check cache first
            if let cached = await ImageCache.shared.image(for: url) {
                await MainActor.run {
                    self?.state = .success(cached)
                }
                
                return
            }

            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard Task.isCancelled == false else {
                    return
                }
                
                guard let http = response as? HTTPURLResponse,
                        (200..<300).contains(http.statusCode) else {
                    await MainActor.run {
                        self?.state = .failure
                    }
                    
                    return
                }
                
                guard var image = UIImage(data: data) else {
                    await MainActor.run {
                        self?.state = .failure
                    }
                    
                    return
                }

                if let maxDim = thumbnailMaxDimension, maxDim > 0 {
                    image = image.downscaled(maxDimension: maxDim)
                }

                await ImageCache.shared.insert(image, for: url)
                await MainActor.run {
                    self?.state = .success(image)
                }
            } catch {
                Logger.log(error)
                
                await MainActor.run {
                    self?.state = .failure
                }
            }
        }
    }

    func cancel() { task?.cancel() }
}

private extension UIImage {
    // Downscale maintaining aspect ratio so that max(width, height) == maxDimension
    func downscaled(maxDimension: CGFloat) -> UIImage {
        guard maxDimension > 0 else {
            return self
        }
        
        let size = self.size
        let maxSide = max(size.width, size.height)
        
        guard maxSide > maxDimension else {
            return self
        }
        
        let scale = maxDimension / maxSide
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

struct CustomImage: View {
    let url: URL?
    var thumbnailMaxDimension: CGFloat? = 200
    var contentMode: ContentMode = .fill
    var cornerRadius: CGFloat = 8
    var showsActivity: Bool = true
    var placeholder: AnyView? = nil
    var failureView: AnyView? = nil

    @StateObject private var loader = ImageLoader()

    var body: some View {
        ZStack {
            switch loader.state {
            case .idle, .loading:
                placeholderView
                    .overlay(activityView)
            
            case .success(let uiImage):
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .transition(.opacity)
                
            case .failure:
                (failureView ?? AnyView(Image(systemName: "photo").symbolVariant(.slash)) )
                    .foregroundStyle(.secondary)
            }
        }
        .onAppear {
            loader.load(from: url, thumbnailMaxDimension: thumbnailMaxDimension)
        }
        .onChange(of: url) { _, newURL in
            loader.load(from: newURL, thumbnailMaxDimension: thumbnailMaxDimension)
        }
        .onDisappear {
            loader.cancel()
        }
        .accessibilityLabel("image")
    }

    @ViewBuilder
    private var activityView: some View {
        if showsActivity && (loader.state == .loading || loader.state == .idle) {
            ProgressView().progressViewStyle(.circular)
        }
    }

    @ViewBuilder
    private var placeholderView: some View {
        if let placeholder {
            placeholder
        } else {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.quaternary)
                .overlay(Image(systemName: "photo").foregroundStyle(.tertiary))
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomImage(url: URL(string: "https://picsum.photos/seed/1/600/400"))
            .frame(width: Layout.Size.thumbnail, height: Layout.Size.thumbnail)
            .clipped()
        CustomImage(url: URL(string: "https://invalid-domain/image.jpg"), showsActivity: true)
            .frame(width: Layout.Size.thumbnail, height: Layout.Size.thumbnail)
        CustomImage(url: nil)
            .frame(width: Layout.Size.thumbnail, height: Layout.Size.thumbnail)
    }
    .padding()
}

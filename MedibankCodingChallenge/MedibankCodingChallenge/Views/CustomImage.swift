import SwiftUI
import Combine
import os

/// Simple in-memory image cache keyed by URL.
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

/// Loader that downloads and caches images. Supports downscaling for thumbnails.
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
    
    /// Initiates loading of `URL` to retrieve image data.
    /// - Parameters:
    ///   - url: A valid `URL` for an image.
    ///   - thumbnailMaxDimension: The maximum size of the thumbnail to be used for downscaling.
    func load(from url: URL?, thumbnailMaxDimension: CGFloat?) {
        task?.cancel()
        
        // Check if url is valid
        guard let url else {
            state = .idle
            
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
                // Initiate request
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard Task.isCancelled == false else {
                    return
                }
                
                // Check if HTTP request made was a success
                guard let http = response as? HTTPURLResponse,
                        (200..<300).contains(http.statusCode) else {
                    await MainActor.run {
                        self?.state = .failure
                    }
                    
                    return
                }
                
                // Image from request data
                guard var image = UIImage(data: data) else {
                    await MainActor.run {
                        self?.state = .failure
                    }
                    
                    return
                }

                // Option to downscale image
                if let maxDim = thumbnailMaxDimension, maxDim > 0 {
                    image = image.downscaled(maxDimension: maxDim)
                }

                // Store to cache and update UI state
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

    /// Cancels request.
    func cancel() {
        task?.cancel()
    }
}

private extension UIImage {
    /// Downscale maintaining aspect ratio so that max(width, height) == maxDimension
    /// - Parameter maxDimension: Maximum height/width of image as basis for downscaling.
    /// - Returns: Downscaled `UIImage` instance.
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

        var format = UIGraphicsImageRendererFormat.default()
        format.scale = self.scale
        
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

/// View to load thumbnails from URL.
///
/// Option to cache images afterwards.
struct CustomImage: View {
    @Environment(\.redactionReasons) private var redactionReasons
    
    let url: URL?
    var thumbnailMaxDimension: CGFloat? = nil
    var contentMode: ContentMode = .fill
    var showsActivity: Bool = true

    @StateObject private var loader = ImageLoader()

    var body: some View {
        ZStack {
            switch loader.state {
            case .idle:
                placeholderView
            
            case .loading:
                activityView
            
            case .success(let uiImage):
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .transition(.opacity)
                
            case .failure:
                failureView
            }
        }
        .onAppear {
            // Only initiate loading of images if it is not being
            // rendered as a skeleton view (e.g. during loading)
            if redactionReasons == [] {
                loader.load(from: url, thumbnailMaxDimension: thumbnailMaxDimension)
            }
        }
        .onChange(of: url) { _, newURL in
            loader.load(from: newURL, thumbnailMaxDimension: thumbnailMaxDimension)
        }
        .onDisappear {
            loader.cancel()
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        Rectangle()
            .fill(.quaternary)
    }

    @ViewBuilder
    private var activityView: some View {
        if showsActivity && (loader.state == .loading || loader.state == .idle) {
            backgroundView
                .overlay {
                    ProgressView().progressViewStyle(.circular)
                }
        }
    }

    @ViewBuilder
    private var placeholderView: some View {
        if redactionReasons == [] {
            backgroundView
                .overlay {
                    Image(systemName: "photo.fill")
                        .foregroundStyle(.tertiary)
                        .font(.title3)
                }
        } else {
            backgroundView
        }
    }
    
    @ViewBuilder
    private var failureView: some View {
        backgroundView
            .overlay {
                Image(systemName: "photo.trianglebadge.exclamationmark")
                    .foregroundStyle(.tertiary)
                    .font(.title3)
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

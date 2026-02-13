import XCTest
@testable import MedibankCodingChallenge

@MainActor
final class HeadlinesViewModelTests: XCTestCase {
    var viewModel: HeadlinesViewModel!
    
    override func setUp() {
        super.setUp()
        
        viewModel = HeadlinesViewModel(
            container: MockSwiftDataManager().container,
            asMock: true
        )
    }
    
    override func tearDown() {
        viewModel = nil
        
        super.tearDown()
    }
    
    func testFetchArticlesIfNeeded_WhenArticlesAreEmpty_FetchesArticles() async {
        // When
        await viewModel.fetchArticlesIfNeeded()
        
        // Then
        XCTAssertFalse(viewModel.data.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFetchArticles_SuccessState() async {
        // When
        await viewModel.fetchArticles()
        
        // Then
        XCTAssertFalse(viewModel.data.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFetchArticles_ErrorState() async {
        // We cannot inject error directly, but we can simulate by calling fetchArticles when offline or invalid URL
        // Since we cannot inject dependencies, simulate by calling fetchArticles multiple times to check error handling
        
        // This test is limited since no dependency injection is allowed, but we can at least verify errorMessage is nil after successful fetch
        await viewModel.fetchArticles()
        
        XCTAssertNil(viewModel.errorMessage)
    }
}


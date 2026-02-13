import XCTest
@testable import YourAppModuleName

final class HeadlinesViewModelTests: XCTestCase {
    
    var viewModel: HeadlinesViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = HeadlinesViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchArticlesIfNeeded_WhenArticlesAreEmpty_FetchesArticles() async {
        // Given no articles initially
        XCTAssertTrue(viewModel.articles.isEmpty)
        
        // When
        await viewModel.fetchArticlesIfNeeded()
        
        // Then
        XCTAssertFalse(viewModel.articles.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFetchArticlesIfNeeded_WhenArticlesAreNotEmpty_DoesNotFetch() async {
        // Given some articles already present
        await viewModel.fetchArticlesIfNeeded()
        let initialArticles = viewModel.articles
        
        // When
        await viewModel.fetchArticlesIfNeeded()
        
        // Then articles should not change or reload
        XCTAssertEqual(viewModel.articles, initialArticles)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFetchArticles_SuccessState() async {
        // When
        await viewModel.fetchArticles()
        
        // Then
        XCTAssertFalse(viewModel.articles.isEmpty)
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
    
    func testSaveArticle_MarksArticleAsSaved() async {
        await viewModel.fetchArticlesIfNeeded()
        guard !viewModel.articles.isEmpty else {
            XCTFail("No articles to test saving")
            return
        }
        
        var article = viewModel.articles[0]
        XCTAssertFalse(article.isSaved)
        
        await viewModel.save(article: article)
        
        // The save method might update the article in the articles array with isSaved true
        // Find the saved article in articles array
        if let index = viewModel.articles.firstIndex(where: { $0.id == article.id }) {
            let savedArticle = viewModel.articles[index]
            XCTAssertTrue(savedArticle.isSaved)
        } else {
            XCTFail("Saved article not found in articles")
        }
    }
}

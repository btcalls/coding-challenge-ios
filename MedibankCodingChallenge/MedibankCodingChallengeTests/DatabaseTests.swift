//
//  MedibankCodingChallengeTests.swift
//  MedibankCodingChallengeTests
//
//  Created by Jason Jon Carreos on 9/2/2026.
//

import XCTest
import SwiftData
@testable import MedibankCodingChallenge

final class DatabaseTests: XCTestCase {
    private let sampleSource = MockValues.source
    private var swiftDataManager: MockSwiftDataManager!
    
    @MainActor
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        swiftDataManager = MockSwiftDataManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testDirectInsertSource() throws {
        guard let container = swiftDataManager.container else {
            fatalError("SwiftDataManager not properly initialised.")
        }
        
        let fetchDescriptor = FetchDescriptor<Source>(sortBy: [SortDescriptor(\.name)])
        
        // Check if store is empty
        var sources = try? container.mainContext.fetch(fetchDescriptor)
        
        XCTAssertEqual([], sources)
        
        // Insert single record
        container.mainContext.insert(sampleSource)
        try container.mainContext.save()
        
        sources = try? container.mainContext.fetch(fetchDescriptor)
        
        XCTAssertEqual(sources?.count, 1)
    }
    
    @MainActor
    func testDirectInsertArticle() throws {
        guard let container = swiftDataManager.container else {
            fatalError("SwiftDataManager not properly initialised.")
        }
        
        let fetchDescriptor = FetchDescriptor<Article>(
            sortBy: [SortDescriptor(\.title)]
        )
        
        // Check if store is empty
        var articles = try? container.mainContext.fetch(fetchDescriptor)
        
        XCTAssertEqual([], articles)
        
        // Insert single record
        let article = Article(
            source: MockValues.articleSource,
            author: "Author One",
            title: "The Sample Article",
            articleDescription: "This is a sample article.",
            url: URL(string: "https://sample.com")!,
            thumbnail: URL(string: "https://sample.com/image.jpg")!,
            publishedAt: .now
        )
        
        container.mainContext.insert(article)
        try container.mainContext.save()
        
        articles = try? container.mainContext.fetch(fetchDescriptor)
        
        XCTAssertEqual(articles?.count, 1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

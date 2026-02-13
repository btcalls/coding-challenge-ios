//
//  DataStore.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 13/2/2026.
//

import SwiftData

/// Protocol to be conformed for fetching records from SwiftData containers.
protocol DataStore {
    associatedtype Value
    
    var container: ModelContainer { get }
    
    func fetchAll() -> [Value]
    func save(record: Value) throws
    func saveRecords(_ records: [Value]) throws
    func delete(_ record: Value) throws
}

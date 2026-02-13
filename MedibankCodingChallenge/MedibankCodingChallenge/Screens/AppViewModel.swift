//
//  AppViewModel.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 12/2/2026.
//

import Foundation

/// Protocol to be conformed by view model instances.
protocol AppViewModel: ObservableObject {
    associatedtype Value
    
    /// Flag to signify if any task or action is in progress. Add `@Published` to allow observation.
    var isLoading: Bool { get }
    /// Optional. Error message from failed task or action. Add `@Published` to allow observation.
    var errorMessage: String? { get }
    /// Data fetched from performed task or action. Add `@Published` to allow observation.
    var data: Value { get }
}

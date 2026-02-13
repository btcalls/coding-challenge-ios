//
//  Logger+Extensions.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 10/2/2026.
//

import os
import Foundation

extension Logger {
    private static let bundleLogger = Self(subsystem: Bundle.main.bundleIdentifier!,
                                           category: #file)
    
    /// Logs `URLRequest` details such as headers and body.
    /// - Parameter request: `URLRequest` to log.
    static func log(request: URLRequest) {
        var lines: [String] = []
        lines.append("➡️ \(request.httpMethod ?? ""). \(request.url?.absoluteString ?? "<nil>")")
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            lines.append("Headers: \(headers)")
        }
        
        if let body = request.httpBody, !body.isEmpty {
            lines.append("Body: \(body.count) bytes")
        }
        
        bundleLogger.debug("\(lines.joined(separator: "\n"))")
    }
    
    /// Logs `HTTPURLResponse` and `Data` details.
    /// - Parameters:
    ///   - response: `HTTPURLResponse` instance to log.
    ///   - data: `Data` instance to log.
    static func log(response: HTTPURLResponse, data: Data) {
        var lines: [String] = []
        lines.append("⬅️ Status: \(response.statusCode) from \(response.url?.absoluteString ?? "<nil>")")
        
        if !data.isEmpty {
            lines.append("Response: \(data.count) bytes")
        }
        
        bundleLogger.trace("\(lines.joined(separator: "\n"))")
    }
    
    /// Logs the description of `Error` instances.
    /// - Parameter error: `Error` instance to log.
    static func log(_ error: Error) {
        if let e = error as? APIError {
            bundleLogger
                .error("\(e.errorDescription ?? e.localizedDescription)")
        } else {
            bundleLogger.error("\(error.localizedDescription)")
        }
    }
}

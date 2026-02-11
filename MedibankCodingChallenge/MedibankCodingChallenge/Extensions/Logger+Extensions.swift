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
    
    static func log(response: HTTPURLResponse, data: Data) {
        var lines: [String] = []
        lines.append("⬅️ Status: \(response.statusCode) from \(response.url?.absoluteString ?? "<nil>")")
        
        if !data.isEmpty {
            lines.append("Response: \(data.count) bytes")
        }
        
        bundleLogger.trace("\(lines.joined(separator: "\n"))")
    }
    
    static func log(_ error: Error) {
        bundleLogger.error("\(error.localizedDescription)")
    }
}

//
//  MockURLProtocol.swift
//  MedibankCodingChallenge
//
//  Created by Jason Jon Carreos on 11/2/2026.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    static var responseProvider: ((URLRequest) throws -> (URLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.responseProvider else {
            fatalError("MockURLProtocol.responseProvider not set")
        }
        
        do {
            let (response, data) = try handler(request)
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if !data.isEmpty {
                client?.urlProtocol(self, didLoad: data)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        /* no-op */
    }
}

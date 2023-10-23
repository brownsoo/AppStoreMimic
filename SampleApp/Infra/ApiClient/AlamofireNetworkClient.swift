//
//  AlamofireNetworkClient.swift
//  AppStoreSample
//
//  Created by hyonsoo han on 2023/09/17.
//

import Foundation
import Alamofire

class AlamofireNetworkClient: NetworkClient {
    
    let session: Alamofire.Session = {
        let config = URLSessionConfiguration.af.default
        if kLoggingNetwork {
            let apiLogger = AlarmoLogger()
            return Session(configuration: config, eventMonitors: [apiLogger])
        }
        return Session(configuration: config)
    }()
    
    func request(_ resource: some NetworkRequest) async throws -> NetworkResponse {
        let request = try resource.toUrlRequest()
        let task = self.session.request(request)
            .validate(statusCode: 200..<299)
            .serializingData()
        let response = await task.response
        
        switch response.result {
            case .success(let data):
                return ApiResponse(status: response.response?.statusCode ?? 0, data: data)
            case .failure(let afError):
                throw self.convertToAppError(afError, withData: response.data)
        }
    }
    
    private func convertToAppError(_ error: AFError, withData data: Data?) -> NetworkError {
        
        if let nsError = error.underlyingError as? NSError {
            switch(nsError.code) {
                case NSURLErrorTimedOut,
                    NSURLErrorNotConnectedToInternet,
                    NSURLErrorInternationalRoamingOff,
                    NSURLErrorDataNotAllowed,
                    NSURLErrorCannotFindHost,
                    NSURLErrorCannotConnectToHost,
                NSURLErrorNetworkConnectionLost:
                    return .networkDisconnected
                default:
                    break
                    
            }
        }
        
        if error.responseCode == 304 {
            return .contentNotChanged
        }
        return .networkError(cause: error)
    }
}


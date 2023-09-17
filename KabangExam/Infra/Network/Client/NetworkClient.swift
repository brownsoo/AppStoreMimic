//
//  NetworkClient.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/08/31.
//

import Foundation
import Alamofire

protocol NetworkClient {
    func request(_ resource: Resource) async throws -> Response
}

class DefaultNetworkClient: NetworkClient {
    
    let session: Alamofire.Session = {
        let config = URLSessionConfiguration.af.default
        let apiLogger = AlarmoLogger()
#if DEBUG
        return Session(configuration: config, eventMonitors: [apiLogger])
#else
        return Session(configuration: config)
#endif
    }()
    
    func request(_ resource: Resource) async throws -> Response {
        let request = try resource.toUrlRequest()
        let task = self.session.request(request)
            .validate(statusCode: 200..<299)
            .serializingData()
        let response = await task.response
        
        switch response.result {
            case .success(let data):
                return NetworkResponse(status: response.response?.statusCode ?? 0, data: data)
            case .failure(let afError):
                throw self.convertToAppError(afError, withData: response.data)
        }
    }
    
    private func convertToAppError(_ error: AFError, withData data: Data?) -> AppError {
        if let data = data,
           let res = try? JSONDecoder().decode(ResTossError.self, from: data) {
            return AppError.requestFailed(statusCode: error.responseCode ?? 0, message: res.message)
        }
        if error.responseCode == 304 {
            return AppError.contentNotChanged
        }
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
        return .networkError(cause: error)
    }
}


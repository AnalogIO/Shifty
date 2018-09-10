//
//  API.swift
//  CheckIn
//
//  Created by Frederik Christensen on 22/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Alamofire
import Freddy

open class API {
    let baseUrl: String
    var defaultHeaders: HTTPHeaders = [:]
    
    public init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    public func setDefaultHeaders(headers: HTTPHeaders) {
        self.defaultHeaders = headers
    }
    
    private func mergeHeaders(headers: HTTPHeaders) -> HTTPHeaders {
        let dict: HTTPHeaders = defaultHeaders.merging(headers, uniquingKeysWith: { (first, _) in first })
        return dict
    }
    
    public func response<Resource>(for resource: Request<Resource>, method: HTTPMethod, parameters: Parameters, headers: HTTPHeaders, response resourceResult: @escaping ((Response<Resource>) -> Void)) {
        guard let url = URL(string: baseUrl.appending(resource.path)) else { return }
        let httpHeaders = mergeHeaders(headers: headers)
        print("URL: \(method.rawValue) \(url)")
        print("Parameters: \(parameters)")
        print("Headers: \(httpHeaders)")
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: httpHeaders)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { (response: DataResponse<Data>) in
                switch response.result {
                case .success(let data):
                    do {
                        let json = try JSON(data: data)
                        print("Response: \(json)")
                        let resourceValue = try resource.parser(json)
                        resourceResult(.success(resourceValue))
                    } catch let error as JSON.Error {
                        resourceResult(.error(error))
                    } catch let error as NSError {
                        resourceResult(.error(error))
                    } catch {
                        resourceResult(.error(NSError(domain: "API Error", code: 0, userInfo: nil)))
                    }
                case .failure(let error):
                    guard let data = response.data else {
                        resourceResult(.error(error))
                        return
                    }
                    do {
                        let json = try JSON(data: data)
                        let resourceValue = try resource.error(json)
                        resourceResult(.error(resourceValue))
                    } catch let error as JSON.Error {
                        resourceResult(.error(error))
                    } catch let error as NSError {
                        resourceResult(.error(error))
                    } catch {
                        resourceResult(.error(NSError(domain: "API Error", code: 0, userInfo: nil)))
                    }
                }
        }
    }
    
    public func responseNoContent(for resource: RequestNoContent, method: HTTPMethod, parameters: Parameters, headers: HTTPHeaders, response result: @escaping ((ResponseNoContent) -> Void)) {
        guard let url = URL(string: baseUrl.appending(resource.path)) else { return }
        let httpHeaders = mergeHeaders(headers: headers)
        print("URL: \(method.rawValue) \(url)")
        print("Parameters: \(parameters)")
        print("Headers: \(httpHeaders)")
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: httpHeaders)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { (response: DataResponse<Data>) in
                switch response.result {
                case .success:
                    result(.success)
                case .failure(let error):
                    guard let data = response.data else {
                        result(.error(error))
                        return
                    }
                    do {
                        let json = try JSON(data: data)
                        print("Response: \(json)")
                        let resourceValue = try resource.error(json)
                        result(.error(resourceValue))
                    } catch let error as JSON.Error {
                        result(.error(error))
                    } catch let error as NSError {
                        result(.error(error))
                    } catch {
                        result(.error(NSError(domain: "API Error", code: 0, userInfo: nil)))
                    }
                }
        }
    }
}

//
//  BaseService.swift
//  IMuzik
//
//  Created by nguyen.manh.tuanb on 24/12/2018.
//  Copyright © 2018 nguyen.manh.tuanb. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

enum Result<T> {
    case success(T)
    case error(NSError)
}

struct ImageUpload {
    var image: UIImage
    var name: String
}

final class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    init(accessToken: String) {
        self.accessToken = "Bearer " + accessToken
    }
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue(self.accessToken, forHTTPHeaderField: Constants.Server.httpTokenHeader)
        return urlRequest
    }
}

final class APIService {
    
    private var sessionManager: SessionManager!
    private let disposeBag = DisposeBag()
    
    static let instance: APIService = {
        let service = APIService()
        service.setHeader()
        return service
    }()
    
    private func setHeader() {
        var headers: HTTPHeaders = [:]
        headers["Content-Type"] = "application/json"
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        configuration.timeoutIntervalForRequest = 30
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func setAccessToken(token: String) {
        UserDefaultHelper.saveAccessToken(token: token)
        APIService.instance.sessionManager.adapter = AccessTokenAdapter(accessToken: token)
    }
    
    func validateAcessToken() -> Bool {
        let accessToken = UserDefaultHelper.getAccessToken()
        guard !accessToken.isEmpty else { return false }
        APIService.instance.setAccessToken(token: accessToken)
        return true
    }
}
extension APIService {
    
    func baseRequestAPI(_ api: API,
                        encoding: ParameterEncoding = JSONEncoding.default,
                        params: [String: Any]?) -> Observable<Result<JSON>> {
        
        return Observable.create { [unowned self] observer -> Disposable in
            guard let path = api.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                let error = NSError.make(message: "url error", code: 0)
                observer.onNext(Result.error(error))
                return Disposables.create()
            }
            
            print("API \(path)")
            
            let request = self.sessionManager.request(path,
                                                      method: api.method,
                                                      parameters: params,
                                                      encoding: encoding,
                                                      headers: nil)
            request
                .responseJSON { response in
                    print("\(response)")
                    let statusCode = response.response?.statusCode ?? 0
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        if 200 ... 300 ~= statusCode {
                            observer.onNext(Result.success(json))
                        } else {
                            let message = json["message"].stringValue
                            let errorCode = statusCode
                            let error = NSError.make(message: message, code: errorCode)
                            observer.onNext(Result.error(error))
                        }
                    case .failure(let error):
                        if  (error as NSError).code != NSURLErrorCancelled {
                            observer.onNext(Result.error(error as NSError))
                        }
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}


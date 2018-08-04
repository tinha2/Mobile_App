//
//  NLCloud.swift
//  DeepSocial
//
//  Created by Chung BD on 4/13/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire
import SwiftyCrypto
import SwiftyJWT
class NLCloud {
    
    static let share:NLCloud = NLCloud()
    
    static let languegeAPI = "https://language.googleapis.com/v1"
    static let visionAPI = "https://vision.googleapis.com/v1"
    static let speechToTextAPI = "https://speech.googleapis.com/v1"
    static let textToSpeechAPI = "https://texttospeech.googleapis.com/v1beta1"
    
    static let analyzeEntitiesEndpoint:String = "/documents:analyzeEntities"
    static let analyzeSentimentEndpoint:String = "/documents:analyzeSentiment"
    static let analyzeAnnotateText:String = "/documents:annotateText"
    static let extractAnnotateImage:String = "/images:annotate"
    static let recognizeSpeech:String = "/speech:recognize"
    static let synthesizeText:String = "/text:synthesize"
    
    static let key_BC:String = "AIzaSyBGx3xaGI7FFUBA1ZlfqihZmU36rR8lWQI"

    static let apiHost = "https://www.googleapis.com"
    static let tokenToken = "/oauth2/v4/token"

    static func creatJSonWebToken() -> String? {
        guard let base64PrivateKey = getPriveKey(fromFileName: "deepsocial-key",extensionType: "json") else {
            return nil
        }
        let nowSeconds:Int = Int(Date().timeIntervalSince1970)
        let expireSeconds:Int = nowSeconds + 60*60
        
        do {
            let privateKey = try RSAKey(base64String: base64PrivateKey, keyType: .PRIVATE)
            let alg = JWTAlgorithm.rs256(privateKey)
            var payload = JWTPayload()
//        let headerWithKeyId = JWTHeader()
            payload.audience = "https://www.googleapis.com/oauth2/v4/token"
            payload.issuer = "api-deepsocial@deepsocial-197607.iam.gserviceaccount.com"
            payload.issueAt = nowSeconds
            payload.expiration = expireSeconds
            payload.customFields = [
                "scope" : EncodableValue(value: "https://www.googleapis.com/auth/cloud-language https://www.googleapis.com/auth/cloud-vision https://www.googleapis.com/auth/cloud-platform")
            ]
            
            let jwtWithKeyId = JWT(payload: payload, algorithm: alg)
            return jwtWithKeyId?.rawString
        } catch {
            print("\(error)")
            return nil
        }
    }
    
    static func getPriveKey(fromFileName fileName:String,extensionType:String) -> String? {
        guard let jsonData = getDataFromFile(fileName,extensionType: extensionType) else {
            return nil
        }
        
        do {
            if let jsonDic = try JSONSerialization.jsonObject(with: jsonData) as? CommonDic {
                if let privateKey = jsonDic["private_key"] as? String {

                    return privateKey
                }
                
                return nil
            } else {
                return nil
            }
        } catch {
            print("Error deserializing JSON at IntroContent : \(error)")
            return nil
        }
    }

    static func getSentimentEntities(withContent content:String) -> Observable<Response> {
        let features = ["extractEntitySentiment":true,"classifyText":true,"extractDocumentSentiment": true]
        
        if !LocalCoordinator.share.isExpireToken {
            return requestToAnalysisText(endpoint: analyzeAnnotateText, content: content, feature: features)
                .map { Response($0) }
        }

        return Observable<Response>.create({ (observer) -> Disposable in
            
            guard let jwt = self.creatJSonWebToken() else {
                observer.onError(NLError.invalidParameter(content))
                return Disposables.create()
            }
            
            return self.requestToGetAccessToken(withJWT: jwt)
                .debug()
                .do(onNext: { (rep) in
                    LocalCoordinator.share.updateAccessToken(withResponse: rep)
                })
                .flatMap({ (_) ->  Observable<Response> in
                    return self.requestToAnalysisText(endpoint: analyzeAnnotateText, content: content, feature: features)
                        .map { Response($0) }
                })
                .subscribe(onNext: { observer.onNext($0) })
        })
        
    }
    
    static func synthesiseVoice(withContent voiceBase64:String,sampleRateHertz:Int,fileExtension:String) -> Observable<Response> {
        
        let config:CommonDic = [
            "encoding":fileExtension,
            "sampleRateHertz":sampleRateHertz,
            "languageCode": "en-US",
            "maxAlternatives": 30,
            "enableWordTimeOffsets": true
        ]
        
        if !LocalCoordinator.share.isExpireToken {
            return requestToRecognizeVoice(endpoint: recognizeSpeech, content: voiceBase64, configs: config)
                        .map { Response($0) }
        }
        
        return Observable<Response>.create({ (observer) -> Disposable in
            
            guard let jwt = self.creatJSonWebToken() else {
                observer.onError(NLError.invalidParameter(voiceBase64))
                return Disposables.create()
            }
            
            return self.requestToGetAccessToken(withJWT: jwt)
                .debug()
                .do(onNext: { (rep) in
                    LocalCoordinator.share.updateAccessToken(withResponse: rep)
                })
                .flatMap({ (_) ->  Observable<Response> in
                    return requestToRecognizeVoice(endpoint: recognizeSpeech, content: voiceBase64, configs: config)
                        .map { Response($0) }
                })
                .subscribe(onNext: { observer.onNext($0) })
        })
    }
    static func extractImage(withContent imageBase64:String) -> Observable<Response> {
        let features:[String] = ["LABEL_DETECTION","WEB_DETECTION","SAFE_SEARCH_DETECTION","TEXT_DETECTION","IMAGE_PROPERTIES"]
        
        if !LocalCoordinator.share.isExpireToken {
            return requestToExtractImage(endpoint: extractAnnotateImage, content: imageBase64, features: features)
                    .map { Response($0) }
        }
        
        return Observable<Response>.create({ (observer) -> Disposable in
            
            guard let jwt = self.creatJSonWebToken() else {
                observer.onError(NLError.invalidParameter(imageBase64))
                return Disposables.create()
            }
            
            return self.requestToGetAccessToken(withJWT: jwt)
                .debug()
                .do(onNext: { (rep) in
                    LocalCoordinator.share.updateAccessToken(withResponse: rep)
                })
                .flatMap({ (_) ->  Observable<Response> in
                    return self.requestToExtractImage(endpoint: extractAnnotateImage, content: imageBase64, features: features)
                        .map { Response($0) }
                })
                .subscribe(onNext: { observer.onNext($0) })
        })
        
    }
    
    static func synthesisText(withText text:String) -> Observable<Response> {
        
        if !LocalCoordinator.share.isExpireToken {
            return requestToSynthesisText(content: text)
                    .map { Response($0) }
        }
        
        return Observable<Response>.create({ (observer) -> Disposable in
            
            guard let jwt = self.creatJSonWebToken() else {
                observer.onError(NLError.invalidParameter(text))
                return Disposables.create()
            }
            
            return self.requestToGetAccessToken(withJWT: jwt)
                .debug()
                .do(onNext: { (rep) in
                    LocalCoordinator.share.updateAccessToken(withResponse: rep)
                })
                .flatMap({ (_) ->  Observable<Response> in
                    return requestToSynthesisText(content: text)
                        .map { Response($0) }
                })
                .subscribe(onNext: { observer.onNext($0) })
        })
    }
    
    static func getEntities(withContent content:String) -> Observable<[NLEntity]> {
        return requestToAnalysisText(endpoint: analyzeEntitiesEndpoint, content: content)
            .map { data in
                let entities = data["entities"] as? [[String: Any]] ?? []
                return entities
                    .compactMap(NLEntity.init)
                    .sorted { $0.name < $1.name }
            }
    }
    
    static func requestToAnalysisText(endpoint: String, content:String, feature:([String:Bool])? = nil) -> Observable<[String: Any]> {
        var bodyRequest:[String:Any] = [:]
        bodyRequest["encodingType"] = "UTF8"
        bodyRequest["document"] = [
            "type":"PLAIN_TEXT",
            "content":content
        ]
        
        if let rFeature = feature {
            bodyRequest["features"] = rFeature
        }
        
        let queryParam:[String:Any] = [:]
        
        let headers:[String:String] = [
            "Content-Type":"application/json; charset=utf-8",
            "Authorization":"Bearer \(LocalCoordinator.share.accessToken)"
        ]

        return requestJSON(host:languegeAPI,endpoint: endpoint, query: queryParam, headers:headers, jsonBody: bodyRequest)
    }
    
    static func requestToExtractImage(endpoint: String, content:String, features:[String] = []) -> Observable<[String: Any]> {
        var bodyRequest:[String:Any] = [:]
        
        var requestEle:[String:Any] = [:]
        
        var imageEle:Dictionary<String,String> = [:]
        imageEle["content"] = content
        requestEle["image"] = imageEle
        
        var listOfRequest:[[String:Any]] = []
        
        for feature in features {
            var typeEle:Dictionary<String,Any> = [:]
            typeEle["type"] = feature
            listOfRequest.append(typeEle)
        }
        
        requestEle["features"] = listOfRequest
        
        bodyRequest["requests"] = [
            requestEle
        ]
        
        
        let queryParam:[String:Any] = [:]
        //            "key": key_BC
        
        let headers:[String:String] = [
            "Content-Type":"application/json; charset=utf-8",
            "Authorization":"Bearer \(LocalCoordinator.share.accessToken)"
        ]
        
        return requestJSON(host:visionAPI,endpoint: endpoint, query: queryParam, headers:headers, jsonBody: bodyRequest)
                .map { data in
                    
                    var entitiesOutput:[CommonDic] = []
                    
                    if let entities = data["responses"] as? [CommonDic], entities.count > 0 {
                        entitiesOutput = entities
                    } else {
                        return data
                    }
                    return entitiesOutput[0]
                }
    }
    
    static func requestToSynthesisText(content: String) -> Observable<[String: Any]> {

        var requestEle:[String:Any] = [:]

        var inputEle:Dictionary<String,String> = [:]
        inputEle["text"] = content
        
        requestEle["input"] = inputEle
        
        var voiceConfig:[String:String] = [:]
        voiceConfig["languageCode"] = "en-gb"
        voiceConfig["name"] = "en-GB-Standard-A"
        voiceConfig["ssmlGender"] = "FEMALE"
        
        requestEle["voice"] = voiceConfig
        
        var audioConfig:[String:String] = [:]
        audioConfig["audioEncoding"] = "MP3"
        
        requestEle["audioConfig"] = audioConfig
        
        
        let queryParam:[String:Any] = [:]
        
        let headers:[String:String] = [
            "Content-Type":"application/json; charset=utf-8",
            "Authorization":"Bearer \(LocalCoordinator.share.accessToken)"
        ]
        
        return requestJSON(host:textToSpeechAPI,endpoint: synthesizeText, query: queryParam, headers:headers, jsonBody: requestEle)
        
    }
    
    static func requestToRecognizeVoice(endpoint: String, content:String, configs:CommonDic) -> Observable<[String: Any]> {
        var bodyRequest:[String:Any] = [:]
        
        bodyRequest["config"] = configs
        bodyRequest["audio"] = [ "content":content ]
        
        let queryParam:[String:Any] = [:]
        //            "key": key_BC
        
        let headers:[String:String] = [
            "Content-Type":"application/json; charset=utf-8",
            "Authorization":"Bearer \(LocalCoordinator.share.accessToken)"
        ]
        
        return requestJSON(host:speechToTextAPI,endpoint: endpoint, query: queryParam, headers:headers, jsonBody: bodyRequest)
            .map { data in
                
                var entitiesOutput:[CommonDic] = []
                
                if let entities = data["results"] as? [CommonDic], entities.count > 0 {
                    entitiesOutput = entities
                } else {
                    return data
                }
                return entitiesOutput[0]
        }
    }
    
    static func requestToGetAccessToken(withJWT jwt:String) -> Observable<[String:Any]> {
        var bodyRequest:[String:Any] = [:]
        bodyRequest["grant_type"] = "urn:ietf:params:oauth:grant-type:jwt-bearer"
        bodyRequest["assertion"] = jwt
        
        return requestURLEncoded(host: apiHost, endpoint: tokenToken, body: bodyRequest)
    }
    
    static func requestJSON(host:String ,endpoint: String, query: [String: Any] = [:], headers:[String:String] = [:] , jsonBody:[String:Any] = [:] ) -> Observable<[String: Any]> {
        do {
            guard let url = URL(string: host)?.appendingPathComponent(endpoint),
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                    throw NLError.invalidURL(endpoint)
            }
            components.queryItems = try query.compactMap { (key, value) in
                guard let v = value as? CustomStringConvertible else {
                    throw NLError.invalidParameter(key)
                }
                return URLQueryItem(name: key, value: v.description)
            }
            guard let finalURL = components.url else {
                throw NLError.invalidURL(endpoint)
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody)
            
            var request = URLRequest(url: finalURL)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            headers.forEach({ (key,val) in
                request.setValue(val, forHTTPHeaderField:key)
            })
            
            return URLSession.shared.rx.response(request: request)
                .map { _, data -> [String: Any] in
                    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                        let result = jsonObject as? [String: Any] else {
                            throw NLError.invalidJSON(finalURL.absoluteString)
                    }
                    return result
            }
        } catch {
            return Observable.empty()
        }
    }
    
    static func requestURLEncoded(host:String ,endpoint: String, body:[String:Any] = [:] ) -> Observable<[String:Any]>  {
            return Observable<[String:Any]>.create({ (observer) -> Disposable in
                guard let url = URL(string: host)?.appendingPathComponent(endpoint) else {
                    observer.onError(NLError.invalidURL(endpoint))
                    return Disposables.create()
                }
                
                Alamofire.request(url, method: .post, parameters: body, encoding: URLEncoding.httpBody)
                    .responseJSON(completionHandler: { (resp) in
                        if let json = resp.value as? [String:Any],let _ = json["access_token"] as? String {
                            observer.onNext(json)
                        } else {
                            observer.onError(NLError.invalidResponse(endpoint))
                        }
                    })
                    .responseString(completionHandler: { (resp) in
                        print("response from OAuth2ServiceAccount: \(String(describing: resp.value))")
                    })
                return Disposables.create()
            })
    }
    
    //MARK: - Access Token
    
    static func getAccessToken() -> Observable<Response> {
        
        if !LocalCoordinator.share.isExpireToken {
            return Observable<Response>.of(Response.data([LocalCoordinator.share.kAccessToken:LocalCoordinator.share.accessToken]))
        }
        
        return Observable<Response>.create({ (observer) -> Disposable in
            
            guard let jwt = self.creatJSonWebToken() else {
                observer.onError(NLError.cannotTakeAccessToken)
                return Disposables.create()
            }
            
            return self.requestToGetAccessToken(withJWT: jwt)
                .debug()
                .do(onNext: { (rep) in
                    LocalCoordinator.share.updateAccessToken(withResponse: rep)
                })
                .map { Response($0) }
                .subscribe(onNext: { observer.onNext($0) })
        })
    }
}

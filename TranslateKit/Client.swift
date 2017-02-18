//
//  Client.swift
//  TranslateKit
//
//  Created by Lionel on 1/23/16.
//  Copyright © 2016 weTranslate. All rights reserved.
//

import Foundation

open class Client {

    fileprivate let URLSession: Foundation.URLSession
    fileprivate let urbanDictionaryBaseUrl = "http://api.urbandictionary.com/v0"
    fileprivate let wordReferenceBaseUrl: String

    public init(wordReferenceApiKey: String, URLSession: Foundation.URLSession = defaultSession) {
        self.wordReferenceBaseUrl = "http://api.wordreference.com/\(wordReferenceApiKey)/json/"
        self.URLSession = URLSession
    }

    static let defaultSession: Foundation.URLSession = {
        let configuration = URLSessionConfiguration.default
        return Foundation.URLSession(configuration: configuration)
    }()


    // MARK: - API

    // MARK: Urban Dictionary
    open func define(slang word: String, completion: @escaping (Result<[SlangDefinition]>) -> Void) {

        guard let URL = URL(string: "\(urbanDictionaryBaseUrl)/define?term=\(word)") else {
            dispatch(result: .failure, completion: completion)
            return
        }

        let request = NSMutableURLRequest(url: URL)

        performRequest(request as URLRequest) { result in
            guard case .success(let dictionary) = result,
                let list = dictionary["list"] as? [JSONDictionary] else {
                    self.dispatch(result: .failure, completion: completion)
                    return
            }

            let definitions = list.flatMap { SlangDefinition(dictionary: $0) }
            self.dispatch(result: .success(definitions), completion: completion)
        }
    }


    // MARK: Word Reference

    open func translate(word: String, from: Language, to: Language, completion: @escaping (Result<Translation?>) -> Void) {

        guard let URL = URL(string: "\(wordReferenceBaseUrl)/\(from.code())\(to.code())/\(word)") else {
            dispatch(result: .failure, completion: completion)
            return
        }

        let request = NSMutableURLRequest(url: URL)

        performRequest(request as URLRequest) { result in
            switch result {
            case .success(let dictionary):
                if let translation = Translation(webserviceDictionary: dictionary, searchText: word, from: from, to: to) {
                    self.dispatch(result: .success(translation), completion: completion)
                } else {
                    self.dispatch(result: .success(nil), completion: completion)
                }
            case .failure:
                self.dispatch(result: .failure, completion: completion)
            }
        }
    }

    // MARK: - Private

    fileprivate func performRequest(_ URLRequest: Foundation.URLRequest, completion: @escaping (Result<JSONDictionary>) -> Void) -> URLSessionDataTask? {

        let task = URLSession.dataTask(with: URLRequest, completionHandler: { data, response, error in
            guard let data = data,
                let parseData = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = parseData as? JSONDictionary else {
                    completion(.failure)
                    return
            }

            completion(.success(json))
        }) 

        task.resume()
        return task
    }

    fileprivate func dispatch<T>(result: T, completion: @escaping (T) -> Void) {
        DispatchQueue.main.async { completion(result) }
    }
}

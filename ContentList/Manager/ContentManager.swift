//
//  ContentManager.swift
//  ContentList
//
//  Created by Muhammad Riaz on 15/09/2021.
//

import Foundation
import Alamofire

enum ContentListError: Error, LocalizedError {
    
    case unknown
    case invalidId
    case custom(description: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidId:
            return "This is an invalid ID. Please try again."
        case .unknown:
            return "Hey, this is an unknown error!"
        case .custom(let description):
            return description
        }
    }
    
}

struct ContentManager {
    
    func fetchContent(completion: @escaping (Result<ContentListData, Error>) -> Void) {
        let urlString = "http://dynamic.pulselive.com/test/native/contentList.json"
        handleContentRequest(urlString: urlString, completion: completion)
    }
    
    func fetchDetails(byItem id: Int, completion: @escaping (Result<ContentDetailsData, Error>) -> Void) {
        let stringId = String(id)
        let path = "http://dynamic.pulselive.com/test/native/content/%@.json"
        let urlString = String(format: path, stringId)
        handleDetailsRequest(urlString: urlString, completion: completion)
    }
    
    private func handleDetailsRequest(urlString: String, completion: @escaping (Result<ContentDetailsData, Error>) -> Void) {
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: ContentDetailsData.self, queue: .main, decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let detailsData):
                completion(.success(detailsData))
            case .failure(let error):
                print(error)
                if let err = self.getContentError(error: error, data: response.data) {
                    completion(.failure(err))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func handleContentRequest(urlString: String, completion: @escaping (Result<ContentListData, Error>) -> Void) {
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: ContentListData.self, queue: .main, decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let contentsData):
                completion(.success(contentsData))
            case .failure(let error):
                print(error)
                if let err = self.getContentError(error: error, data: response.data) {
                    completion(.failure(err))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func getContentError(error: AFError, data: Data?) -> Error? {
        if error.responseCode == 404,
            let data = data,
            let failure = try? JSONDecoder().decode(ContentDataFailure.self, from: data) {
            let message = failure.message
            return ContentListError.custom(description: message)
        } else {
            return nil
        }
    }
}

//
//  URLSessionExtension.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 25/09/21.
//

import Foundation
import RxSwift

extension URLSession {
    
    enum CustomError: Error {
        case invalidUrl
        case invalidData
    }
    
    func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        
        let task = dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.invalidData))
                }
                return
            }
        
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func requestObserver<T: Codable>(url: URL?, expecting: T.Type) -> Observable<T> {
        return Observable.create { observer in
            let session = URLSession.shared
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            session.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil, let response = response as? HTTPURLResponse else { return }
                if response.statusCode == 200 {
                    do {
                        let result = try JSONDecoder().decode(expecting, from: data)
                        observer.onNext(result)
                    } catch let error {
                        print("Unknowm error: \(error)")
                        observer.onError(error)
                    }
                }
                else if response.statusCode == 401 {
                    print("Unauthorized error")
                }
                observer.onCompleted()
            }.resume()
            
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
        }
    }
}

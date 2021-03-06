//
//  URLSessionExtension.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 25/09/21.
//

import Foundation
import RxSwift

extension URLSession {
    
    func request<T: Codable>(url: URL?, expecting: T.Type) -> Observable<T> {
        return Observable.create { observer in
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            self.dataTask(with: request) { (data, response, error) in
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
                self.finishTasksAndInvalidate()
            }
        }
    }
}

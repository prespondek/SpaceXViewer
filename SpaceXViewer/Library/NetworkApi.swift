//
//  REST.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 5/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation
import RxSwift


class NetworkApi {
    static func GET<T: Decodable>(url: URL) -> Observable<T> {
        return Observable<T>.create { observer in
            var request = URLRequest(url:url)
            request.httpMethod = "GET"
            let session = URLSession(configuration: .ephemeral,  delegate: nil, delegateQueue: .main)
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                /*if let jsonString = String(data: data ?? Data(), encoding: .utf8) {
                   print(jsonString)
                }*/
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let model = try decoder.decode(T.self, from: data ?? Data())
                    observer.onNext( model )
                } catch let error {
                    observer.onError(error)
                    print(error.localizedDescription)
                }
                observer.onCompleted()
            })
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

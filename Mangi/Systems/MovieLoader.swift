//
//  MovieLoader.swift
//  Mangi
//
//  Created by Marco Mempin on 10/6/17.
//  Copyright © 2017 marcowesome. All rights reserved.
//

import Foundation
import Moya

class MovieLoader {
    
    func getMovieDetails(for id: Int, completion: @escaping (Movie) -> Void) {
        let provider = MoyaProvider<MangiAPI>()
        provider.request(.movie(id: id)) { result in
            switch result {
            case let .success(response):
                do {
                    let objectDictionary = try response.mapJSON() as! [String : Any]
                    
                    let movie = Movie.fromJSON(objectDictionary)
                    
                    completion(movie)
                    
                } catch {
                    
                }
                
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    print("Cannot convert error to String")
                    break
                }
                print(error.description)
            }
        }
    }
    
}

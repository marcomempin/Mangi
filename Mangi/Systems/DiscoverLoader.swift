//
//  DiscoverLoader.swift
//  Mangi
//
//  Created by Marco Mempin on 10/6/17.
//  Copyright © 2017 marcowesome. All rights reserved.
//

import Foundation
import Moya

class DiscoverLoader {
    
    var movies: [Movie] = []
    
    func getMovies(for page: Int = 1, completion: @escaping () -> Void) {
        let provider = MoyaProvider<MangiAPI>()
        provider.request(.discover(page: page)) { result in
            switch result {
            case let .success(response):
                do {
                    let objectDictionary = try response.mapJSON() as! [String : Any]
                    
                    let resultsArray = objectDictionary["results"] as! [[String : Any]]
                    
                    for movieJSON in resultsArray {
                        let movie = Movie.fromJSON(movieJSON)
                        self.movies.append(movie)
                    }
                    
                    completion()
                    
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

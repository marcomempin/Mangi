//
//  MangiAPI.swift
//  Mangi
//
//  Created by Marco Mempin on 10/6/17.
//  Copyright © 2017 marcowesome. All rights reserved.
//

import Foundation
import Moya

enum MangiAPI {
    case discover(page: Int)
    case movie(id: Int)
}

extension MangiAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://api.themoviedb.org/3/")!
    }
    
    var path: String {
        switch self {
        case .discover:
            return "discover/movie"
            
        case .movie(let id):
            return "movie/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return Data()
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        var params: [String : Any] = [:]
        params["api_key"] = "328c283cd27bd1877d9080ccb1604c91"
        
        switch self {
        case .discover(let page):
            //primary_release_date.lte=2016-12-31&sort_by=release_date.desc&page=1
            params["primary_release_date.lte"] = "2016-12-31"
            params["sort_by"] = "release_date.desc"
            params["page"] = page
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)

        case .movie:
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        }
    }
    
    // The headers to be used in the request.
    var headers: [String: String]? {
        return nil
    }
}

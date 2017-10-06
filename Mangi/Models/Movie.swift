//
//  Movie.swift
//  Mangi
//
//  Created by Marco Mempin on 10/6/17.
//  Copyright © 2017 marcowesome. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Genre {
    let id: String
    let name: String
}

struct Language {
    let iso: String
    let name: String
}

final class Movie: NSObject, JSONAbleType {
    let id: String
    let title: String
    let popularity: String
    let posterPath: String
    let backdropPath: String?
    let overview: String
    let genres: [Genre]
    let language: [Language]
    let duration: String
    
    init(id: String, title: String, popularity: String, posterPath: String, backdropPath: String? = nil, overview: String, genres: [Genre], language: [Language], duration: String) {
        self.id = id
        self.title = title
        self.popularity = popularity
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.genres = genres
        self.language = language
        self.duration = duration
    }
    
    static func fromJSON(_ source: [String : Any]) -> Movie {
        let json = JSON(source)
        
        let id = json["id"].stringValue
        let title = json["title"].stringValue
        let popularity = json["popularity"].stringValue
        let posterPath = json["poster_path"].stringValue
        let backdropPath = json["backdrop_path"].string
        let overview = json["overview"].stringValue
        let genres = json["genres"].arrayObject as! [Genre]
        let language = json["spoken_languages"].arrayObject as! [Language]
        let duration = json["runtime"].stringValue
        
        return Movie(id: id, title: title, popularity: popularity, posterPath: posterPath, backdropPath: backdropPath, overview: overview, genres: genres, language: language, duration: duration)
    }
    
}

//
//  Movie.swift
//  Mangi
//
//  Created by Marco Mempin on 10/6/17.
//  Copyright © 2017 marcowesome. All rights reserved.
//

import UIKit
import SwiftyJSON
import IGListKit

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
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let genres: [Genre]?
    let languages: [Language]?
    let duration: String
    
    init(id: String, title: String, popularity: String, posterPath: String, backdropPath: String? = nil, overview: String, genres: [Genre]? = nil, languages: [Language]? = nil, duration: String) {
        self.id = id
        self.title = title
        self.popularity = popularity
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.genres = genres
        self.languages = languages
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
        
        let genreJSONArray = json["genres"].arrayObject
        var genres = [Genre]()
        if genreJSONArray != nil {
            for genreJSON in genreJSONArray! {
                let json = JSON(genreJSON)
                let genre = Genre(id: json["id"].stringValue, name: json["name"].stringValue)
                genres.append(genre)
            }
        }
        
        let languageJSONArray = json["spoken_languages"].arrayObject
        var languages = [Language]()
        if languageJSONArray != nil {
            for languageJSON in languageJSONArray! {
                let json = JSON(languageJSON)
                let genre = Language(iso: json["iso_639_1"].stringValue, name: json["name"].stringValue)
                languages.append(genre)
            }
        }
        
        let duration = json["runtime"].stringValue
        
        return Movie(id: id, title: title, popularity: popularity, posterPath: posterPath, backdropPath: backdropPath, overview: overview, genres: genres, languages: languages, duration: duration)
    }
    
}

extension Movie: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Movie else { return false }
        if self === object { return true }
        return self.id == object.id && self.title == object.title
    }
}

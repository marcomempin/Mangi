//
//  JSONAble.swift
//  Mangi
//
//  Created by Marco Mempin on 10/6/17.
//  Copyright © 2017 marcowesome. All rights reserved.
//

protocol JSONAbleType {
    static func fromJSON(_: [String: Any]) -> Self
}

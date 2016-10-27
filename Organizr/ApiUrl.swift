//
//  ApiUrl.swift
//  Organizr
//
//  Created by João Ricardo Bastos on 22/10/16.
//  Copyright © 2016 João Ricardo Bastos. All rights reserved.
//

import Foundation

struct ApiUrl {

    static let BaseUrl = "http://192.168.0.12:3000"

    static let Sessions = "\(BaseUrl)/sessions"
    static let Users = "\(BaseUrl)/users"
    static let Lists = "\(BaseUrl)/lists"
}
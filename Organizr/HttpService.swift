    //
//  HttpService.swift
//  Organizr
//
//  Created by João Ricardo Bastos on 22/10/16.
//  Copyright © 2016 João Ricardo Bastos. All rights reserved.
//

import Foundation

class HttpService {

    func postRequest(url: String, params: NSData?, callback: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let url = NSURL(string: url)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.HTTPBody = params

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            callback(data, response, error)
        }

        task.resume()
    }
}
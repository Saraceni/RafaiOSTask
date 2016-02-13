//
//  RequestHelper.swift
//  RafaiOSTask
//
//  Created by Saraceni on 2/13/16.
//  Copyright © 2016 rafa. All rights reserved.
//

import Foundation
import Alamofire

class RequestHelper
{
    static let SECTION_HOT = "hot"
    static let SECTION_TOP = "top"
    static let SECTION_USER = "user"
    
    static func performRequest(section: String, page: String, viral: Bool, callback: ResponseProtocol)
    {
        // https://api.imgur.com/3/gallery/{section}/{sort}/{page}?showViral=bool
        
        let header = [
            "Authorization": "Client-ID 56c5ec8b7f7da3e"
        ]
        
        var url = "https://api.imgur.com/3/gallery/" + section + "/" + page + "/?"
        if viral { url += "showViral=true" }
        else { url += "showViral=false" }
        
        /*Alamofire.request(.GET, "https://api.imgur.com/3/gallery/hot/viral/0.json", headers: header)
            .responseJSON { (response) in
                print(response)
        }*/
        
        Alamofire.request(.GET, url, headers: header)
            .responseJSON { (response) in
                callback.response(response)
        }
    }
    
    static func performRequest(section: String, page: String, viral: Bool, callback: (response: (Response<AnyObject, NSError>))->())
    {
        // https://api.imgur.com/3/gallery/{section}/{sort}/{page}?showViral=bool
        
        let header = [
            "Authorization": "Client-ID 56c5ec8b7f7da3e"
        ]
        
        var url = "https://api.imgur.com/3/gallery/" + section + "/" + page + "/?"
        if viral { url += "showViral=true" }
        else { url += "showViral=false" }
        
        /*Alamofire.request(.GET, "https://api.imgur.com/3/gallery/hot/viral/0.json", headers: header)
        .responseJSON { (response) in
        print(response)
        }*/
        
        Alamofire.request(.GET, url, headers: header)
            .responseJSON { (response) in
                callback(response: response)
        }
    }
    
}

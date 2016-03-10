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
    
    struct Imgur {
        static let APIBaseURL = "https://api.imgur.com/3/"
    }
    
    struct ImgurParameterKeys {
        static let APIKey = "Authorization"
        static let Gallery = "gallery"
        static let ShowViral = "showViral"
    }
    
    struct ImgurParameterValues {
        static let APIKey = "Client-ID 56c5ec8b7f7da3e"
    }
    
    static func performRequest(section: String, page: String, viral: Bool, sort: String?, window: String?, callback: (response: (Response<AnyObject, NSError>), requestUUID: String)->()) -> String
    {
        // https://api.imgur.com/3/gallery/{section}/{sort}/{page}?showViral=bool
        
        let requestUUID = NSUUID().UUIDString
        
        let header = [
            ImgurParameterKeys.APIKey: ImgurParameterValues.APIKey
        ]
        
        let showViral = viral ? "true" : "false"
        var url = Imgur.APIBaseURL + ImgurParameterKeys.Gallery + "/" + section + "/"
        if sort != nil { url += sort! + "/" }
        if window != nil { url += window! + "/" }
        url += page + "/?" + ImgurParameterKeys.ShowViral + "=" + showViral
        
        Alamofire.request(.GET, url, headers: header)
            .responseJSON { (response) in
                callback(response: response, requestUUID: requestUUID)
        }
        
        return requestUUID
    }
    
}

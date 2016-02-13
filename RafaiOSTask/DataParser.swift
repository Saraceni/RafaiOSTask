//
//  DataParser.swift
//  RafaiOSTask
//
//  Created by Saraceni on 2/13/16.
//  Copyright © 2016 rafa. All rights reserved.
//

import Foundation
import Alamofire

class DataParser
{
    static func getArrays(response: (Response<AnyObject, NSError>)) -> NSArray?
    {
        switch response.result
        {
        case .Success(_):
            
            
            if let array = response.result.value as? NSDictionary
            {
                if let data = array["data"] as? NSArray { return data }
                else { return nil }
            } else { return nil }
            
        case .Failure(_):
            return nil
        }
    }
}
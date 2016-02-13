//
//  JSONHandler.swift
//  RafaiOSTask
//
//  Created by Saraceni on 2/13/16.
//  Copyright © 2016 rafa. All rights reserved.
//

import Foundation

class JSONHandler
{
    static func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        
        
        if NSJSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }
    
    static func JSONParseArray(string: String) -> [AnyObject]{
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding){
            
            do{
                
                if let array = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)  as? [AnyObject] {
                    return array
                }
            }catch{
                
                print("error")
                
            }
        }
        return [AnyObject]()
    }
    
    static func JSONParseDictionary(string: String) -> [String: AnyObject]{
        
        
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding){
            
            do{
                if let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject]{
                    
                    return dictionary
                    
                }
            }catch {
                
                print("error")
            }
        }
        return [String: AnyObject]()
    }
}

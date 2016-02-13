//
//  ResponseProtocol.swift
//  RafaiOSTask
//
//  Created by Saraceni on 2/13/16.
//  Copyright © 2016 rafa. All rights reserved.
//

import Foundation
import Alamofire

protocol ResponseProtocol
{
    func response(response: (Response<AnyObject, NSError>))
}

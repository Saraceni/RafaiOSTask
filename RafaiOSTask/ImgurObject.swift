//
//  ImgurObject.swift
//  RafaiOSTask
//
//  Created by Saraceni on 3/6/16.
//  Copyright © 2016 rafa. All rights reserved.
//

import Foundation

class ImgurObject {
    
    var link: String
    var firstImageLink: String?
    var description: String?
    var isAlbum = false
    var title: String?
    var ups: Int?
    var downs: Int?
    var score: Int?
    
    init(link: String) {
        self.link = link
    }
}
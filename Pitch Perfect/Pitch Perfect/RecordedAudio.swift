//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Patrick Hyland on 23/4/2015.
//  Copyright (c) 2015 WhipDev. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathURL: NSURL!
    var title: String!
    init(filePathURL:NSURL! , title:String!)
    {
    	self.filePathURL = filePathURL
    	self.title = title
    }
}

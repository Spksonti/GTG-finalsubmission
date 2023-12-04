//
//  User.swift
//  GTG
//
//  Created by Shriman Sonti on 11/1/23.
//

import Foundation

class User
{
    public var first_name: String?
    public var last_name: String?
    public var uid: String?
    
    init(fn: String, ln: String, uid: String)
    {
        first_name = fn
        last_name = ln
        self.uid = uid
    }
}

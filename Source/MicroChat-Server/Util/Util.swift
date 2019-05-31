//
//  Util.swift
//  COpenSSL
//
//  Created by Tian Ming on 2019/5/30.
//

import Foundation

class Util: NSObject {
    class func createToken() -> String {
        let str = "\(NSDate.init().timeIntervalSince1970)"
        return str.md5Value
    }
}

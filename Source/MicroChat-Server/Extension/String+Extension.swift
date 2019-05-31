//
//  String+Extension.swift
//  MicroChat-Server
//
//  Created by Tian Ming on 2019/5/31.
//

import Foundation
import CommonCrypto

extension String {
    var md5Value: String {
        let str = cString(using: .utf8)
        let strLen = CC_LONG(lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        var hash = ""
        for i in 0..<digestLen {
            hash = hash.appendingFormat("%02x", result[i])
        }
        result.deallocate()
        
        return hash
    }
}

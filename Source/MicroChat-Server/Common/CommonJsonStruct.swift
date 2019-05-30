//
//  CommonJsonStruct.swift
//  MicroChat-Server
//
//  Created by Tian Ming on 2019/5/30.
//

import Foundation

/** 成功结构 */
public func successBody(message:String, data:Any) -> [String:Any] {
    return ["code":1,
            "message":message,
            "data":data]
}

/** 错误结构 */
public func errorBody(code:Int, message:String) -> [String:Any] {
    return ["code":code,
            "message":message,
            "data":""]
}

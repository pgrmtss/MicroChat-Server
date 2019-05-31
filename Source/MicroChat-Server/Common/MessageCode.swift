//
//  MessageCode.swift
//  MicroChat-Server
//
//  Created by Tian Ming on 2019/5/31.
//

import Foundation
import PerfectLib
import PerfectHTTP

enum MsgType: Int {
    case register = 1
    case login = 2
}

func sendMsgCodeHandler(request:HTTPRequest, response:HTTPResponse) {
    let mobile = request.param(name: "mobile")
    let typeStr = request.param(name: "type")
    
    if(mobile?.isEmpty ?? true && mobile!.count != 11) {
        let errjson = errorBody(code: -1, message: "请输入11位手机号")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    
    if typeStr?.isEmpty ?? true {
        let errjson = errorBody(code: -1, message: "缺少参数:type")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    
    let type = Int(typeStr!) ?? -1
    if type < 1 || type > 2 {
        let errjson = errorBody(code: -1, message: "参数错误")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    
    let code = createMsgCode()
    let dic:[String:Any] = ["code":code,"time":Date().timeIntervalSince1970, "type":type]
    UserDefaults.standard.set(dic, forKey: mobile!)
    
    let codeJson = ["code":code]
    let successJson = successBody(message: "获取验证码成功", data: codeJson)
    try! response.setBody(json: successJson)
    response.completed()
}

func createMsgCode() -> String {
    let code = Int(arc4random() % 9999) + 1000
    return "\(code)"
}

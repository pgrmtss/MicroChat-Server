//
//  LoginController.swift
//  MicroChat-Server
//
//  Created by Tian Ming on 2019/5/30.
//

import Foundation
import PerfectHTTP
import MySQLStORM

/** 通过账户名称和密码登录 */
func mobileLoginHandler(request:HTTPRequest, response:HTTPResponse) {
    
    let mobile = request.param(name: "mobile")
    let code = request.param(name: "code")
    
    if mobile?.isEmpty ?? true || mobile!.count != 11 {
        let errjson = errorBody(code: -1, message: "请输入11为手机号")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    if code?.isEmpty ?? true {
        let errjson = errorBody(code: -1, message: "请输入验证码")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    
    let findParam = ["mobile":mobile!,"code":code!]
    var user: UserModel!
    do {
        try user = getUser(byParams: findParam)
        user.token = Util.createToken()
        try updateUserInfo(byParams: ["token":user.token], idName: "userId", idValue: user.id)
        try user = getUser(byParams: ["userId":user.id])
    } catch {
        print("Error: \(error.localizedDescription)")
        let errjson = errorBody(code: -1, message: "服务器异常")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    
    if(user.id.isEmpty) {
        let errjson = errorBody(code: -1, message: "验证码错误")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    
    // 用户存在且密码正确
    print("Get User Success User:\(user.id) \(user.nickname)")
    let userJson: [String : Any] = ["id":user.id,
                                    "mobile":user.mobile,
                                    "nickname":user.nickname,
                                    "gender":user.gender,
                                    "token":user.token]
    let successJson = successBody(message: "登录成功", data: userJson)
    try! response.setBody(json: successJson)
    response.completed()
}


/** 通过用户名密码注册 */
func mobileRegisterHandler(request:HTTPRequest, response:HTTPResponse) {
    let mobile = request.param(name: "mobile")
    let code = request.param(name: "code")
    
    if mobile?.isEmpty ?? true || mobile!.count != 11 {
        let errjson = errorBody(code: -1, message: "请输入11位手机号")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    if code?.isEmpty ?? true {
        let errjson = errorBody(code: -1, message: "请输入验证码")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    
    var user: UserModel!
    // 检查手机号是否存在
    do {
        try user = getUser(byParams: ["mobile":mobile!])
    } catch  {
        print("Error: \(error.localizedDescription)")
        let errjson = errorBody(code: -1, message: "服务器异常")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    if !user.id.isEmpty {
        let errjson = errorBody(code: -1, message: "该手机号已被注册")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    
    let sendCode = UserDefaults.standard.value(forKey: mobile!) as? [String:Any]
    if sendCode == nil || sendCode!["code"] as! String != code! || (Date().timeIntervalSince1970 - (sendCode!["time"] as! Double) > 60 * 3) {
        let errjson = errorBody(code: -1, message: "验证码错误")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    
    // 保存用户
    
    
    // 清理验证码缓存
    UserDefaults.standard.removeObject(forKey: mobile!)
    let successJson = successBody(message: "注册成功", data: "")
    try! response.setBody(json: successJson)
    response.completed()
}


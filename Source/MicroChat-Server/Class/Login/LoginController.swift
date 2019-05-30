//
//  LoginController.swift
//  MicroChat-Server
//
//  Created by Tian Ming on 2019/5/30.
//

import Foundation
import PerfectHTTP

func normalLoginHandler(request:HTTPRequest, response:HTTPResponse) {
    
    let userAccount = request.param(name: "userAccount")
    let password = request.param(name: "password")
    
    if userAccount?.isEmpty ?? true {
        let errjson = errorBody(code: -1, message: "用户名称不能为空")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    if password?.isEmpty ?? true {
        let errjson = errorBody(code: -1, message: "密码不能为空")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }
    
    let db = DBUtil()
    let rs = db.selectDataBaseSQLwhere(tableName: "user", keys: "userId,userNickName,userGender,userMobile,token,userAccount,password", condition: "userAccount=\(userAccount!)").keyValues
    if rs.count == 0 {
        let errjson = errorBody(code: -1, message: "用户不存在")
        try! response.setBody(json: errjson)
        response.completed()
        return
    }else {
        let user = rs.first!
        print("\(rs.description)")
        if user["password"] == password {
            let successJson = successBody(message: "登录成功", data: user)
            try! response.setBody(json: successJson)
            response.completed()
            return
        }else {
            print("\(user["password"]), \(password)")
            let errjson = errorBody(code: -1, message: "密码错误")
            try! response.setBody(json: errjson)
            response.completed()
            return
        }
    }
}

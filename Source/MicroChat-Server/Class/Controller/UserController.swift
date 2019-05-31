//
//  UserController.swift
//  MicroChat-Server
//
//  Created by Tian Ming on 2019/5/31.
//

import Foundation
import StORM
import MySQLStORM

/**
 根据条件字典获取用户
 -Parameter:
 -params:["userId":"201900001"]
 */

func getUser(byParams params:[String:Any]) throws -> UserModel {
    let user = UserModel()
    do {
        try user.find(params)
    } catch {
        throw error
    }
    return user
}
/** 更新用户信息 */
func updateUserInfo(byParams params:[String:Any], idName:String, idValue:Any) throws {
    var paramTuples = [(String,Any)]()
    for item in params {
        let tuple = (item.key, item.value)
        paramTuples.append(tuple)
    }
    let user = UserModel()
    do {
        try user.update(data: paramTuples, idName: idName, idValue: idValue)
    } catch {
        throw error
    }
}

/** 添加用户 */
func addUser(byParams:[String:Any]) {
    
}

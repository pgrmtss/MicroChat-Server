//
//  RouteManager.swift
//  MicroChat-Server
//
//  Created by Tian Ming on 2019/5/30.
//

import Foundation
import PerfectLib
import PerfectHTTP

class RouteManager {
    var routes: [Route] {
        return [
            Route(method: .post, uri: "api/login/register", handler: mobileRegisterHandler(request:response:)),
            Route(method: .post, uri: "api/login/normalLogin", handler: mobileLoginHandler(request:response:)),
            Route(method: .get, uri: "api/getCode", handler: sendMsgCodeHandler(request:response:))
        ]
    }
}



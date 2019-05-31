import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import StORM
import MySQLStORM

let root = "./webroot"

// 配置服务器端口、根目录等
let server = HTTPServer()
server.serverPort = 8181
server.documentRoot = root

// 配置数据库连接参数
MySQLConnector.host        = "localhost"
MySQLConnector.username    = "root"
MySQLConnector.password    = "123456"
MySQLConnector.database    = "MicroChat"
MySQLConnector.port        = 3306

// 配置路由
let basic = RouteManager()
server.addRoutes(Routes(basic.routes))

do {
    try server.start() // 开启服务器
} catch PerfectError.networkError(let err, let msg) {
    print("Netword error thrown: \(err) \(msg)")
}

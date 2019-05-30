//
//  DBUtil.swift
//  COpenSSL
//
//  Created by Tian Ming on 2019/5/30.
//

import Foundation
import PerfectMySQL

// MARK: 数据库信息
#if os(Linux) // 在Ubuntu下
let user = "root"
let password = "123456"
let dataBase = "MicroChat"
let host = "0.0.0.0"

#else
let user = "root"
let password = "123456"
let dataBase = "MicroChat"
let host = "0.0.0.0"
#endif



open class DBUtil {
    
    fileprivate var mysql: MySQL
    internal init() {
        mysql = MySQL.init()                           //创建MySQL对象
        guard connectedDataBase() else {               //开启MySQL连接
            return
        }
    }
    
    // MARK: 开启连接
    private func connectedDataBase() -> Bool {
        
        let connected = mysql.connect(host: host, user: user, password: password, db: dataBase)
        guard connected else {
            print(mysql.errorMessage())
            return false
        }
        print("MySQL Connect Success")
        return true
        
    }
    
    // MARK: 执行SQL语句
    /// 执行SQL语句
    ///
    /// - Parameter sql: sql语句
    /// - Returns: 返回元组(success:是否成功 result:结果)
    @discardableResult
    func mysqlStatement(_ sql: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        
        guard mysql.selectDatabase(named: dataBase) else {            //指定database
            let msg = "NO\(dataBase)Database"
            print(msg)
            return (false, nil, msg)
        }
        
        let successQuery = mysql.query(statement: sql)                      //sql语句
        guard successQuery else {
            let msg = "SQL_Error: \(sql)"
            print(msg)
            return (false, nil, msg)
        }
        let msg = "SQL_Success: \(sql)"
        print(msg)
        return (true, mysql.storeResults(), msg)                            //sql执行成功
        
    }
    
    /// 执行sql
    ///
    /// - Parameters:
    ///   - sql: SQL语句
    func quaryDatabaseSQL(sql:String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        return mysqlStatement(sql)
    }


    /// 增
    ///
    /// - Parameters:
    ///   - tableName: 表
    ///   - key: 键  （键，键，键）
    ///   - value: 值  ('值', '值', '值')
    func insertDatabaseSQL(tableName: String, key: String, value: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String){
        let SQL = "INSERT INTO \(tableName) (\(key)) VALUES (\(value))"
        return mysqlStatement(SQL)
    }
    
    /// 删
    ///
    /// - Parameters:
    ///   - tableName: 表
    ///   - key: 键
    ///   - value: 值
    func deleteDatabaseSQL(tableName: String, key: String, value: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        
        let SQL = "DELETE FROM \(tableName) WHERE \(key) = '\(value)'"
        return mysqlStatement(SQL)
        
    }
    
    /// 改
    ///
    /// - Parameters:
    ///   - tableName: 表
    ///   - keyValue: 键值对( 键='值', 键='值', 键='值' )
    ///   - condition: 查询条件， 比如：userId=123
    func updateDatabaseSQL(tableName: String, keyValue: String, condition: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        
        let SQL = "UPDATE \(tableName) SET \(keyValue) WHERE \(condition)"
        return mysqlStatement(SQL)
        
    }
    
    /// 查
    ///
    /// - Parameters:
    ///   - tableName: 表
    ///   - keys: 需要查询的键
    ///   - condition: 查询条件，比如：userId=123
    func selectDataBaseSQLwhere(tableName: String, keys: String, condition: String) -> (success: Bool, keyValues:[[String:String]], mysqlResult: MySQL.Results?, errorMsg: String) {
        
        let SQL = "SELECT \(keys) FROM \(tableName) WHERE \(condition)"
        let sqlResult = mysqlStatement(SQL)
        var keyValues = [[String:String]]()
        sqlResult.mysqlResult?.forEachRow(callback: { (element) in
            let dic = self.mapToDictionary(withKeys: keys, values: element)
            keyValues.append(dic)
        })
        return (sqlResult.success, keyValues, sqlResult.mysqlResult, sqlResult.errorMsg)
    }
    
    // 将查询到的数据和查询字段映射为字典
    func mapToDictionary(withKeys keys:String, values:[String?]) -> [String:String] {
        print("keys:\(keys)")
        print("values:\(values)")
        let keysArr = keys.components(separatedBy: ",")
        var dic = [String:String]()
        if keys.count != values.count {
            return dic
        }
        for item in keysArr.enumerated() {
            dic[item.element] = values[item.offset] ?? ""
        }
        return dic
    }
}

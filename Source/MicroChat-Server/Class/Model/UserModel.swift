//
//  UserModel.swift
//  MicroChat-Server
//
//  Created by Tian Ming on 2019/5/31.
//
import StORM
import MySQLStORM

class UserModel: BaseModel {

    var id: String = ""
    var nickname: String = ""
    var gender: Int = 1
    var mobile: String = ""
    var token: String = ""
    
    override func table() -> String {
        return "user"
    }
    
    override func to(_ this: StORMRow) {
        id = this.data["id"] as? String ?? ""
        nickname = this.data["nickname"] as? String ?? ""
        gender = this.data["gender"] as? Int ?? 1
        mobile = this.data["mobile"] as? String ?? ""
        token = this.data["token"] as? String ?? ""
    }
    
    func rows() -> [UserModel] {
        var rows = [UserModel]()
        for i in 0..<self.results.rows.count {
            let row = UserModel()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
}

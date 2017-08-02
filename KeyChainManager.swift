//
//  KeyChainManager.swift
//  CustomItem
//
//  Created by WebbZhao on 17/8/1.
//  Copyright © 2017年 WebbZhao. All rights reserved.
//

import Foundation

struct AccountStruct {
    var account:String
    var password:String
    var token:String?
    var customItem:String?
    
    init(account:String,password:String) {
        self.account = account
        self.password = password
    }
    
    init(account:String,password:String,token:String?,customItem:String?) {
        self.account = account
        self.password = password
        self.token = token
        self.customItem = customItem
    }
}

final public class KeyChainManager{
    
    static let shareInstance = KeyChainManager.init()
    private init(){}
    
    /*
     判断用户帐号是否在Keychain中存在
     */
    func isUserExist(account:String) -> Bool {
        let result = SecItemCopyMatching(createSimpleQueryDict(account: account) as CFDictionary, nil)
        return result == noErr
    }

    /*
     根据提供的帐户返回Keychain中存储的信息
     */
    func findAccount(account:String) -> AccountStruct? {
        let queryDict:[String:Any] = [
            kSecClass as String:kSecClassGenericPassword
            ,kSecAttrAccount as String:account
            ,kSecReturnData as String:kCFBooleanTrue
            ,kSecReturnAttributes as String:kCFBooleanTrue
            ,kSecMatchLimit as String:kSecMatchLimitOne
        ]
        var queryResult:AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult){
            SecItemCopyMatching(queryDict as CFDictionary, UnsafeMutablePointer($0))
        }

        guard status == noErr else {
            return nil
        }
        
        guard queryResult != nil else {
            return nil
        }
        
        let token = queryResult?.object(forKey: kSecAttrService) as? String
        
        let passwordData = queryResult!.object(forKey: kSecValueData)
        var passowrd:String = ""
        if (passwordData as? Data) != nil {
            passowrd = String(data: passwordData as! Data, encoding: .utf8) ?? ""
        }else{
            passowrd = ""
        }
        
        let customItem = queryResult?.object(forKey: kSecAttrDescription) as? String
        return AccountStruct(account: account, password: passowrd, token:token, customItem: customItem)
    }
    
    /*
     增加或者更新Keychain帐户
     */
    func addOrReplaceAccount(accountStruct:AccountStruct) -> Bool {
        let data = accountStruct.password.data(using: String.Encoding.utf8)
        if data == nil {
            return false
        }
        var updateDict:[String:Any] = [
            kSecClass as String:kSecClassGenericPassword
            ,kSecAttrAccount as String:accountStruct.account
            ,kSecValueData as String:data!
        ]
        
        if accountStruct.token != nil {
            updateDict.updateValue(accountStruct.token!, forKey: kSecAttrService as String)
        }
        
        if accountStruct.customItem != nil {
            updateDict.updateValue(accountStruct.customItem!, forKey:kSecAttrDescription as String)
        }
        
        let existDict = findAccount(account: accountStruct.account)
        let status:OSStatus
        if existDict != nil {
            updateDict.removeValue(forKey: kSecClass as String)
            status = SecItemUpdate(createSimpleQueryDict(account: accountStruct.account) as CFDictionary, updateDict as CFDictionary)
        }else{
            status = SecItemAdd(updateDict as CFDictionary,nil)
        }
        return status == noErr
    }
    
    /*
     移除Keychain帐户
     */
    func removeAccount(account:String) -> Bool {
        if isUserExist(account: account) {
            let result = SecItemDelete(createSimpleQueryDict(account: account) as CFDictionary)
            return result == noErr
        }
        return true
    }
    
    private func createSimpleQueryDict(account:String) -> Dictionary<String, Any>{
        let queryDict:[String:Any] = [
            kSecClass as String:kSecClassGenericPassword
            ,kSecAttrAccount as String:account
        ]
        return queryDict
    }
}

# SimpleKeyChainDemo
//1.使用时，将KeyChainManager.swift拷贝到你的项目中
        //2.创建KeyChainManager的单例
             //let keyChainManager = KeyChainManager.shareInstance
        
        //创建或更新帐户.
            //1.当需要创建或更新帐户信息时，创建AccountStruct的结构体
                //let keychain = AccountStruct(account: "webbzhao", password: "123456")
                ////let keychain = AccountStruct(account: "webbzhao", password: "xxxx", token: "123", customItem: "wftc")
            //2.调用创建或更新方法,返回Bool型，告诉你创建/更新结果
                //let d = keyChainManager.addOrReplaceAccount(accountStruct: keychain)
        
        
        //查询,支持用户名进行查询
            //let s = keyChainManager.findAccount(account: "webbzhao")
        
        //删除,支持用户名进行删除
            //let result = keyChainManager.removeAccount(account: "webbzhao")

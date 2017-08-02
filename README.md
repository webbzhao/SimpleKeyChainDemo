# SimpleKeyChainDemo
<ol>
<li>1.使用时，将KeyChainManager.swift拷贝到你的项目中</li>
<li>2.创建KeyChainManager的单例</li>
     <pre><code>let keyChainManager = KeyChainManager.shareInstance</code></pre>      
<li>创建或更新帐户</li>
     //1.当需要创建或更新帐户信息时，创建AccountStruct的结构体
        <pre><code>let keychain = AccountStruct(account: "webbzhao", password: "123456")
        //let keychain = AccountStruct(account: "webbzhao", password: "xxxx", token: "123", customItem: "wftc")</code></pre>
     //2.调用创建或更新方法,返回Bool型，告诉你创建/更新结果
        <pre><code>let d = keyChainManager.addOrReplaceAccount(accountStruct: keychain)</code></pre>
        
<li>查询,支持用户名进行查询</li>
    <pre><code>let s = keyChainManager.findAccount(account: "webbzhao")</code></pre>
        
<li>删除,支持用户名进行删除</li>
    <pre><code>let result = keyChainManager.removeAccount(account: "webbzhao")</code></pre>

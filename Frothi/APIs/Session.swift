class Session {
  class func login(params:[String:String], success:((AFHTTPRequestOperation,AnyObject) -> Void)!, failure:((AFHTTPRequestOperation, NSError) -> Void)! ) {
    let manager = AFHTTPRequestOperationManager()
    

    manager.POST(BASE_URL + "login", parameters: params as AnyObject, success: { (operation: AFHTTPRequestOperation!,response: AnyObject!) in
      
      let token = response["token"] as? String
      CurrentUser.sharedInstance.setToken(token)
      success(operation, response)
      
    }, failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
      failure(operation, error)
    })
  }
  
  class func register(params:[String:String], success:((AFHTTPRequestOperation,AnyObject) -> Void)!, failure:((AFHTTPRequestOperation, NSError) -> Void)! ) {
    let manager = AFHTTPRequestOperationManager()
    
    let data = ["user" : params]

    manager.POST(BASE_URL + "users", parameters: data as AnyObject, success: { (operation: AFHTTPRequestOperation!,response: AnyObject!) in
      
      let token = response["token"] as? String
      CurrentUser.sharedInstance.setToken(token)
      success(operation, response)
      
    }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
        failure(operation, error)
    })
    
  }
}

class FacebookAPI {
  class var sharedInstance:FacebookAPI {
    struct Singleton {
      static let instance = FacebookAPI()
    }
    return Singleton.instance
  }
  
  let permissions = ["public_profile", "email"]
  
  func login(complete:(() -> Void)) {
    
    if FBSession.activeSession().state == FBSessionState.Open
      || FBSession.activeSession().state == FBSessionState.OpenTokenExtended {
        
        FBSession.activeSession().closeAndClearTokenInformation()
    } else {
      
      FBSession.openActiveSessionWithReadPermissions(permissions, allowLoginUI: true, completionHandler: { (session, state, error) -> Void in
        self.sessionStateChanged(session, state: state, error: error, complete: {
          if CurrentUser.sharedInstance.isLoggedIn() {
            complete()
          }
        })
        
      })
      
    }
  }
  
  func checkIfLoggedIn(complete:(() -> Void)) {
    if FBSession.activeSession().state == FBSessionState.CreatedTokenLoaded {
      
      FBSession.openActiveSessionWithReadPermissions(permissions, allowLoginUI: false, completionHandler: {(session, state, error) -> Void in
        self.sessionStateChanged(session, state: state, error: error, complete: {
          if CurrentUser.sharedInstance.isLoggedIn() {
            complete()
          }
        })
      })
    }
  }
  
  func sessionStateChanged(session:FBSession, state:FBSessionState, error:NSError?, complete:(() -> Void)? ) {
    
    if error == nil && state == FBSessionState.Open {
      FBRequest.requestForMe().startWithCompletionHandler({ (connection, user, error) -> Void in
        
        let data:[String:String] = [
          "first_name": user["first_name"]! as String,
          "last_name" : user["last_name"]! as String,
          "email"     : user["email"]! as String,
          "fb_id"     : user["id"]! as String,
          "fb_auth"   : "true"
        ]
        
        Session.register(data, success: ({ (operation, response) -> Void in
          if complete != nil {
            complete!()
          }
        }), failure: { (operation, response) -> Void in
          println("there was an error")
          FBSession.activeSession().closeAndClearTokenInformation()
        })
      })
      
      return
    }
    
    if state == FBSessionState.Closed || state == FBSessionState.ClosedLoginFailed {
      println("Session Closed")
    }
    
    //  Handle errors
    if let unwrappedError = error {
      println("Error")
    }
    
    FBSession.activeSession().closeAndClearTokenInformation()
    //    lougout user from currentuser
  }
  
}

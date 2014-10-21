class CurrentUser {
  class var sharedInstance:CurrentUser {
  struct Singleton {
    static let instance = CurrentUser()
    }
    return Singleton.instance
  }
  
  var firstName : String!
  var lastName  : String!
  var email     : String!
  var phone     : String!
  
  func setup() {
    //    Setup user from NSUSERdefaults and Keychain token
  //     If user is a facekbook user.. check FBSessionState with facebook
  }
  
  func token() -> String? {
    return Keychain.loadToken()
  }
  
  func setToken(token:String?) {
    println("setting Token")
    if let unwrappedToken = token {
      Keychain.saveToken(unwrappedToken)
    }
  }
  
  func clearToken() {
    Keychain.saveToken("")
  }
  
  func logOut() {
    clearToken()
    FBSession.activeSession().closeAndClearTokenInformation()
  }
  
  func isLoggedIn() -> Bool {
    //  if user is a FB authenticated user need to check FBSessionState and token presence
    if let unwrappedToken = token() {
      return !unwrappedToken.isEmpty
    } else {
      return false
    }
  }
}

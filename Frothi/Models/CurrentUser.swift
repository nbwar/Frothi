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
  }
  
  func token() -> String? {
    return Keychain.loadToken()
  }
  
  func setToken(token:String?) {
    if let unwrappedToken = token {
      Keychain.saveToken(unwrappedToken)
    }
  }
  
  func clearToken() {
    Keychain.saveToken("")
  }
  
  func isLoggedIn() -> Bool {
    if let unwrappedToken = token() {
      return !unwrappedToken.isEmpty
    } else {
      return false
    }
  }
}

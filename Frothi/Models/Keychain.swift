import UIKit
import Security

let serviceIdentifier = "frothi"
let tokenKey = "auth_token"
//let accessGroup = "MySerivice"

let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

class Keychain: NSObject {
  
  class func saveToken(token: NSString) {
    self.save(serviceIdentifier, data: token)
  }
  
  class func loadToken() -> NSString? {
    var token = self.load(serviceIdentifier)
    return token
  }
  

  private class func save(service: NSString, data: NSString) {
    var dataFromString: NSData = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    
    // Instantiate a new default keychain query
    var keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, tokenKey, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
    
    // Delete any existing items
    SecItemDelete(keychainQuery as CFDictionaryRef)
    
    // Add the new keychain item
    var status: OSStatus = SecItemAdd(keychainQuery as CFDictionaryRef, nil)
  }
  
  private class func load(service: NSString) -> NSString? {
    // Instantiate a new default keychain query
    // Tell the query to return a result
    // Limit our results to one item
    var keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, tokenKey, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
    
    var dataTypeRef :Unmanaged<AnyObject>?
    
    // Search for the keychain items
    let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
    
    let opaque = dataTypeRef?.toOpaque()
    
    var contentsOfKeychain: NSString?
    
    if let op = opaque? {
      let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue()
      
      // Convert the data retrieved from the keychain into a string
      contentsOfKeychain = NSString(data: retrievedData, encoding: NSUTF8StringEncoding)
    } else {
      println("Nothing was retrieved from the keychain. Status code \(status)")
    }
    
    return contentsOfKeychain
  }
}
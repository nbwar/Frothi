import UIKit

protocol LoginControllerDelegate {
  func transitionToHomeController()
}

class LoginController : UIViewController, LoginControllerDelegate, UITextFieldDelegate {
  @IBOutlet weak var backgroundBlurView: UIView!
  @IBOutlet weak var createAccountButton: UIButton!
  @IBOutlet weak var loginView: UIView!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var facebookButton: UIButton!

  
  var animate:Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    BlurView.insertBlurView(backgroundBlurView, style: .Dark)
    loginView.alpha = 0

  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(Bool())
    
    if animate {
      animateLoginView()
      animate = false
    }
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "loginToRegister" {
      let navigationController = segue.destinationViewController as UINavigationController
      let registrationController = navigationController.visibleViewController as RegistrationController
      registrationController.delegate = self
    }
  }
  
//  ACTIONS
  
  @IBAction func loginButtonPressed(sender: AnyObject) {
    login()
  }
  
  @IBAction func facebookLoginPressed(sender: AnyObject) {
    FacebookAPI.sharedInstance.login({
      self.transitionToHomeController()
    })
  }
  
  @IBAction func dismissKeyboard(sender: AnyObject) {
    if emailField.isFirstResponder() {
      emailField.resignFirstResponder()
    } else if passwordField.isFirstResponder() {
      passwordField.resignFirstResponder()
    }
    
  }
//  UITextFieldDelegate methods

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == emailField {
      passwordField.becomeFirstResponder()
    } else if textField == passwordField {
      login()
    }
    return true
  }
  
//  Helpers
  
  func login() {
    let email = emailField.text!
    let password = passwordField.text!
    let data = ["email":email, "password":password]
    
    
    Session.login(data, success: { (operation, response) in
      println("operation \(operation.responseData)")
      println("response \(response)")
      
      self.transitionToHomeController()
      
      }, failure: { (operation, response) in
        println("operation \(operation.responseData)")
        println("response \(response)")
        
    })
  }
  
  func animateLoginView() {
    let scale = CGAffineTransformMakeScale(0.5, 0.5)
    let translate = CGAffineTransformMakeTranslation(0, -200)
    loginView.transform = CGAffineTransformConcat(scale, translate)
    
    spring(0.5) {
      let scale = CGAffineTransformMakeScale(1.0, 1.0)
      let translate = CGAffineTransformMakeTranslation(0, 0)
      self.loginView.transform = CGAffineTransformConcat(scale, translate)
    }
    loginView.alpha = 1
  }
  
  func transitionToHomeController() {
    let mainStoryboard = UIStoryboard(name: "Home", bundle: nil)
    let homeController = mainStoryboard.instantiateInitialViewController() as UINavigationController
    let sideMenuController = self.revealViewController().rearViewController as SideMenuController
    sideMenuController.homeController = homeController
    self.revealViewController().pushFrontViewController(homeController, animated: true)
  }
}

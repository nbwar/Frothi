import UIKit

class RegistrationController : UIViewController, UITextFieldDelegate {
  let blueColor = UIColor(red: 42/255, green: 95/255, blue: 124/255, alpha: 1.0).CGColor
  let orangeColor = UIColor(red: 57/255, green: 35/255, blue: 13/225, alpha: 1.0).CGColor
  var delegate: LoginControllerDelegate?
  
  @IBOutlet var gradientView: GradientView!
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var phoneField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  @IBAction func closeButtonPressed(sender: AnyObject) {
    dismissViewControllerAnimated(true, nil)
  }
  
  @IBAction func registerButtonPressed(sender: AnyObject) {
    register()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.barTintColor = UIColor(red: 0.051, green: 0.520, blue: 0.733, alpha: 1)
    let avenirNext:UIFont = UIFont(name: "Avenir Next", size: 20)!
    let titleDict:NSDictionary = [NSFontAttributeName: avenirNext,NSForegroundColorAttributeName: UIColor.whiteColor()]
    navigationController?.navigationBar.titleTextAttributes = titleDict
    
    let colors:[AnyObject] = [blueColor, orangeColor]
    gradientView.drawGradient(colors)
  }
  
//  UITextFieldDelegateMethods
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == nameField {
      emailField.becomeFirstResponder()
    } else if textField == emailField {
      phoneField.becomeFirstResponder()
    } else if textField == phoneField {
      passwordField.becomeFirstResponder()
    } else if textField == passwordField {
      register()
    }
    
    return true
  }
  
//  Helpers
  func register() {
    let nameArray = nameField.text.componentsSeparatedByString(" ")
    let firstName:String? = nameArray[0]
    let lastName:String? = nameArray[1]
    
    let data = [
      "first_name"            : firstName!,
      "last_name"             : lastName!,
      "email"                 : emailField.text!,
      "phone"                 : phoneField.text!,
      "password"              : passwordField.text!,
      "password_confirmation" : passwordField.text!
    ]
    
    Session.register(data, success: { (operation, response) in
      println("operation \(operation.responseData)")
      println("response \(response)")
      
      self.dismissViewControllerAnimated(true, completion: {
        self.delegate!.transitionToHomeController()
      })
      
      }, failure: {(operation, response) in
        println("operation \(operation.responseData)")
        println("response \(response)")
    })
  }
}
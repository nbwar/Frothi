import UIKit

class HomeController : UITableViewController, CardTableViewCellDelegate {
  @IBOutlet weak var menuButton: UIBarButtonItem!
  
  let cart = Cart()
  var data = getData()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.backgroundView = UIImageView(image:UIImage(named:"bg-home"))
    self.tableView.separatorColor = UIColor.clearColor()
    
    menuButton.target = self.revealViewController()
    menuButton.action = Selector("revealToggle:")
    
    navigationController?.navigationBar.barTintColor = UIColor(red: 0.051, green: 0.520, blue: 0.733, alpha: 1)
    let avenirNext:UIFont = UIFont(name: "Avenir Next", size: 20)!
    let titleDict:NSDictionary = [NSFontAttributeName: avenirNext,NSForegroundColorAttributeName: UIColor.whiteColor()]
    navigationController?.navigationBar.titleTextAttributes = titleDict
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
  }
  
  //  Segues
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "homeToOrder" {
      let orderController:OrderController = segue.destinationViewController as OrderController
      orderController.cart = cart
    }
  }
  
  
  //  TableViewDelegate Methods
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Card", forIndexPath: indexPath) as CardTableViewCell
    var item = data[indexPath.row]
    
    cell.delegate = self
    cell.setup(item)
    
    return cell
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
  }
  
  //  CardTableViewCellDelegate Methods
  
  func plusButtonPressed(cell: CardTableViewCell, sender: AnyObject) {
    var number = cell.amountLabel.text?.toInt()!
    number! += 1
    cell.amountLabel.text = "\(number!)"
    var item = cell.item
    cart.addItem(item)
  }
  
  func minusButtonPressed(cell: CardTableViewCell, sender: AnyObject) {
    let item = cell.item
    var number = cell.amountLabel.text?.toInt()!
    cart.removeItem(item)
    
    if number > 1 {
      number! -= 1
    } else {
      number = 0
    }
    cell.amountLabel.text = "\(number!)"
    
  }

  
  //  Helpers
  
  func addViewToNavigationControllerWithAnimation(viewToAdd: UIView) {
    viewToAdd.alpha = 0
    self.navigationController?.view.addSubview(viewToAdd)
    BlurView.insertBlurView(viewToAdd, style: UIBlurEffectStyle.Light)
    
    
    UIView.animateWithDuration(0.3, delay: 0, options: nil, animations: {
      viewToAdd.alpha = 1
      }, completion: nil)
  }
  
  func removeViewFromNaviagtionControllerWithAnimation(viewToRemove: UIView) {
    springWithCompletion(0.3, {
      viewToRemove.backgroundColor = UIColor.blackColor()
      viewToRemove.alpha = 0
      }, { finished in
        viewToRemove.removeFromSuperview()
    })
  }
  
} // end

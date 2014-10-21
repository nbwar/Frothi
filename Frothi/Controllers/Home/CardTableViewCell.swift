import UIKit

protocol CardTableViewCellDelegate {
  func plusButtonPressed(cell: CardTableViewCell, sender: AnyObject)
  func minusButtonPressed(cell: CardTableViewCell, sender: AnyObject)
}

class CardTableViewCell : UITableViewCell {
  var delegate: CardTableViewCellDelegate?
  var item:Item!
  var blurred:Bool = false
  
  //  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var blackBarView: UIView!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var detailBlurView: UIView!
  @IBOutlet weak var detailTextView: UITextView!
  
  
  @IBAction func detailButtonPressed(sender: AnyObject) {
    detailBlurView.hidden = !detailBlurView.hidden
  }
  
  @IBAction func plusButtonPressed(sender: AnyObject) {
    delegate?.plusButtonPressed(self, sender: sender)
  }
  
  @IBAction func minusButtonPressed(sender: AnyObject) {
    delegate?.minusButtonPressed(self, sender: sender)
  }
  
  func setup(itemToSetup: Item) {
    item = itemToSetup
    nameLabel.text = item.name
    priceLabel.text = "$\(item.price)"
    itemImageView.image = UIImage(named: item.image)
    detailTextView.text = item.description
    detailTextView.textColor = UIColor.whiteColor()
    detailTextView.font = UIFont(name: "Avenir Next", size: 14)!
    
    if !blurred {
      BlurView.insertBlurView(blackBarView, style: .Dark)
      BlurView.insertBlurView(detailBlurView, style: .Dark)
      blurred = true
    }
    
  }
}

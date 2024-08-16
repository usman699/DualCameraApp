
import UIKit


class photoFileViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonss.setTitle("", for: .normal)

        // Set the background image for the button from the asset catalog
              if let backgroundButtonImage = UIImage(named: "icon_2.png")  {
                  buttonss.setBackgroundImage(backgroundButtonImage, for: UIControl.State.normal)
                  buttonss.frame = CGRect(x: 10, y: 100, width: 100, height: 100)
                  self.buttonss.setBackgroundImage(backgroundButtonImage, for:  UIControl.State.normal)
              }
        
        
        
        
        // Create image
                let image = UIImage(named: "icon_2.png")
                
                let button = UIButton()
                button.frame = CGRect(x: 10, y: 100, width: 100, height: 100)
                button.setBackgroundImage(image, for: UIControl.State.normal)
             
                
                self.view.addSubview(button)
                
        // Get the properties from the interface (storyboard) button
  

        view.addSubview(buttonss)
      
    }
    
    

    @IBOutlet weak var buttonss: UIButton!
}

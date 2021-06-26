//
//  ViewController.swift
//  Oskorblyator
//
//  Created by Иван Маришин on 26.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var viewNetObject: UIView!
    @IBOutlet weak var textLable: UILabel!
    @IBOutlet weak var getInsultButton: UIButton!
    @IBOutlet weak var getImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    let networker = Networker.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNetObject.layer.cornerRadius = 10
        viewNetObject.layer.shadowRadius = 3.0
        viewNetObject.layer.shadowOpacity = 0.5
        viewNetObject.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        getImageButton.layer.cornerRadius = 10
        getImageButton.layer.shadowRadius = 5.0
        getImageButton.layer.shadowOpacity = 0.5
        getImageButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        getInsultButton.layer.cornerRadius = 10
        getInsultButton.layer.shadowRadius = 5.0
        getInsultButton.layer.shadowOpacity = 0.5
        getInsultButton.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    @IBAction func getImageButton(_ sender: Any) {
        textLable.isHidden = true
        imageView.isHidden = false
        
        networker.getImage { (data, error)  in
          if let error = error {
            print(error)
            return
          }
          
          self.imageView.image = UIImage(data: data!)
        }
    }
    @IBAction func getInsultButton(_ sender: Any) {
        textLable.isHidden = false
        imageView.isHidden = true
        
        networker.getQuote { quote, error in
            if let _ = error {
                self.textLable.text = "Error"
                return
            }
            else {
                self.textLable.text = quote?.insult
            }
        }
    }
}


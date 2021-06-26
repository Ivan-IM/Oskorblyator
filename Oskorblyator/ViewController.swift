//
//  ViewController.swift
//  Oskorblyator
//
//  Created by Иван Маришин on 26.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var viewForText: UIView!
    @IBOutlet weak var textLable: UILabel!
    @IBOutlet weak var getButton: UIButton!
    
    let networker = Networker.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewForText.layer.cornerRadius = 10
        viewForText.layer.shadowRadius = 3.0
        viewForText.layer.shadowOpacity = 0.5
        viewForText.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        getButton.layer.cornerRadius = 10
        getButton.layer.shadowRadius = 5.0
        getButton.layer.shadowOpacity = 0.5
        getButton.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    @IBAction func getButton(_ sender: Any) {
        
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


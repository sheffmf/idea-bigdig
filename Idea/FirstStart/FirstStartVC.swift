//
//  FirstStartVC.swift
//  Idea
//
//  Created by Aleksandr Kovalchuk on 17.04.2019.
//  Copyright © 2019 Aleksandr Kovalchuk. All rights reserved.
//

import UIKit

class FirstStartVC: UIViewController {

    @IBOutlet weak var iconApp: UIImageView!
    @IBOutlet weak var textHello: UILabel!
    @IBOutlet weak var textAbout: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        startButton.layer.cornerRadius = 15
        startButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        startButton.layer.shadowRadius = 10
        
        textHello.alpha = 0
        textAbout.alpha = 0
        startButton.alpha = 0
        
        self.iconApp.translatesAutoresizingMaskIntoConstraints = true
        
        iconApp.frame = CGRect(x: 150, y: -10, width: 0, height: 0)
        UIView.animate(withDuration: 4, animations: {
            self.iconApp.frame = CGRect(x: (self.view.frame.width - 240)/2, y: 35, width: 240, height: 240)
        }) { _ in
            UIView.animate(withDuration: 2, animations: {
                self.textHello.alpha = 1
            }) { _ in
                    UIView.animate(withDuration: 2, animations: {
                        self.textAbout.alpha = 1
                    }) { _ in
                        self.show()
                }
//                        UIView.animate(withDuration: 5, animations: {
//                            self.startButton.alpha = 1
//                        })
                    }
            }
        }
        func show(){
            UIView.animate(withDuration: 2, animations: {
                self.startButton.alpha = 1
                
            }){ _ in
                self.hide()
            }
        }
        func hide(){
            UIView.animate(withDuration: 2, animations: {
                self.startButton.alpha = 0.6
                
            }){ _ in
                self.show()
            }
        }

        // Do any additional setup after loading the view.
    }
    

   



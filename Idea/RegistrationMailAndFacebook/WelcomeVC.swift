//
//  WelcomeVC.swift
//  Idea
//
//  Created by Aleksandr Kovalchuk on 25.04.2019.
//  Copyright © 2019 Aleksandr Kovalchuk. All rights reserved.
//

import UIKit
import Firebase

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        do{
            try Auth.auth().signOut()

        }catch{
            print(error)
        }
    }
    
    

}

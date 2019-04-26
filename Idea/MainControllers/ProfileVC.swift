//
//  ProfileVC.swift
//  Idea
//
//  Created by Aleksandr Kovalchuk on 07.04.2019.
//  Copyright © 2019 Aleksandr Kovalchuk. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    @IBOutlet weak var imagePhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePhoto.layer.cornerRadius = 100
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func openZoomingController(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "zooming", sender: nil)//imageView.image)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            
        }catch{
            print(error)
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  FrindProfileVC.swift
//  Idea
//
//  Created by Aleksandr Kovalchuk on 20.04.2019.
//  Copyright © 2019 Aleksandr Kovalchuk. All rights reserved.
//

import UIKit
import Contacts

class FrindProfileVC: UIViewController {


    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var nameContact: UILabel!
    @IBOutlet weak var aboutField: UITextView!
    @IBOutlet weak var zodiacLogo: UIImageView!
    @IBOutlet weak var dateOfBirth: UILabel!
    @IBOutlet weak var age: UILabel!
    
    
    let nameString = ""
    let aboutString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func openZoomingController(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "zooming", sender: nil)//imageView.image)
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

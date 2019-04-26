//
//  NewWishCardVC.swift
//  Idea
//
//  Created by Aleksandr Kovalchuk on 22.04.2019.
//  Copyright © 2019 Aleksandr Kovalchuk. All rights reserved.
//

import UIKit

class NewWishCardVC: UIViewController {

    @IBOutlet weak var nameWish: UIVisualEffectView!
    @IBOutlet weak var aboutField: UITextView!
    @IBOutlet weak var whereBuy: UITextView!
    @IBOutlet weak var linkField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddNewPhoto(_ sender: Any) {
    }
    
    @IBAction func addOldPhoto(_ sender: Any) {
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

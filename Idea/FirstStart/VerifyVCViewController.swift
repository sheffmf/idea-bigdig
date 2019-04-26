//
//  VerifyVCViewController.swift
//  Idea
//
//  Created by Aleksandr Kovalchuk on 26.04.2019.
//  Copyright © 2019 Aleksandr Kovalchuk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class VerifyVCViewController: UIViewController,NewUserVCDelegate {
    func addUser(user: Users) {
        
    }
    let userDef = UserDefaults.standard
    
    
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var codField: UITextField!
    @IBOutlet weak var continueBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //hideKeyBoardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func canselButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ContinueButton(_ sender: Any) {
//        let defaults = UserDefaults.standard
//        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: codField.text!)
//        Auth.auth().signIn(with: credential) { (user,error) in
//            if error != nil {
//                print("Error: \(String(describing: error?.localizedDescription))")
//            } else {
//                print("Error number:\(String(describing: user?.phoneNumber))")
//                let userInfo = user?.providerData[0]
//                print("Provider ID: \(String(describing: userInfo?.providerID))")
//                self.performSegue(withIdentifier: "RegistrationVC", sender: Any?.self)
//                //self.dismiss(animated: true, completion: nil)
//            }
       
        guard let otpCode = codField.text else { return }
        guard let verificationId = userDef.string(forKey: "verificationId") else {return}
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: otpCode)

        Auth.auth().signInAndRetrieveData(with: credential) { (success, error) in
            if error == nil{
                print("User Signed in..")
                //Вернуться на пред.экран
                self.dismiss(animated: true, completion: nil)
                //self.navigationController?.popViewController(animated: true)

            } else {
                print(error?.localizedDescription)
            }
        }
      
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            
    }
}

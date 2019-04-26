//
//  RegistrationVC.swift
//  Idea
//
//  Created by Aleksandr Kovalchuk on 18.04.2019.
//  Copyright © 2019 Aleksandr Kovalchuk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


protocol NewUserVCDelegate {
    func addUser(user: Users)
    
}

class RegistrationVC: UIViewController {
   
    var delegate : NewUserVCDelegate?
    let userDef = UserDefaults.standard


    let userDefaults = Users.init()
    var signup: Bool = true

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var google: UIButton!
    
    
    @IBOutlet weak var UploadPhoto: UIButton!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var verify: UIButton!
    @IBOutlet weak var codField: UITextField!
    

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var txtDatePicker: UITextField!
    let datePicker = UIDatePicker()

    @IBOutlet weak var birthIcon: UIImageView!
    
    @IBOutlet weak var hintAbout: UILabel!
    @IBOutlet weak var aboutField: UITextView!
    
    @IBOutlet weak var regButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDatePicker()

        regButton.layer.cornerRadius = 15
        verify.layer.cornerRadius = 15
        //Анимация
        logo.alpha = 0
        facebook.alpha = 0
        google.alpha = 0
        avatar.alpha = 0
        numberField.alpha = 0
        verify.alpha = 0
        codField.alpha = 0
        nameField.alpha = 0
        txtDatePicker.alpha = 0
        birthIcon.alpha = 0
        hintAbout.alpha = 0
        aboutField.alpha = 0
        regButton.alpha = 0
        
//        nameField.delegate = self
//        numberField.delegate = self
//        txtDatePicker.delegate = self
//
        //Анимация
        UIView.animate(withDuration: 1, animations: {
            self.logo.alpha = 1
        }){ _ in
            UIView.animate(withDuration: 0.8, animations: {
                self.facebook.alpha = 1
            }){ _ in
                UIView.animate(withDuration: 0.7, animations: {
                    self.google.alpha = 1
                }){ _ in
                    UIView.animate(withDuration: 0.6, animations: {
                        self.avatar.alpha = 1
                    }){ _ in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.numberField.alpha = 1
                            self.verify.alpha = 1
                            
                        }){ _ in
                            UIView.animate(withDuration: 0.4, animations: {
                                self.nameField.alpha = 1
                                self.codField.alpha = 1
                            }){ _ in
                                UIView.animate(withDuration: 0.3, animations: {
                                    self.txtDatePicker.alpha = 1
                            }){ _ in
                                UIView.animate(withDuration: 0.2, animations: {
                                    self.birthIcon.alpha = 1
                                }){ _ in
                                    UIView.animate(withDuration: 0.2, animations: {
                                        self.hintAbout.alpha = 1
                                }){ _ in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.aboutField.alpha = 1
                                    }){ _ in
                                        UIView.animate(withDuration: 2, animations: {
                                            self.regButton.alpha = 1

                                        })
                                    }
                                    }
                                }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Do any additional setup after loading the view.
        
        //Прячем клавиатуру
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hidekeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func hidekeyboard(){
        view.endEditing(true)
    }
   // Выбор даты
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDatePicker.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
//Регистрация
    @IBAction func phoneSignIn(_ sender: Any){
        guard let phoneNumber = numberField.text else {return }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            if error == nil{
                print(verificationId)
                guard let verifyId = verificationId else { return }
                self.userDef.set(verifyId, forKey: "verificationId")
                self.userDef.synchronize()
            } else {
                print("Unable to get Secret Verification Code from firebase", error?.localizedDescription)
            }
        }
        
    }
    
    @IBAction func switchLogin(_ sender: Any) {
        //signup = !signup
        guard let otpCode = codField.text else { return }
        guard let verificationId = userDef.string(forKey: "verificationId") else {return}
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: otpCode)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (success, error) in
            if error == nil{
                print(success)
                print("User Signed in..")
                //Вернуться на пред.экран
                self.dismiss(animated: true, completion: nil)
                //self.navigationController?.popViewController(animated: true)
                
            } else {
                print(error?.localizedDescription)
            }
        }
        
        
    
    }
    
    
    func showAlert(){
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

  


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}


//extension RegistrationVC:UITextFieldDelegate{
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
//        let name = nameField.text!
//        let number = numberField.text!
//        let data = txtDatePicker.text!
//        if(signup){
//            if(!name.isEmpty && !number.isEmpty && !data.isEmpty){
//                Auth.auth().createUser(withEmail: number, password: name){(result, error) in
//                    if error == nil{
//                        if let result = result{
//                            print(result.user.uid)
//                            let ref = Database.database().reference().child("users")
//                            ref.child(result.user.uid).updateChildValues(["name" : name, "number" : number])
//                            self.dismiss(animated: true, completion: nil)
//
//                        }
//                    }
//                }

//==========================



//            }else{
//                showAlert()
//            }
//        }else{
//            if(!email.isEmpty && !password.isEmpty){
//                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//                    if error == nil{
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                }
//
//            }else{
//                showAlert()
//            }

//=============



//        }
//
//
//        return true
//    }
//}


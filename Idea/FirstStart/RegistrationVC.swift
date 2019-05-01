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
import Photos
import PhotosUI



protocol NewUserVCDelegate {
    func addUser(user: Users)
    
}

class RegistrationVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    var ref:DatabaseReference?

    var delegate : NewUserVCDelegate?
    let userDef = UserDefaults.standard
    let userDefaults = Users.init()
    
    let datePicker = UIDatePicker()

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
    @IBOutlet weak var birthIcon: UIImageView!
    @IBOutlet weak var hintAbout: UILabel!
    @IBOutlet weak var aboutField: UITextView!
    @IBOutlet weak var regButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        //animationFunc()
        regButton.layer.cornerRadius = 15
        verify.layer.cornerRadius = 15
//checkPermission()
        
        nameField.delegate = self
        numberField.delegate = self
        txtDatePicker.delegate = self
        
        //Прячем клавиатуру
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hidekeyboard))
        view.addGestureRecognizer(tap)
        
        //setupProfile()
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ProfileVC"
//        {
//            let vc = segue.destination as! ProfileVC
//        }
//    }
    
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
    
    func setupProfile(){
        
        avatar.layer.cornerRadius = 110
        avatar.clipsToBounds = true
        ref = Database.database().reference()

        let uid = Auth.auth().currentUser?.uid
//        let db = Firestore.firestore()
//        var ref: DocumentReference? = nil
//        ref = db.collection("users").addDocument(data: [
//
//            ])
//        databaseRef.child("users").child(uid!).observe(of: .value) { (snapshot) in
//            if let dict = snapshot.value as? [String: AnyObject]{
//                if let profileImageURL = dict["pic"] as? String{
//                    let url = URL(string: profileImageURL)
//                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                        if error != nil{
//                            print(error)
//                            return
//                        }
//                        DispatchQueue.main.async {
//                            self.avatar?.image = UIImage(data: data!)
//                        }
//                    }).resume()
//                }
//            }
//
//        }
//
//
    }
//    func checkPermission() {
//        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
//        switch photoAuthorizationStatus {
//        case .authorized:
//            print("Access is granted by user")
//        case .notDetermined:
//            PHPhotoLibrary.requestAuthorization({
//                (newStatus) in
//                print("status is \(newStatus)")
//                if newStatus ==  PHAuthorizationStatus.authorized {
//                    /* do stuff here */
//                    print("success")
//                }
//            })
//            print("It is not determined until now")
//        case .restricted:
//            // same same
//            print("User do not have access to photo album.")
//        case .denied:
//            // same same
//            print("User has denied the permission.")
//        }
//    }
//Регистрация
    @IBAction func phoneSignIn(_ sender: Any){
        guard let phoneNumber = numberField.text else {return }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (phoneNumber, error) in
            if error == nil{
                print(phoneNumber)
                guard let verifyId = phoneNumber else { return }
                self.userDef.set(verifyId, forKey: "phoneNumber")
                self.userDef.synchronize()
            } else {
                print("Unable to get Secret Verification Code from firebase", error?.localizedDescription)
            }
        }
        
    }
    
    @IBAction func switchLogin(_ sender: Any) {
        signup = !signup
        guard let otpCode = codField.text else { return }
        guard let verificationId = userDef.string(forKey: "phoneNumber") else {return}
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: otpCode)
        
        
        let name = nameField.text!
        let number = numberField.text!
        let data = txtDatePicker.text!
        let cod = codField.text!
        //let url = Storage.storage().reference().child("myImage.png")
        if name.isEmpty && number.isEmpty && data.isEmpty && cod.isEmpty{
        showAlert()
        }
       
        Auth.auth().signInAndRetrieveData(with: credential) { (success, error) in
            if error == nil{
                print(success)
                print("The new user add to database")
                // Add a new document with a generated ID
                //FirebaseApp.configure()
                
                UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "phoneNumber")
                
                UserDefaults.standard.synchronize()
                
                let db = Firestore.firestore()
                var ref: DocumentReference? = nil
                let currentUser = Auth.auth().currentUser?.uid
                ref = db.collection(currentUser!).addDocument(data: [
                    "telNumber": number,
                    "userName": name,
                    "dateOfBirth": data,
                    "UID": Auth.auth().currentUser?.uid as? Any
                    //"myImageURL": url
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
                self.present(initialViewController, animated: true, completion: nil)
                

            
                
                //Вернуться на пред.экран
                //self.dismiss(animated: true, completion: nil)

                //self.navigationController?.popViewController(animated: true)
                
            } else {
                print(error?.localizedDescription)
            }
        }
        
        
    
    }
    
    // Alert about empty fielsds
    func showAlert(){
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
    
    @IBAction func addProfilePhoto(_ sender: Any) {
      let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = originalImage
    }
        if let selectedImage = selectedImageFromPicker{
            avatar.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
        
        func imagePickerControllerDidCansel(_ picker: UIImagePickerController){
            dismiss(animated: true, completion: nil)
        }
        
        func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
            let storageRef = Storage.storage().reference().child("myImage.png")
            if let uploadData = self.avatar.image!.pngData() {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print("error")
                        completion(nil)
//                    } else {
//
//                        completion((metadata?.downloadURL()?.absoluteString)!))
//                        // your uploaded photo url.
//                    }
                }
            }
//        func saveChanges(){
//            let imageName = NSUUID().uuidString
//            let storedImage = storageRef.child("avatar").child(imageName)
//            if let uploadData = UIImage(self.avatar.image){
//                storedImage.putData(uploadData, metadata: nil) { (metadata, error) in
//                    if error != nil{
//                        print(error!)
//                        return
//                    }
//                    storedImage.downloadURL(completion: { (url, error) in
//                        if error != nil{
//                            print(error!)
//                            return
//                        }
//                        if let urlText = url?.absolutString{
//                            self.databaseRef.child("users").child(Auth.auth()?.currentUser?.uid!).updateChildValues["pic":urlText] withComplitionBlock: {(error, ref) in
//                                if error != nil{
//                                    print(error!)
//                                    return
//                                }
//                        }
//                    })
//                }
//
//            }
//
//        }
//    }
        func animationFunc(){
            
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
        }
    }
}
}
}
    
extension RegistrationVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        let name = nameField.text!
        let number = numberField.text!
        let data = txtDatePicker.text!
        if(signup){
            if(!name.isEmpty && !number.isEmpty && !data.isEmpty){
            self.dismiss(animated: true, completion: nil)
            }else{
                showAlert()
            }
        }
        return true
    }
}


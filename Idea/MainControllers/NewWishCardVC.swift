//
//  NewWishCardVC.swift
//  Idea
//
//  Created by Aleksandr Kovalchuk on 22.04.2019.
//  Copyright © 2019 Aleksandr Kovalchuk. All rights reserved.
//

import UIKit
import Firebase
import PhotosUI
import Photos

class NewWishCardVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var ref:DatabaseReference?
    var db: Firestore!

    @IBOutlet weak var nameWish: UITextField!
    @IBOutlet weak var aboutField: UITextView!
    @IBOutlet weak var whereBuy: UITextView!
    @IBOutlet weak var linkField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hidekeyboard))
        view.addGestureRecognizer(tap)
       
        checkPermission()

        // Do any additional setup after loading the view.
    }
    @objc func hidekeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddNewPhoto(_ sender: Any) {
    }
    
    @IBAction func addOldPhoto(_ sender: Any) {
        let profileImagePicker = UIImagePickerController()
        profileImagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //profileImagePicker.mediaTypes = [kUTTypeImage as String]
        profileImagePicker.allowsEditing = true
        
        profileImagePicker.delegate = self
        present(profileImagePicker, animated: true, completion: nil)
        
    }
    //MARK: Cancell button
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion:nil)
    }//Editing
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            var image = selectedImage
            //uploadProfileImage(imageData: selectedImageFromPicker)
        
        
        
        //MARK: Upload photo to database
        let store = Storage.storage()
        let storeRef = store.reference()
        let userProfilesRef = storeRef.child("images/wishes")
        let logoRef = storeRef.child("images/logo.png")
            //var data = Data()
        let userID = Auth.auth().currentUser?.uid ?? "Null"
            
            let uploadUserProfileTask = userProfilesRef.child("\(userID).png").putData(Data(), metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("Error occurred: \(error)")
                return
            }
            print("download url for profile is \(metadata)")
        }
        let progressObserver = uploadUserProfileTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print(percentComplete)
        }
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addNewWish(_ sender: Any) {
        
        
        let name = nameWish.text!
        let about = aboutField.text!
        let buy = whereBuy.text!
        let link = linkField.text!
        //let url = Storage.storage().reference().child("myImage.png")
        if name.isEmpty && about.isEmpty {
            showAlert()
        }
                let db = Firestore.firestore()
                var ref: DocumentReference? = nil
                
                let currentUser = Auth.auth().currentUser?.uid as! String
        
        
                //ref = db.collection("users").document("currentUser").collection("name")
                ref = db.collection("usersAuth/\(String(describing: currentUser))/wishCard").addDocument(data: [
                    "nameOfWish": name,
                    "aboutWish": about,
                    "whereBuyWish": buy,
                    "linkBuyWish": link,
                    //"photo": linkPhoto,
                    "UID": currentUser as? Any
                    
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
        
        }
    
func showAlert(){
    let alert = UIAlertController(title: "Ошибка", message: "Название и описание должны быть заполнены!", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
}
    
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
}

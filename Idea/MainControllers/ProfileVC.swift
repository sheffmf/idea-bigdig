//
//  ProfileVC.swift
//  Idea
//
//  Created by Aleksandr Kovalchuk on 07.04.2019.
//  Copyright © 2019 Aleksandr Kovalchuk. All rights reserved.
//

import UIKit
import Firebase
import PhotosUI
import Photos


class ProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var ref:DatabaseReference?
    var db: Firestore!

    
    
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var dateOfBirth: UILabel!
    @IBOutlet weak var age: UILabel!
    
    @IBOutlet weak var zodiacLogo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        db = Firestore.firestore()


        imagePhoto.layer.cornerRadius = imagePhoto.frame.size.width/2
        //imagePhoto.layer.cornerRadius = 25
        imagePhoto.clipsToBounds = true
        checkPermission()
        
        //let uid = Auth.auth().currentUser?.uid

//        db.collection("users").document(uid ?? "UID not yet loaded in viewDidLoad()")
//            .addSnapshotListener { snapshot, error in
//                if error != nil {
//                    print(error ?? "Couldn't update text field TextUser according to database")
//                } else {
//                    if let dbUsername = snapshot?["userName"] as? String {
//                        self.nameLabel?.text = dbUsername
//                    }
//                }
//        }
        let num = Auth.auth().currentUser?.uid
        let key = UserDefaults.standard.value(forKey: "num") as? String ?? "Null" // Unique user key
        let docRef = db.collection("num").document(key)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let docData = document.data()
                let status = docData!["userName"] as? String ?? ""
                self.nameLabel?.text = status
            } else {
                print("Document does not exist")
                print(key)
                print(num)
                //print(UserDefaults.standard.dictionaryRepresentation())
                
            }
        }

//        let user = Auth.auth().currentUser?.uid
//        let textString = db.collection("users").whereField("userName", isEqualTo: nameLabel)

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    @IBAction func setProfileImageButtonTapped(_ sender: Any) {
        let profileImagePicker = UIImagePickerController()
        profileImagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //profileImagePicker.mediaTypes = [kUTTypeImage as String]
        profileImagePicker.allowsEditing = true

        profileImagePicker.delegate = self
        present(profileImagePicker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion:nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            imagePhoto.image = selectedImage
        }
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            self.imagePhoto.contentMode = .scaleAspectFit
//            self.imagePhoto.image = pickedImage
//        }
        
        dismiss(animated: true, completion: nil)
    }
    func uploadProfileImage(imageData: Data)
    {
        
        
        let storageReference = Storage.storage().reference()
        let currentUser = Auth.auth().currentUser
        let profileImageRef = storageReference.child("users").child(currentUser!.uid).child("\(currentUser!.uid)-profileImage.jpg")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            
//            activityIndicator.stopAnimating()
//            activityIndicator.removeFromSuperview()
            
            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                
                self.imagePhoto.image = UIImage(data: imageData)
                
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
            }
        }
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

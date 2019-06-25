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

struct Sourse {
    var name: String
    var docId: String
    
    var dictionary: [String: Any] {
        return [
            "nameOfWish": name,
            "UID": docId
        ]
    }
}

class ProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDataSource,UITableViewDelegate {
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sourseArray.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishCell", for: indexPath)
        
        let sourse = sourseArray[indexPath.row]
        
        cell.textLabel?.text = "\(sourse.name)"
        cell.detailTextLabel?.text = "\(sourse.docId)"
        
        return cell
    }
    
    
    var ref:DatabaseReference?
    var db: Firestore!
    var sourseArray = [Sourse]()


    
    
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var dateOfBirth: UILabel!
    @IBOutlet weak var age: UILabel!
    
    @IBOutlet weak var zodiacLogo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutField: UITextView!
    
    @IBOutlet weak var wishTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ref = Database.database().reference()
        //db = Firestore.firestore()
        //MARK: Animation
        
        imagePhoto.layer.cornerRadius = imagePhoto.frame.size.width/2
        imagePhoto.clipsToBounds = true
        //MARK: Autentifiacion controll
        checkPermission()
        //MARK: Get data from database firestore
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        let userID = Auth.auth().currentUser?.uid ?? "Null"
        db.collection("usersAuth").document(userID).collection("userInfo").whereField("UID", isEqualTo: userID).getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                for document in (snapshot?.documents)!{
                    if let name = document.data()["userName"] as? String{
                        if let dateBirth = document.data()["dateOfBirth"] as? String{
                            if let about = document.data()["About"] as? String{
                                
                                print(name)
                                self.nameLabel?.text = name
                                self.dateOfBirth?.text = dateBirth
                                self.aboutField?.text = about
                                let age  = getAgeFromDOF(date: dateBirth)
                                self.age?.text = "\(age.0) years"
                                let zodiac = getSignoZodiacal(date: dateBirth)
                                print(zodiac)
                                
                            }
                        }
                    }
                }
            }
        
        
        //MARK: Get data from database firestore
        }
        func loadDataforDatabase(){
            
        }
        
        //MARK: Get AGE whith date of birth
        func getAgeFromDOF(date: String) -> (Int,Int,Int) {
            
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd.MM.yyyy"
            let dateOfBirth = dateFormater.date(from: date)
            
            let calender = Calendar.current
            
            let dateComponent = calender.dateComponents([.year, .month, .day], from:
                dateOfBirth!, to: Date())
            
            return (dateComponent.year!, dateComponent.month!, dateComponent.day!)
        }
        //MARK: Get ZODIAC whith date of birth
        func getSignoZodiacal(date:String) -> String {
            
            let f = date.components(separatedBy: ".")
            let dia = Int(f[0])
            let mes = Int(f[1])
            
            
            if mes == 1 {
                if dia! >= 21 {
                    self.zodiacLogo.image = UIImage(named: "aquarius")
                    return "Aquarius"
                }else {
                    self.zodiacLogo.image = UIImage(named: "capricorn")
                    return "Capricorn"
                }
            }else if mes == 2 {
                if dia! >= 20 {
                    self.zodiacLogo.image = UIImage(named: "pisces")
                    return "Pisces"
                }else {
                    self.zodiacLogo.image = UIImage(named: "aquarius")
                    return "Aquarius"
                }
            }else if mes == 3 {
                if dia! >= 21 {
                    self.zodiacLogo.image = UIImage(named: "aries")
                    return "Aries"
                }else {
                    self.zodiacLogo.image = UIImage(named: "pisces")
                    return "Pisces"
                }
            }else if mes == 4 {
                if dia! >= 21 {
                    self.zodiacLogo.image = UIImage(named: "taurus")
                    return "Taurus"
                }else {
                    self.zodiacLogo.image = UIImage(named: "aries")
                    return "Aries"
                }
            }else if mes == 5 {
                if dia! >= 22 {
                    self.zodiacLogo.image = UIImage(named: "gemini")
                    return "Gemini"
                }else {
                    self.zodiacLogo.image = UIImage(named: "taurus")
                    return "Taurus"
                }
            }else if mes == 6 {
                if dia! >= 22 {
                    self.zodiacLogo.image = UIImage(named: "cancer")
                    return "Cancer"
                }else {
                    self.zodiacLogo.image = UIImage(named: "gemini")
                    return "Gemini"
                }
            }else if mes == 7 {
                if dia! >= 23 {
                    self.zodiacLogo.image = UIImage(named: "leo")
                    return "Leo"
                }else {
                    self.zodiacLogo.image = UIImage(named: "cancer")
                    return "Cancer"
                }
            }else if mes == 8 {
                if dia! >= 23 {
                    self.zodiacLogo.image = UIImage(named: "virgo")
                    return "Virgo"
                }else {
                    self.zodiacLogo.image = UIImage(named: "leo")
                    return "Leo"
                }
            }else if mes == 9 {
                if dia! >= 24 {
                    self.zodiacLogo.image = UIImage(named: "libra")
                    return "Libra"
                }else {
                    self.zodiacLogo.image = UIImage(named: "virgo")
                    return "Virgo"
                }
            }else if mes == 10 {
                if dia! >= 24 {
                    self.zodiacLogo.image = UIImage(named: "scorpio")
                    return "Scorpio"
                }else {
                    self.zodiacLogo.image = UIImage(named: "libra")
                    return "Libra"
                }
            }else if mes == 11 {
                if dia! >= 23 {
                    self.zodiacLogo.image = UIImage(named: "sagittarius")
                    return "Sagittarius"
                }else {
                    self.zodiacLogo.image = UIImage(named: "scorpio")
                    return "Scorpio"
                }
            }else if mes == 12 {
                if dia! >= 22 {
                    self.zodiacLogo.image = UIImage(named: "capricorn")
                    return "Capricorn"
                }else {
                    self.zodiacLogo.image = UIImage(named: "sagittarius")
                    return "Sagittarius"
                }
            }
            return ""
        }
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: ZOOM photo for tap
    @IBAction func openZoomingController(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "zooming", sender: nil)//imageView.image)
    }
    
    
    //Logaut
    @IBAction func logoutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            
        }catch{
            print(error)
        }
    }
    //MARK: EDIT Wish Board
    
    @IBAction func editWishes(_ sender: Any) {
        wishTable.isEditing = !wishTable.isEditing
    }
    
    
    
    // ADD new PHoto profile
    @IBAction func setProfileImageButtonTapped(_ sender: Any) {
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
            imagePhoto.image = selectedImage
            //uploadProfileImage(imageData: selectedImageFromPicker)
        }
        dismiss(animated: true, completion: nil)
        
    
    //MARK: Upload photo to database
        let store = Storage.storage()
        let storeRef = store.reference()
        let userProfilesRef = storeRef.child("images/profiles")
        let logoRef = storeRef.child("images/logo.png")
        var data = Data()
        data = self.imagePhoto.image!.pngData()!

        let userID = Auth.auth().currentUser?.uid ?? "Null"

        let uploadUserProfileTask = userProfilesRef.child("\(userID).png").putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("Error occurred: \(error)")
                return
            }
            let downloadURL = metadata.name
            print("download url for profile is \(metadata)")
            self.db.collection("usersAuth").document(userID).collection("userInfo").document().setData(["imageUrl" : downloadURL!], merge: true)
        }
        let progressObserver = uploadUserProfileTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print(percentComplete)
        }
        }

  
    //MARK: AUtentification controll func
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



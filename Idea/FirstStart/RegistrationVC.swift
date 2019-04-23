//
//  RegistrationVC.swift
//  Idea
//
//  Created by Aleksandr Kovalchuk on 18.04.2019.
//  Copyright © 2019 Aleksandr Kovalchuk. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var google: UIButton!
    
    
    @IBOutlet weak var UploadPhoto: UIButton!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var txtDatePicker: UITextField!
    let datePicker = UIDatePicker()

    
    @IBOutlet weak var hintAbout: UILabel!
    @IBOutlet weak var aboutField: UITextView!
    
    @IBOutlet weak var regButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDatePicker()

        regButton.layer.cornerRadius = 15
        
        logo.alpha = 0
        facebook.alpha = 0
        google.alpha = 0
        avatar.alpha = 0
        numberField.alpha = 0
        nameField.alpha = 0
        txtDatePicker.alpha = 0
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
                        }){ _ in
                            UIView.animate(withDuration: 0.4, animations: {
                                self.nameField.alpha = 1
                            }){ _ in
                                UIView.animate(withDuration: 0.3, animations: {
                                    self.txtDatePicker.alpha = 1
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

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hidekeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func hidekeyboard(){
        view.endEditing(true)
    }
    
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



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

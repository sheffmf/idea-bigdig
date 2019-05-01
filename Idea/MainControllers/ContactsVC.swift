//
//  ContactsVC.swift
//  Idea
//
//  Created by Aleksandr Kovalchuk on 07.04.2019.
//  Copyright © 2019 Aleksandr Kovalchuk. All rights reserved.
//

import UIKit
import ContactsUI


class ContactsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var contactTable: UITableView!
    
    //var arrayPersons = [CNContact]()
    var contacts = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let contactStore = CNContactStore()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                self.contacts.append(contact)
                self.contactTable.reloadData()
            }
        }
        catch {
            print("unable to fetch contacts")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFriendsProfile"{
            let vc = segue.destination as! FrindProfileVC
            //vc.nameString = sender as! String
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showFriendsProfile"{
//            let vc = segue.destination as!
//            vc.textString = sender as! String
        }
   }
    
    
    //Func of delegate - section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //Num of stroke in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }// Cell in table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! UITableViewCell

        let cont = contacts[indexPath.row]
        cell.textLabel?.text = cont.givenName + "  " + cont.familyName
        
        //cell.accessoryType = .detailButton
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cont = contacts[indexPath.row]

        self.performSegue(withIdentifier: "showFriendsProfile", sender: "\(cont.givenName)"
        )
    }

   

}

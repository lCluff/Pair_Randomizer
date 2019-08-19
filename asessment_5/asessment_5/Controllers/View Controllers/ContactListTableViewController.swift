//
//  ContactListTableViewController.swift
//  asessment_5
//
//  Created by Leah Cluff on 7/12/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.sharedInstance.contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = ContactController.sharedInstance.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = "\(contact.phoneNumber)"
        return cell
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
           
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExistingDetailVC" {
            guard let index = tableView.indexPathForSelectedRow?.row else {return}
            let destinationVC = segue.destination as? ContactDetailViewController
            let contact = ContactController.sharedInstance.contacts[index]
            destinationVC?.contact = contact
            }
        }
    }
    
    //MARK: - Functions
    func fetchContacts() {
   
    }


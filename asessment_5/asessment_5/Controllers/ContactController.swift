//
//  ContactController.swift
//  asessment_5
//
//  Created by Leah Cluff on 7/12/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    
    //Define what database I'm using
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //Singleton
    static let sharedInstance = ContactController()
    
    //SOT
    var contacts: [Contact] = []
    
    //Methods
    func createContacts(name: String, email: String, phoneNumber: String) {
        let newContact = Contact(name: name, email: email, phoneNumber: phoneNumber)
        let record = CKRecord(contact: newContact)
        let database = ContactController.sharedInstance
        
    }
    
    func fetchContacts(completion: @escaping(Bool) -> Void) {
        let type = ContactConstants.typeKey
        let database = ContactController.sharedInstance.privateDB
      //  ContactController.sharedInstance.fetchContacts(type: type, database: database) { (records, error) in
            if let error = error {
                print("There was an error in \(#function) ; \(error) ; \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    //removing the contacts locally
    func removeContactsLocally(contact: Contact, completion: @escaping(Bool) -> Void) {
        guard let index = contacts.firstIndex(of: contact) else {return}
        contacts.remove(at: index)
        let dataBase = ContactController.sharedInstance.privateDB
        ContactController.sharedInstance.deleteFromCloudKit(recordID: contact.ckRecordID, database: dataBase) { (success) in
            completion(success ? true : false)
        }
    }
    
    //updating contacts locally, you can tell I'm not as comfy with this as I am with the create function
    func updateContact(contact: Contact, withName name: String, email: String, phoneNumber: String) {
        contact.name = name
        contact.email = email
        contact.phoneNumber = phoneNumber
        
        let recordToSave = CKRecord(contact: contact)
        let dataBase = ContactController.sharedInstance.privateDB
        ContactController.sharedInstance.updateContactsinCloudKit(record: recordToSave, database: dataBase) { (success) in
            if success {
                print("contacts successfully updated")
            }
        }
    }
}

///CLOUD KIT FUNCTIONS
extension ContactController {
    
    //Pulling contacts from cloudkit
    func fetchContacts(type: String, database: CKDatabase, completion: @escaping([Contact]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactConstants.typeKey, predicate: predicate)
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error in \(#function) ; \(error) ; \(error.localizedDescription)")
                completion(nil)
                return
            }
            //HIGHER FUNCTION YOOOOOOO
            guard let records = records else {completion(nil); return}
            let contacts: [Contact] = records.compactMap({ Contact(ckRecord: $0)})
            self.contacts = contacts
            completion(contacts)
        }
    }
    
    //updating contacts in cloudkit
    func updateContactsinCloudKit(record: CKRecord, database: CKDatabase, completion: @escaping(Bool) -> Void) {
        let operation = CKModifyRecordsOperation()
        operation.recordsToSave = [record]
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.queuePriority = .high
        operation.completionBlock = {
            completion(true)
        }
        database.add(operation)
    }
    
    func deleteFromCloudKit(recordID: CKRecord.ID, database: CKDatabase, completion: @escaping(Bool) -> Void) {
        database.delete(withRecordID: recordID) { (_, error) in
            if let error = error {
                print("There was an error in \(#function) ; \(error) ; \(error.localizedDescription)")
                completion(false)
            }
            completion(true)
        }
    }
    
    func saveInCloudKit(record: CKRecord, database: CKDatabase, completion: @escaping (Bool) -> Void) {
        database.save(record) { (_, error) in
            if let error = error {
                print("There was an error in \(#function) ; \(error) ; \(error.localizedDescription)")
                completion(false)
            }
            print(#function)
            completion(true)
        }
    }
}

//
//  Contact.swift
//  asessment_5
//
//  Created by Leah Cluff on 7/12/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation
import CloudKit

//Creating a contact constant to prevent typo issues.
struct ContactConstants {
    static let typeKey = "Post"
    fileprivate static let nameKey = "name"
    fileprivate static let emailKey = "email"
    fileprivate static let phoneNumberKey = "phoneNumber"
}

class Contact {
    //properties
    var name: String
    var email: String
    var phoneNumber: String
    let ckRecordID: CKRecord.ID
    
    init(name: String, email: String, phoneNumber: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.ckRecordID = ckRecordID
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[ContactConstants.nameKey] as? String,
        let email = ckRecord[ContactConstants.emailKey] as? String,
        let phoneNumber = ckRecord[ContactConstants.phoneNumberKey] as? String
            else { return nil }
        self.init(name: name, email: email, phoneNumber: phoneNumber, ckRecordID: ckRecord.recordID)
    }
}

//Making Contact equatable
extension Contact: Equatable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

//CKRecord Extension
extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: ContactConstants.typeKey, recordID: contact.ckRecordID)
        self.setValue(contact.name, forKey: ContactConstants.nameKey)
        self.setValue(contact.email, forKey: ContactConstants.emailKey)
        self.setValue(contact.phoneNumber, forKey: ContactConstants.phoneNumberKey)
        
    }
}

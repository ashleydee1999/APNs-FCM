//
//  Contact.swift
//  janus-sip-swift (iOS)
//
//  Created by ty tongai munashe chikondo on 6/12/2021.
//

import Foundation

// FROM : api/secure/contacts
struct ContactsResponse: Codable {
    let success: Bool
    let message: String?
    let error: String?
    let data: [Contacts]?
}

// NOTE : used to both ADD, EDIT, LIST contacts
// MARK: - Contacts
struct Contacts: Codable, Comparable {
    let id: Int
    let firstName, lastName, companyName, department: String
    let mobileNumbers: MobileNumbers
    let emails: Emails
    let websiteURL, country, ringtone: String?
    let namePrefix, nameSuffix, phoneticFirst, phoneticMiddle: String?
    let phoneticLast, nickname, savedAs, birthDate: String?
    let relationship: String?
    let notes, jobTitle, province, unitStreet: String?
    let city, middleName, postCode, source: String?
    
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, companyName, department, mobileNumbers, emails
        case websiteURL = "websiteUrl"
        case country, ringtone, namePrefix, nameSuffix, phoneticFirst, phoneticMiddle, phoneticLast, nickname, savedAs, birthDate, relationship, notes, jobTitle, province, unitStreet, city, middleName, postCode, source
    }
    
    static func ==(lhs: Contacts, rhs: Contacts) -> Bool {
            return lhs.firstName == rhs.firstName
        }

        static func <(lhs: Contacts, rhs: Contacts) -> Bool {
            return lhs.firstName < rhs.firstName
        }
}

struct AddContacts: Codable {
    
    let firstName, lastName, companyName, department: String
    let mobileNumbers: MobileNumbers2
    let emails: Emails2
    let websiteURL, country, ringtone, profileImage: String
    let namePrefix, nameSuffix, phoneticFirst, phoneticMiddle: String
    let phoneticLast, nickname, savedAs, birthDate: String
    let relationship: String
    let notes, jobTitle, province, unitStreet: String
    let city, middleName, postCode, source: String
    
    enum CodingKeys: String, CodingKey {
        case profileImage, firstName, lastName, companyName, department, mobileNumbers, emails
        case websiteURL = "websiteUrl"
        case country, ringtone, namePrefix, nameSuffix, phoneticFirst, phoneticMiddle, phoneticLast, nickname, savedAs, birthDate, relationship, notes, jobTitle, province, unitStreet, city, middleName, postCode, source
    }
}

struct MobileNumbers2: Codable
{
    let numberList: [NumberList2]
}
struct Emails2: Codable
{
    let emailList: [EmailList2]
}
struct EmailList2: Codable
{
    let email: String
    let type: String?
}
struct NumberList2: Codable
{
    let number: String
    let type: String?
}


public class MobileNumbers: NSObject, NSCoding, Codable {
   
    public var numberList: [NumberList]
    
    enum Key:String {
        case numberList = "numberList"
    }
    
    init(numberList: [NumberList]) {
        self.numberList = numberList
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(numberList, forKey: Key.numberList.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mRanges = aDecoder.decodeObject(forKey: Key.numberList.rawValue) as! [NumberList]
        
        self.init(numberList: mRanges)
    }
}

public class NumberList: NSObject, NSCoding, Codable {
   
    public var number, type: String
    
    enum Key:String {
        case number = "number"
        case type = "type"
    }
    
    init(number: String, type: String) {
        self.number = number
        self.type = type
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(number, forKey: Key.number.rawValue)
        aCoder.encode(type, forKey: Key.type.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mNumber = aDecoder.decodeObject(forKey: Key.number.rawValue) as! String
        let mType = aDecoder.decodeObject(forKey: Key.type.rawValue) as! String
        
        self.init(number: mNumber, type: mType)
    }
}

public class Emails: NSObject, NSCoding, Codable {
   
    public var emailList: [EmailList]
    
    enum Key:String {
        case emailList = "emailList"
    }
    
    init(emailList: [EmailList]) {
        self.emailList = emailList
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(emailList, forKey: Key.emailList.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mEmailList = aDecoder.decodeObject(forKey: Key.emailList.rawValue) as! [EmailList]
        
        self.init(emailList: mEmailList)
    }
}

public class EmailList: NSObject, NSCoding, Codable {
   
    public var email, type: String
    
    enum Key:String {
        case email = "email"
        case type = "type"
    }
    
    init(email: String, type: String) {
        self.email = email
        self.type = type
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey: Key.email.rawValue)
        aCoder.encode(type, forKey: Key.type.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mNumber = aDecoder.decodeObject(forKey: Key.email.rawValue) as! String
        let mType = aDecoder.decodeObject(forKey: Key.type.rawValue) as! String
        
        self.init(email: mNumber, type: mType)
    }
}


struct ContactDeleteJSON: Codable
{
    let contactID: Int
    
    enum CodingKeys: String, CodingKey {
        case contactID = "id"
    }
}

class MobileNumbersAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        [MobileNumbers.self]
    }
    
    static func register() {
        let className = String(describing: MobileNumbersAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = MobileNumbersAttributeTransformer()
        
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
class EmailsAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        [Emails.self]
    }
    
    static func register() {
        let className = String(describing: EmailsAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = EmailsAttributeTransformer()
        
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}

//
//  FCMDecoders.swift
//  FCMAppTut
//
//  Created by Ashley Dube on 2022/07/16.
//

import Foundation
struct Payload: Codable {
    let type, resource: String
//    let aps: APS
    let payload: String // Doesn't work if -> let payload [INTS] -> It doe
}

struct APS: Codable {
    let alert: Alert
}

struct Alert: Codable {
    let body: String
    let subtitle: String?
    let title: String?
}
struct INTS: Codable, Identifiable {
    let id = UUID()
    let payloadID: Int
    
    enum CodingKeys: String, CodingKey{
        case payloadID = "id"
    }
}

// Getting Notification Type
struct TypeResponse: Codable{
    let type, topic: String?
    let isSilentNotif: String
    let payload: String
}

//

struct ContactsPayload: Codable {
    let type, resource, topic: String?
//    let aps: APS
    let payload: String // must be decoded 2x, because the JSONSerialization API turns it into a String
}

struct CallHistoryResponse: Codable {
    let success: Bool
    let error: String?
    let errors: [GenricErrors]?
    let message: String?
    let data: [CallHistory]?
    let stats: CallHistoryStats?
}

// MARK: - CallHistory
struct CallHistory: Codable {
    let endTime, startTime, formattedDate, disposition: String
    let durationInSeconds: Int
    let destination, callingNumber: String
    let callTypeEventID: Int
    let callTypeEvent, callingPlatform, uniqueid: String
    let logDeleted: Bool
    let deletedDate: String?
    let callee: Callee
    let caller: Caller
    let callableNumber: String
    let isSaved: Bool
    
    enum CodingKeys: String, CodingKey {
        case endTime, startTime, formattedDate, disposition, durationInSeconds, destination, callingNumber
        case callTypeEventID = "callTypeEventId"
        case logDeleted = "deleted"
        case callTypeEvent, callingPlatform, uniqueid, deletedDate, callee, caller, callableNumber, isSaved
    }
}

// MARK: - CallHistoryStats
struct CallHistoryStats: Codable {
    let missed, outgoing, incoming, rejected: Int
}

struct CallHistoryDeleteJSON: Codable
{
    let uniqueid: String
    
    enum CodingKeys: String, CodingKey {
        case uniqueid = "uniqueId"
    }
}

//struct Callee: Codable {
//    let number, displayName: String
//}

//struct Caller: Codable {
//    let callable: Bool
//    let number, displayName: String
//}

public class Callee: NSObject, NSCoding, Codable {
   
    public var number, displayName: String
    
    enum Key:String {
        case number = "number"
        case displayName = "displayName"
    }
    
    init(number: String, displayName: String) {
        self.number = number
        self.displayName = displayName
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(number, forKey: Key.number.rawValue)
        aCoder.encode(displayName, forKey: Key.displayName.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mNumber = aDecoder.decodeObject(forKey: Key.number.rawValue) as! String
        let mDisplayName = aDecoder.decodeObject(forKey: Key.displayName.rawValue) as! String
        
        self.init(number: mNumber, displayName: mDisplayName)
    }
}

public class Caller: NSObject, NSCoding, Codable {
   
    public var callable: Bool
    public var number, displayName: String
    
    enum Key:String {
        case callable = "callable"
        case number = "number"
        case displayName = "displayName"
    }
    
    init(callable: Bool, number: String, displayName: String) {
        self.callable = callable
        self.number = number
        self.displayName = displayName
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(callable, forKey: Key.callable.rawValue)
        aCoder.encode(number, forKey: Key.number.rawValue)
        aCoder.encode(displayName, forKey: Key.displayName.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mCallable = aDecoder.decodeObject(forKey: Key.callable.rawValue) as! Bool
        let mNumber = aDecoder.decodeObject(forKey: Key.number.rawValue) as! String
        let mDisplayName = aDecoder.decodeObject(forKey: Key.displayName.rawValue) as! String
        
        self.init(callable: mCallable, number: mNumber, displayName: mDisplayName)
    }
}

struct GenericResponse: Codable {
    let success: Bool
    let error: String?
    let errors: [GenricErrors]?
    let message: String?
}

struct GenricErrors: Codable {
    let msg: String
    let field: String
}

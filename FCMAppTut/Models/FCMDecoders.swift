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
}

//

struct ContactsPayload: Codable {
    let type, resource, topic: String?
//    let aps: APS
    let payload: String // must be decoded 2x, because the JSONSerialization API turns it into a String
}

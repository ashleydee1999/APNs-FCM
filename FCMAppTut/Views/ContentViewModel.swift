//
//  ViewModel.swift
//  FCMAppTut
//
//  Created by Ashley Dube on 2022/07/19.
//

import Foundation
import SwiftUI
import CoreData

class ContentViewModel: ObservableObject
{
    static let shared = ContentViewModel()
    @Published var updatedIDs: [INTS] = [INTS]()
    @Published var contacts: [Contacts] = [Contacts]()
    @Published var red: Double = 0
    @Published var green: Double = 0
    @Published var blue: Double = 0
    
    @Published var firstName = ""
    @Published var allContacts: [ContactsCD] = []
    let manager = CoreDataManager(modelName: "ContactsCD")

    //Initializer access level change now
    private init(){
        fetchMessages()
    }
    
    func getLogs() {

        //URLComponents to the rescue!
        let urlBuilder = URLComponents(string: "https://stage-api.yootok.com/api/secure/contacts")

        guard let url = urlBuilder?.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("ios", forHTTPHeaderField: "fcm-agent")
        request.setValue(
            "SID=SID:jg4p1n1017l-1g17na-4k1ob-8q1h1d-91u1ul-k1b1p141gv61m1617281107800;TimeZone=Africa/Johannesburg;Lang=en", forHTTPHeaderField: "ltz-device")
        request.setValue("token "+"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjE3OSwiaWF0IjoxNjU4MTU1NTgyLCJleHAiOjE2NjAzMTU1ODIsInR5cGUiOiJBQ0NFU1MifQ.nzmiukgH7D9sUq3qupyCH98ycMyEIF4PO1gPgCavX1c", forHTTPHeaderField: "Authorization")


        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            print(response)
            let myString = String(data: data ?? Data(), encoding: .utf8)!
            let myData = Data(myString.utf8)
            let payload = try! JSONDecoder().decode(ContactsResponse.self, from: myData)
            
            DispatchQueue.main.async {
                if let contactsData = payload.data{
                    self.contacts = contactsData.sorted(by: { (img0: Contacts, img1: Contacts) -> Bool in
                        return img1.firstName > img0.firstName
                    })
                }
            }
            
            
        }.resume()
    }
    
    func getJSON(){
        print("Attempting to fetch json")
        if let url = URL(string: "http://192.168.101.112:4000/sendToAll") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let parsedJSON = try jsonDecoder.decode(Payload.self, from: data)
                        
                        print("parsedJSON: \(parsedJSON)")
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func fetchMessages() {

        let fetchRequest: NSFetchRequest<ContactsCD> = ContactsCD.fetchRequest()

        manager.mainManagedObjectContext.performAndWait {
            do {
                let msgs = try fetchRequest.execute()
                allContacts = msgs
                for eachMsg in msgs {
                    print(eachMsg.firstName ?? "NO firstName")
                    print(eachMsg.lastName ?? "NO lastName")
                }
                if msgs.isEmpty {
                    print("no data")
                }
            } catch {
                print("error in fetching messages")
                print(error.localizedDescription)
            }
        }
    }
    
}

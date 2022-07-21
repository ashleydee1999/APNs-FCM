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
    
    let persistentContainer = CoreDataManager.shared.persistentContainer
    //Initializer access level change now
    private init(){
        fetchContacts()
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
    
    // Core Data Functions
    
    func fetchContacts(){
        let request = NSFetchRequest<ContactsCD>(entityName: "ContactsCD")
        
        do{
            allContacts = try persistentContainer.viewContext.fetch(request)
            
//            let data = allContacts[0]
//            
//            print("Number 1: \(data.mobileNumbers!.numberList[0].number) Number 2: \(data.mobileNumbers!.numberList[1].number)")
            
            
            /*
             let result = try managedContext.fetch(fetchRequest)
             
             print("Your result: \(result)")

             var i = 0
             for data in result as! [NSManagedObject] {
                 let mranges = data.value(forKey: "range") as! Ranges
                 print(" range batch : \(i)")
                 for element in mranges.ranges {
                     print("location:\(element.location), length:\(element.length)")
                 }
                 i = i + 1
             }
             */
        }catch{
            print("Error: \(error) \n Localised Error: \(error.localizedDescription)")
        }
        
    }
    
    func deleteContact(at offsets: IndexSet){
        offsets.forEach { index in
            let contact = allContacts[index]
            persistentContainer.viewContext.delete(contact)
        }
        saveData()
        
    }
    func saveContact(){
        let contact = ContactsCD(context: persistentContainer.viewContext)
        contact.firstName = firstName
//        contact.lastName = selectedPriority.rawValue
        saveData()
    }
    func updateContact(_ contact: ContactsCD){
//        contact.isFavourite.toggle()
        saveData()
    }
    
    func saveData(){
        do{
            try persistentContainer.viewContext.save()
            fetchContacts()
        }catch{
            print("Error: \(error) \n Localised Error: \(error.localizedDescription)")
        }
    }
}

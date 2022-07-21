//
//  CoreDataManager.swift
//  FCMAppTut
//
//  Created by Ashley Dube on 2022/07/19.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let decoder = JSONDecoder()
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    
    
    private init(){
        persistentContainer = NSPersistentContainer(name: "ContactsCD")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }else{
                print("Successfully loaded Core Data!")
            }
        }
    }
    
    func saveContact(payloadData: Data){
        let contact = ContactsCD(context: persistentContainer.viewContext)
        do{
            let payload = try decoder.decode(ContactsPayload.self, from: payloadData)
            let payloadData = Data(payload.payload.utf8)
            let payloadArr = try decoder.decode(Contacts.self, from: payloadData)
            
            contact.id = Int64(payloadArr.id)
            contact.firstName = payloadArr.firstName
            contact.lastName = payloadArr.lastName
            contact.mobileNumbers = payloadArr.mobileNumbers
            contact.emails = payloadArr.emails
            saveData()
        }catch {
            print(error)
        }
        
    }
    
    func deleteContact(payloadData: Data){
        do{
            let request = NSFetchRequest<ContactsCD>(entityName: "ContactsCD")
            let payload = try decoder.decode(Payload.self, from: payloadData)
            
           
            
            let payloadData = Data(payload.payload.utf8)
            let payloadArr = try decoder.decode([INTS].self, from: payloadData)
            
            print("Your Deleted payload \(payloadArr)")
            
            request.predicate = NSPredicate(format: "id == %i", Int64(payloadArr[0].payloadID))

            let deleted = try persistentContainer.viewContext.fetch(request)
           
            persistentContainer.viewContext.delete(deleted[0])
            
            saveData()
            
        }catch {
            print(error)
        }
        
    }
    
    func updateContact(payloadData: Data){
        do{
            let request = NSFetchRequest<ContactsCD>(entityName: "ContactsCD")
            
            let payload = try decoder.decode(ContactsPayload.self, from: payloadData)
            let payloadData = Data(payload.payload.utf8)
            let payloadArr = try decoder.decode(Contacts.self, from: payloadData)
            
            request.predicate = NSPredicate(format: "id == %i", Int64(payloadArr.id))

            let updated = try persistentContainer.viewContext.fetch(request)
            
           
            updated[0].emails = payloadArr.emails
            
            saveData()
            
        }catch {
            print(error)
        }
        
    }
    
    func testAdd()
    {
        let contact = ContactsCD(context: persistentContainer.viewContext)
        
        var numberList = [NumberList]()
        var emailList = [EmailList]()
        
        numberList.append(NumberList(number: "0838642247", type: "Mobile"))
        numberList.append(NumberList(number: "0735563333", type: "Work"))
        
        emailList.append(EmailList(email: "ash@dee.co.za", type: "Mobile"))
        emailList.append(EmailList(email: "dube@yiya.co.za", type: "Work"))
        
        contact.id = 1
        contact.firstName = "Ashley"
        contact.lastName = "Dube"
        contact.mobileNumbers = MobileNumbers(numberList: numberList)
        contact.emails = Emails(emailList: emailList)
        saveData()
    }
    
    func saveData(){
        do{
            try persistentContainer.viewContext.save()
            ContentViewModel.shared.fetchContacts()
        }catch{
            print("Error: \(error) \n Localised Error: \(error.localizedDescription)")
        }
    }
    
    
}

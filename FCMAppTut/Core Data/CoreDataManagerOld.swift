//
//  CoreDataManager.swift
//  FCMAppTut
//
//  Created by Ashley Dube on 2022/07/19.
//

import Foundation
import CoreData

class CoreDataManagerOld: NSPersistentContainer {
    
    let decoder = JSONDecoder()
    
    static let shared: CoreDataManagerOld = {
        
        let container = CoreDataManagerOld(name: "ContactsCD")
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
            
            print("Successfully loaded persistent store at: \(desc.url?.description ?? "nil")")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyStoreTrumpMergePolicyType)
        
        return container
    }()
    
    override func newBackgroundContext() -> NSManagedObjectContext {
        let backgroundContext = super.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyStoreTrumpMergePolicyType)
        return backgroundContext
    }
    
    func updateContact(payloadData: Data){
        let context = newBackgroundContext()
        context.perform {
            do {
                
                let allEntriesRequest = NSFetchRequest<ContactsCD>(entityName: "ContactsCD")
                let payload = try self.decoder.decode(ContactsPayload.self, from: payloadData)
                let payloadData = Data(payload.payload.utf8)
                let payloadArr = try self.decoder.decode(Contacts.self, from: payloadData)
                allEntriesRequest.predicate = NSPredicate(format: "id == %i", Int64(payloadArr.id))
                let updated = try context.fetch(allEntriesRequest)
                
                updated[0].firstName = payloadArr.firstName
                updated[0].lastName = payloadArr.lastName
//                updated[0].mobileNumbers = payloadArr.mobileNumbers
//                updated[0].emails = payloadArr.emails
                
                try context.save()
                
            } catch {
                print("Could not update data due to \(error)")
            }
        }
    }
    /*
     do{
     
     let request = NSFetchRequest<ContactsCD>(entityName: "ContactsCD")
     
     let payload = try decoder.decode(ContactsPayload.self, from: payloadData)
     let payloadData = Data(payload.payload.utf8)
     let payloadArr = try decoder.decode(Contacts.self, from: payloadData)
     
     request.predicate = NSPredicate(format: "id == %i", Int64(payloadArr.id))
     
     let updated = try persistentContainer.viewContext.fetch(request)
     
     updated[0].firstName = payloadArr.firstName
     updated[0].mobileNumbers = payloadArr.mobileNumbers
     updated[0].emails = payloadArr.emails
     
     saveData()
     
     }catch {
     print(error)
     }
     
     */
    
    func saveContact(payloadData: Data){
        let context = newBackgroundContext()
        let contact = ContactsCD(context: context)
        context.perform { [self] in
            do{
                let payload = try decoder.decode(ContactsPayload.self, from: payloadData)
                let payloadData = Data(payload.payload.utf8)
                let payloadArr = try decoder.decode(Contacts.self, from: payloadData)
                
                contact.id = Int64(payloadArr.id)
                contact.firstName = payloadArr.firstName
                contact.lastName = payloadArr.lastName
//                contact.mobileNumbers = payloadArr.mobileNumbers
//                contact.emails = payloadArr.emails
                
                try context.save()
            }catch {
                print(error)
            }
        }
        
    }
    
    func saveContact(_ id: Int, _ firstName: String, _ lastName: String){
        let context = newBackgroundContext()
        let contact = ContactsCD(context: context)
        context.perform {
            do{
                
                contact.id = Int64(id)
                contact.firstName = firstName
                contact.lastName = lastName
//                contact.mobileNumbers = payloadArr.mobileNumbers
//                contact.emails = payloadArr.emails
                
                try context.save()
            }catch {
                print(error)
            }
        }
        
    }
}

/*
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
 
 /*
  func loadInitialData(onlyIfNeeded: Bool = true) {
  let context = newBackgroundContext()
  context.perform {
  do {
  let allEntriesRequest: NSFetchRequest<NSFetchRequestResult> = FeedEntry.fetchRequest()
  if !onlyIfNeeded {
  // Delete all data currently in the store
  let deleteAllRequest = NSBatchDeleteRequest(fetchRequest: allEntriesRequest)
  deleteAllRequest.resultType = .resultTypeObjectIDs
  let result = try context.execute(deleteAllRequest) as? NSBatchDeleteResult
  NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: result?.result as Any],
  into: [self.viewContext])
  }
  if try !onlyIfNeeded || context.count(for: allEntriesRequest) == 0 {
  let now = Date()
  let start = now - (7 * 24 * 60 * 60)
  let end = now - (60 * 60)
  
  _ = generateFakeEntries(from: start, to: end).map { FeedEntry(context: context, serverEntry: $0) }
  try context.save()
  
  self.lastCleaned = nil
  }
  } catch {
  print("Could not load initial data due to \(error)")
  }
  }
  }
  */
 
 func updateContact(payloadData: Data){
 let context = newBackgroundContext()
 context.perform {
 do {
 
 let allEntriesRequest = NSFetchRequest<ContactsCD>(entityName: "ContactsCD")
 let payload = try self.decoder.decode(ContactsPayload.self, from: payloadData)
 let payloadData = Data(payload.payload.utf8)
 let payloadArr = try self.decoder.decode(Contacts.self, from: payloadData)
 allEntriesRequest.predicate = NSPredicate(format: "id == %i", Int64(payloadArr.id))
 let updated = try context.fetch(allEntriesRequest)
 
 updated[0].firstName = payloadArr.firstName
 updated[0].mobileNumbers = payloadArr.mobileNumbers
 updated[0].emails = payloadArr.emails
 
 try context.save()
 
 } catch {
 print("Could not update data due to \(error)")
 }
 }
 
 /*
  do{
  
  let request = NSFetchRequest<ContactsCD>(entityName: "ContactsCD")
  
  let payload = try decoder.decode(ContactsPayload.self, from: payloadData)
  let payloadData = Data(payload.payload.utf8)
  let payloadArr = try decoder.decode(Contacts.self, from: payloadData)
  
  request.predicate = NSPredicate(format: "id == %i", Int64(payloadArr.id))
  
  let updated = try persistentContainer.viewContext.fetch(request)
  
  updated[0].firstName = payloadArr.firstName
  updated[0].mobileNumbers = payloadArr.mobileNumbers
  updated[0].emails = payloadArr.emails
  
  saveData()
  
  }catch {
  print(error)
  }
  
  */
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
 
 */


class DeleteFeedEntriesOperation: Operation {
    let decoder = JSONDecoder()
    private let context: NSManagedObjectContext
    var payloadData: Data
    var delay: TimeInterval = 0.0005
    
    init(context: NSManagedObjectContext, payloadData: Data) {
        self.context = context
        self.payloadData = payloadData
    }
    
    convenience init(context: NSManagedObjectContext, payloadData: Data, delay: TimeInterval? = nil) {
        self.init(context: context, payloadData: payloadData)
        if let delay = delay {
            self.delay = delay
        }
    }
    
    override func main() {
        
        print("Attempting to update a contact")
        
        let allEntriesRequest = NSFetchRequest<ContactsCD>(entityName: "ContactsCD")
        allEntriesRequest.includesPropertyValues = false
        
        context.performAndWait {
            do {
                
                let payload = try self.decoder.decode(ContactsPayload.self, from: payloadData)
                let payloadData = Data(payload.payload.utf8)
                let payloadArr = try self.decoder.decode(Contacts.self, from: payloadData)
                allEntriesRequest.predicate = NSPredicate(format: "id == %i", Int64(payloadArr.id))
                let updated = try context.fetch(allEntriesRequest)
                
                
                updated[0].firstName = payloadArr.firstName
                updated[0].lastName = payloadArr.lastName
//                updated[0].mobileNumbers = payloadArr.mobileNumbers
//                updated[0].emails = payloadArr.emails
                
                try context.save()
                
            } catch {
                print("Could not update data due to \(error)")
            }
        }
        
    }
}

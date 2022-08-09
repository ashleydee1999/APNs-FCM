//
//  FCMNotificationsHandler.swift
//  FCMAppTut
//
//  Created by Ashley Dube on 2022/07/19.
//

/*
 
 Classifications of  Notifiations
 
 • Contacts
 • Subscriptions
 • Call History
 • Orders and Invoices
 • Billing
 • Number verification status due to KYC
 
 */

import Foundation
@available(iOSApplicationExtension 13.0, *)
class FCMNotificationsHandler: ObservableObject{
    static let shared = FCMNotificationsHandler()
    
    let decoder = JSONDecoder()
    
    let TYPE_CREATED = "CREATED"
    let TYPE_DELETED = "DELETED"
    let TYPE_UPDATED = "UPDATED"

    let TOPIC                      = "topic"
    let TOPIC_CONTACTS             = "CONTACTS"
    let TOPIC_SUBS                 = "SUBSCRIPTION"
    let TOPIC_CALL_LOGS            = "CALL_LOGS"
    let TOPIC_ORDERS_INVOICES      = "ORDERS_INVOICES"
    let TOPIC_BILLING              = "BILLING"
    let TOPIC_NUMBER_VERIFICATION  = "NUMBER_VERIFICATION"
    let TOPIC_PROFILE              = "PROFILE"
    let TOPIC_INVOICE_USER_MINUTES = "INVOICE_USER_MINUTES"
    let TOPIC_INVOICE_DID_NUMBER   = "INVOICE_DID_NUMBER"
    let TOPIC_USER_MINUTES         = "USER_MINUTES"
    let TOPIC_CREDIT               = "CREDIT"
    
    private init(){}
    
    func receivedNotification(withUserInfo notificationPayload: [AnyHashable : Any]){
        let decoder = JSONDecoder()
        
        print("receivedNotification invoked")

        do {

            let data = try JSONSerialization.data(withJSONObject: notificationPayload, options: [])
            let myString = String(data: data, encoding: .utf8)!
            let myData = Data(myString.utf8)
            let payload = try decoder.decode(TypeResponse.self, from: myData)
            
            print("Your decoded FCM payload: \(payload)")
            
            
            if let topic = payload.topic{
                
                switch topic{
                    
//                    case TOPIC_CONTACTS:
//                        updateContact(withData: myData)
//                    case TOPIC_SUBS:
//                        updateSubscription()
                    case TOPIC_CALL_LOGS:
                        updateCallLog(withData: myData)
//                    case TOPIC_ORDERS_INVOICES:
//                        updateInvoice()
//                    case TOPIC_BILLING :
//                        updateBilling()
//                    case TOPIC_NUMBER_VERIFICATION:
//                        updateNumberVerification()
//                    case TOPIC_PROFILE:
//                        updateProfile()
//                    case TOPIC_INVOICE_USER_MINUTES:
//                        updateInvoiceUserMinutes()
//                    case TOPIC_INVOICE_DID_NUMBER:
//                        updateInvoiceDIDNumber()
//                    case TOPIC_USER_MINUTES:
//                        updateUserMinutes()
//                    case TOPIC_CREDIT:
//                        updateCredit()
                    default:
                        print("No applicable topic was found")
                    
                }
                
            }
            
            
        } catch {
            print(error)
        }
    }
    
    //MARK: Contacts Notifications
    
//    func updateContact(withData data: Data){
//        
//        do {
//            
//            let payload = try decoder.decode(TypeResponse.self, from: data)
//           
//            if payload.type == TYPE_CREATED{
//                CoreDataManagerOld.shared.saveContact(payloadData: data)
//            }
//            if payload.type == TYPE_UPDATED{
//                CoreDataManagerOld.shared.updateContact(payloadData: data)
//            }
////            if payload.type == TYPE_DELETED{
////                CoreDataManager.shared.deleteContact(payloadData: data)
////            }
////            
//            
//            
//        }catch {
//            print(error)
//        }
//        
//        
//        //contact update
//        /*
//        let decoder = JSONDecoder()
//
//        do {
//
//            let data = try JSONSerialization.data(withJSONObject: notificationPayload, options: [])
//            let myString = String(data: data, encoding: .utf8)!
//            let myData = Data(myString.utf8)
//            let payload = try decoder.decode(Payload.self, from: myData)
//            
//            print("Your decoded FCM payload: \(payload)")  // Up until this stage, I decode the JSON normally
//            
//            
//            /*
//                 Since the payload object is read as String, I cast it to Data in utf8
//                 then I decode it as an Array of Objects and it works
//             */
//            
//            let payloadData = Data(payload.payload.utf8)
//            let payloadArr = try decoder.decode([INTS].self, from: payloadData)
//
//            print("payloadArr: \(payloadArr)")
//            
//            ContentViewModel.shared.firstName = "Ashley"
//            ContentViewModel.shared.saveContact()
//            
//        } catch {
//            print(error)
//        }
//        */
//    }
    
    
    //MARK: Subscriptions Notifications
    //MARK: Call History Notifications
    
    func updateCallLog(withData data: Data){
        
        do {
            let coreDataManager = CoreDataManager(modelName: "ContactsCD")
            let payload = try decoder.decode(TypeResponse.self, from: data)
           
            if payload.type == TYPE_CREATED{
                
//                let logData = (try? JSONSerialization.data(withJSONObject: payload.payload, options: [])) ?? Data()
//
//                let logPayload = try decoder.decode(CallHistory.self, from: logData)
                
                let msg = ContactsCD(context: coreDataManager.mainManagedObjectContext)
//                msg.id = Int64(logPayload.callTypeEventID)
//                msg.firstName = logPayload.callee.number
//                msg.lastName = logPayload.caller.number
                msg.id = 66
                msg.firstName = "name"
                msg.lastName = "surname"
                coreDataManager.saveChanges()
                
                
                
//                let log = CallLogsCD(context: coreDataManager.mainManagedObjectContext)
//
//
//
//                coreDataManager.saveChanges()
                
//                CoreDataManagerOld.shared.saveContact(payloadData: data)
            }
//            if payload.type == TYPE_UPDATED{
//                CoreDataManagerOld.shared.updateContact(payloadData: data)
//            }
//            if payload.type == TYPE_DELETED{
//                CoreDataManager.shared.deleteContact(payloadData: data)
//            }
//
            
            
        }catch {
            print(error)
        }
        
        
        //contact update
        /*
        let decoder = JSONDecoder()

        do {

            let data = try JSONSerialization.data(withJSONObject: notificationPayload, options: [])
            let myString = String(data: data, encoding: .utf8)!
            let myData = Data(myString.utf8)
            let payload = try decoder.decode(Payload.self, from: myData)
            
            print("Your decoded FCM payload: \(payload)")  // Up until this stage, I decode the JSON normally
            
            
            /*
                 Since the payload object is read as String, I cast it to Data in utf8
                 then I decode it as an Array of Objects and it works
             */
            
            let payloadData = Data(payload.payload.utf8)
            let payloadArr = try decoder.decode([INTS].self, from: payloadData)

            print("payloadArr: \(payloadArr)")
            
            ContentViewModel.shared.firstName = "Ashley"
            ContentViewModel.shared.saveContact()
            
        } catch {
            print(error)
        }
        */
    }
    //MARK: Orders and Invoices Notifications
    //MARK: Billing Notifications
    //MARK: Number verification status due to KYC Notifications
}

/*
 switch payload.type{
 case "CREATED":
     switch payload.topic{
     case "CONTACTS":
         createContact()
     case "SUBSCRIPTION":
         createSubscription()
     case "CALL_LOGS":
         createCallLog()
     case "ORDERS_INVOICES":
         createInvoice()
     case "BILLING":
         createBilling()
     case "NUMBER_VERIFICATION":
         createNumberVerification()
     case "PROFILE":
         createProfile()
     case "INVOICE_USER_MINUTES":
         createInvoiceUserMinutes()
     case "INVOICE_DID_NUMBER":
         createInvoiceDIDNumber()
     case "USER_MINUTES":
         createUserMinutes()
     case "CREDIT":
         createCredit()
     case default:
         print("No applicable topic was found")
     }
 case "UPDATED":
     switch payload.topic{
     case "CONTACTS":
         updateContact()
     case "SUBSCRIPTION":
         updateSubscription()
     case "CALL_LOGS":
         updateCallLog()
     case "ORDERS_INVOICES":
         updateInvoice()
     case "BILLING":
         updateBilling()
     case "NUMBER_VERIFICATION":
         updateNumberVerification()
     case "PROFILE":
         updateProfile()
     case "INVOICE_USER_MINUTES":
         updateInvoiceUserMinutes()
     case "INVOICE_DID_NUMBER":
         updateInvoiceDIDNumber()
     case "USER_MINUTES":
         updateUserMinutes()
     case "CREDIT":
         updateCredit()
     case default:
         print("No applicable topic was found")
     }
 case "DELETED":
     switch payload.topic{
     case "CONTACTS":
         deleteContact()
     case "SUBSCRIPTION":
         deleteSubscription()
     case "CALL_LOGS":
         deleteCallLog()
     case "ORDERS_INVOICES":
         deleteInvoice()
     case "BILLING":
         deleteBilling()
     case "NUMBER_VERIFICATION":
         deleteNumberVerification()
     case "PROFILE":
         deleteProfile()
     case "INVOICE_USER_MINUTES":
         deleteInvoiceUserMinutes()
     case "INVOICE_DID_NUMBER":
         deleteInvoiceDIDNumber()
     case "USER_MINUTES":
         deleteUserMinutes()
     case "CREDIT":
         deleteCredit()
     case default:
         print("No applicable topic was found")
     }
 case default:
     print("No applicable type was found")
 }
 */

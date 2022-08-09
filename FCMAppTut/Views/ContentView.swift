//
//  ContentView.swift
//  FCMAppTut
//
//  Created by Ashley Dube on 2022/07/15.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var vm = ContentViewModel.shared
    @State var firstName: String = ""
    let savedValue = UserDefaults.standard.object(forKey: "CDBackgroundUDUpdate") as? String ?? "No value for now"
    let pub = NotificationCenter.default
        .publisher(for: Notification.Name.didReceiveNotification)
    
    var body: some View {
        NavigationView{
            
            VStack{
//                Text("CDBackgroundUDUpdate = " + savedValue)
                /*
                TextField("Enter Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                
                
                Button {
                    Database.shared.performBackgroundTask { (context) in
                    // work with context as you normally would with the main one
                    // when changing properties of Core Data objects dont forget to call context.save()
                        let msg = ContactsCD(context: context)
                        msg.id = 790
                        msg.firstName = "Brock"
                        msg.lastName = "Lesnar"
                        try? context.save()
                    }
                } label: {
                    Text("SAVE")
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color(.blue))
                .foregroundColor(.white)
                */
                Spacer()
                
                List{
                    ForEach(vm.allContacts){ contact in
                        HStack{
                            
                            Text("\(contact.firstName ?? "") \(contact.lastName ?? "")")
                             
//                            if !contact.mobileNumbers!.numberList.isEmpty{
//                                Text("\(contact.firstName ?? "") \(contact.mobileNumbers!.numberList[0].number) \(contact.emails!.emailList[0].email)")
//                            }
                            
                        }
                        
                    }//.onDelete(perform: vm.deleteContact)
                }
                
            }
            .onReceive(pub) { (output) in
                vm.fetchMessages()
            }
            .padding()
            .navigationTitle("All Contacts")
        }
       
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

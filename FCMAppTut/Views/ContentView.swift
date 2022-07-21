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
    
    
    var body: some View {
        NavigationView{
            
            VStack{
                TextField("Enter Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                
                
                Button {
                    CoreDataManager.shared.testAdd()
                } label: {
                    Text("SAVE")
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color(.blue))
                .foregroundColor(.white)
                
                Spacer()
                
                List{
                    ForEach(vm.allContacts){ contact in
                        HStack{
                             
                            if !contact.mobileNumbers!.numberList.isEmpty{
                                Text("\(contact.firstName ?? "") \(contact.mobileNumbers!.numberList[0].number) \(contact.emails!.emailList[0].email)")
                            }
                            
                        }
                        
                    }.onDelete(perform: vm.deleteContact)
                }
                
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

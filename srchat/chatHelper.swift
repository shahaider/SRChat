//
//  chatHelper.swift
//  srchat
//
//  Created by Syed Shahrukh Haider on 14/07/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import Foundation
import UIKit

import Firebase
import FirebaseDatabase
import FirebaseAuth


class chatHelper {


    static let chathelp = chatHelper()
    var userIdentity : String?
    var userDisplayName : String?
    var useroneMsg : String?

    
    var FBref : DatabaseReference?
    var FBhandler : DatabaseHandle?
    
    
    
    func placeMessage(){
    
       
    
        self.FBref = Database.database().reference()
        
        let MessageReference = self.FBref?.ref.child("Messages")   //.child(userIdentity!)

        MessageReference?.childByAutoId().child("message").setValue("email Msg")
        
        
        print("***** MESSAGE STORE AT DB ***********")
        
    
        
    }
    
    
    func receiveMessage() {
    
       let MessageRecievedRef = self.FBref?.child("Messages")
        MessageRecievedRef?.observe(.value, with: { (snapshoot) in
            print(snapshoot)
            if let value = snapshoot.value {
            
                print(value)
            }
        })
    
    }
    
}

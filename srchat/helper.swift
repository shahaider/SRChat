//
//  helper.swift
//  srchat
//
//  Created by Syed Shahrukh Haider on 12/07/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase




class helper{

    static let Help = helper()
    
    // variable for Firebase
    
    var ref : DatabaseReference?
    
    
    // ChatStruct variable
    
    var enterValue = chatRoom.userInfo
    
    // EMAIL REGISTER FUNCTION
    
    func emailReg(){
        
        Auth.auth().createUser(withEmail:enterValue.emailValue , password: enterValue.passwordValue) { (user, error) in
            if user != nil{
                guard let uID = user?.uid else{
                    return
                }
                // Creating Database
                self.ref = Database.database().reference()
                let userReference = self.ref?.child("users").child(uID)
                let value = ["Name": self.enterValue.nameValue, "Email": self.enterValue.emailValue]
                print(value)
                userReference?.updateChildValues(value, withCompletionBlock: { (err, ref) in
                    if err != nil{
                        print (err)
                        return
                    }
                    print("Successful SAVED")
                })
                
            }
            
        }
    
    }
    
    // LOGIN FUNCTION

    func login(){
        Auth.auth().signIn(withEmail: enterValue.emailValue, password: enterValue.passwordValue, completion: { (user, error) in
            if user != nil{
                print("Sign IN Success")
                
            }
            
        })
    }
    
    func loginInGoogle(){
    
    
    }
        
}



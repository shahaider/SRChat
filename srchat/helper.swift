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
import GoogleSignIn




class helper{

    static let Help = helper()
    
    var errorMsg : String?
    var status : Bool?
    
    // variable for Firebase
    
    var ref : DatabaseReference?
    
    
    // ChatStruct variable
    
    var enterValue = chatRoom.userInfo
    
    // EMAIL REGISTER FUNCTION
    
    func emailReg(){
        
        print (enterValue)
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
                        print ((error?.localizedDescription)! as String)
                        return
                    }
                    print("Successful SAVED")
                })
                
            }
            
        }
    
    }
    
    // LOGIN FUNCTION

    func login(){
        
        print(self.enterValue.passwordValue)
        print(self.enterValue.emailValue)

//        Auth.auth().signIn(withEmail: enterValue.emailValue, password: enterValue.passwordValue, completion: { (loginUser, error) in
//            
//            print(loginUser?.email)
//            
//            if error != nil{
//                print("********* \(error?.localizedDescription) *******" )
//                self.errorMsg = "user or password incorrect"
//                self.status = false
//            }
//
//            else{
//                print("************ Sign IN Success ***************")
//                print(loginUser?.uid)
//                self.errorMsg = ""
//                self.status = true
//            }
//            
//        })
        
    }
    
    
    // GOOGLE LOGIN CODING
    
    func loginInGoogle(userAuth:GIDAuthentication){
    
     let credential = GoogleAuthProvider.credential(withIDToken: userAuth.idToken, accessToken: userAuth.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if user != nil{
                guard let uID = user?.uid else{
                    return
                }
            
            if error != nil{
            print((error?.localizedDescription)! as String)
                return
            }
            else{
                
                // saving userID
                chatHelper.chathelp.userIdentity = user?.uid

                var name = ""
                var email = ""
            
                guard let nameValue = user?.displayName, let emailValue = user?.email else{
                print("nil value")
                    return
                }
                name = nameValue
                email = emailValue
                print(name)
                print(email)
                
                // Creating Database
                self.ref = Database.database().reference()
                let userReference = self.ref?.child("users").child(uID)
                let value = ["Name": name, "Email": email]
                print(value)
                userReference?.updateChildValues(value, withCompletionBlock: { (err, ref) in
                    if err != nil{
                        print (err?.localizedDescription)
                        return
                    }
                    print("Successful SAVED")
                })

            }
        }
           
    }
}

}

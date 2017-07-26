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
    var status : Bool? = false
    
    // variable for Firebase
    
    var ref : DatabaseReference?
    var handle: DatabaseHandle?
    
    
    // ChatStruct variable
    
    var enterValue = chatRoom.userInfo
    
    // EMAIL REGISTER FUNCTION
    
    func emailReg(){
        
        print (enterValue)
        Auth.auth().createUser(withEmail:(enterValue?.emailValue)! , password: (enterValue?.passwordValue)!) { (user, error) in
            if user != nil{
                guard let uID = user?.uid else{
                    return 
                }
                // storage DISPLAY IMAGE
                
                let storageRef = Storage.storage().reference()
                let filepath = ("DP/\((self.enterValue?.nameValue)!)")
                print(filepath)
                var fileUrl : String?
                
                
                if let picture  = self.enterValue?.profileImage{
                
                let picData = UIImageJPEGRepresentation(picture, 0.1)
                let metaData = StorageMetadata()
                    metaData.contentType = "image/jpg"
                    
                    storageRef.child(filepath).putData(picData!, metadata: metaData, completion: { (finalMD, err) in
                        if err != nil{
                            print(err?.localizedDescription)
                            return
                        }
                    fileUrl = (finalMD?.downloadURLs![0].absoluteString)!
                    print(fileUrl!)
                        
                        // Creating Database
                        self.ref = Database.database().reference()
                        let userReference = self.ref?.child("users").child((self.enterValue?.nameValue)!)
                        let value = ["Name": self.enterValue?.nameValue, "Email": self.enterValue?.emailValue,"ProfileDP": fileUrl,"uID": uID]
                        print(value)
                        userReference?.updateChildValues(value, withCompletionBlock: { (err, ref) in
                            if err != nil{
                                print ((error?.localizedDescription)! as String)
                                return
                            }
                            
                            print("Successful SAVED")
                        })

                    })
                    
                }

                

                
            }
            
        }
    
    }
    

   
    
    
    // GOOGLE LOGIN CODING
    
    func loginInGoogle(userAuth:GIDAuthentication) -> Bool{
    
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
                let pictureURL = Auth.auth().currentUser?.photoURL?.absoluteString
              
                print(name)
                print(email)
                print(pictureURL)
                
                // Creating Database
                self.ref = Database.database().reference()
                let userReference = self.ref?.child("users").child(name)
                let value = ["Name": name, "Email": email, "ProfileDP": pictureURL,"uID": uID]
                print(value)
                userReference?.updateChildValues(value, withCompletionBlock: { (err, ref) in
                    if err != nil{
                        print (err?.localizedDescription)
                        return self.status = false
                    }
                    print("Successful SAVED")
                    return self.status = true
                })

            }
        }
           
    }
        return status!
}
    
    

}

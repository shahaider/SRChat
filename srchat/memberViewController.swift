//
//  memberViewController.swift
//  srchat
//
//  Created by Syed Shahrukh Haider on 24/07/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class memberViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var memberList: UITableView!
    var dbRef : DatabaseReference?
    var dbHandle: DatabaseHandle?
    
    var channelNameGenerator: String?
    
   
    var userTable = [chatRoom]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memberList.dataSource = self
        memberList.delegate = self
        
        // ************* FIREBASE DATABASE ******************
        
        dbRef = Database.database().reference()
        dbHandle = dbRef?.child("users").observe(.childAdded, with: { (userSnap) in
            
            
            if let value = userSnap.value as? [String:Any]{
            
                print(value)
                let name = value["Name"] as! String
                let id = value["uID"] as! String
                
                let link = value["ProfileDP"] as! String
                let piclink = URL(string: link)
                let picData = NSData(contentsOf: piclink!)
                let DP = UIImage(data: picData as! Data)
                
                if id != (Auth.auth().currentUser?.uid)!{
                let resultData = chatRoom(nameValue: name, emailValue: "", passwordValue: "", confirmpasswordValue: "", profileImage: DP!,uID: id as! String)
                self.userTable.append(resultData)
                self.memberList.reloadData()
                }
            }
//

        })
        
    
    }


    
    //                      ************** CONFIGURE TABLEVIEW **************

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell") as! memberTableViewCell
        
        cell.memberName.text = userTable[indexPath.row].nameValue
        cell.userPic.image = userTable[indexPath.row].profileImage
        
        
        return cell
    }
   
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       // Segue with CHAT ViewController
        let selectedUser = userTable[indexPath.row].uID
        let signupUser = (Auth.auth().currentUser?.uid)!
        
        let uidArray = [signupUser, selectedUser]
        
        let sortedResult = uidArray.sorted()
        
        let reduceResult = sortedResult.reduce("",{$0+$1})
        print("Channel Name:" + reduceResult)
        self.channelNameGenerator = reduceResult
        
        
        
        performSegue(withIdentifier: "chatRoomSegue", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dest = segue.destination as! chatViewController
        
        dest.channelName = self.channelNameGenerator
        
        
    }
    
    
    //                  ************** LOGOUT BUTTON *******************
    @IBAction func logoutButton(_ sender: Any) {
        
        
        
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
            
        }catch{print("")}
        print (Auth.auth().currentUser)
    }

}

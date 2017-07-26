//
//  chatViewController.swift
//  srchat
//
//  Created by Syed Shahrukh Haider on 12/07/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit

// Library that handle MEDIA TYPE
import MobileCoreServices
//Library that handle AV stuff
import AVKit
// Library that handle JSQ-VC
import JSQMessagesViewController

// FIREBASE LIBRARY
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class chatViewController: JSQMessagesViewController {

    
    // VARIABLE THAT HOLD MESSAGE IN ARRAY FORMAT
    var messages = [JSQMessage]()
    
    // FIREBASE VARIABLE
    
    var FBref : DatabaseReference?
    var FBHandle : DatabaseHandle?
    
    var msgRef = Database.database().reference().child("Messages")
    var userRef = Database.database().reference().child("users")
    
    let currentUserId = Auth.auth().currentUser?.uid

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

// INITIALIZE VARIABLE REQUIRED BY THIS VC
        
        senderId = currentUserId!
        senderDisplayName = ""
        
        
        // Retrieve User detatil
        
        print(senderId)
     FBHandle = userRef.observe(.childAdded, with: { (userSnap) in
      
        print(userSnap.key)
        let id = userSnap.key
        
        
        
        if self.senderId == id {
            
        if let detail = userSnap.value as? [String:Any]{
        
            
            let DName = detail["Name"] as! String
            self.senderDisplayName = DName
        }
            print(self.senderDisplayName)

        print("**********")
        }
     })

//        senderDisplayName = "ShahRukh"

        
        // RETRIEVE MESSAGE FROM DB
         obserMessage()
        
        
    }

    // LOGOUT FUCNTION
    
    
    @IBAction func logoutButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        do {
           try Auth.auth().signOut()

        }catch{print("")}
        print (Auth.auth().currentUser)

    }
    
    
  
    // FUNCTION USE TO RETREIVE  INCOMING MESSAGE FROM FIREBASE SERVER
    
    func obserMessage(){
        
       FBHandle = msgRef.observe(.childAdded, with: { (snapshot) in
        
        if let value = snapshot.value as? [String : Any]{

            let text = value["text"] as? String
            let senderid = value["senderID"] as? String
            let senderName = value["senderDisplay"] as? String
            let mediatype = value["mediaType"] as! String
            
            switch mediatype{
            
                case "TEXT":
                    self.messages.append(JSQMessage.init(senderId: senderid, displayName: senderName, text: text))

                case "PHOTO":
                    let fileUrl = value["fileURL"] as! String
                    let url = URL(string: fileUrl)
                    let data = NSData(contentsOf: url!)
                    let picture = UIImage(data: data as! Data)
                    let photo = JSQPhotoMediaItem(image: picture)
                    self.messages.append(JSQMessage(senderId: senderid, displayName: senderName, media: photo))
                 
                    // identify incoming OR outgoing photo
                    if self.senderId == senderid {
                        photo?.appliesMediaViewMaskAsOutgoing = true

                    }
                    else{
                photo?.appliesMediaViewMaskAsOutgoing = false
                }
                
                

                case "VIDEO":
                    let fileUrl = value["fileURL"] as! String
                    let url = URL(string: fileUrl)
                    let fetchvdo = JSQVideoMediaItem(fileURL: url, isReadyToPlay: true)
                    self.messages.append(JSQMessage(senderId: senderid, displayName: senderName, media: fetchvdo))
                
                    // identify incoming OR outgoing Video
                    if self.senderId == senderid {
                        fetchvdo?.appliesMediaViewMaskAsOutgoing = true
                        
                    }
                    else{
                        fetchvdo?.appliesMediaViewMaskAsOutgoing = false
                }
                
            
            default:
                print("UNKNOWN")
            }
            

            self.collectionView.reloadData()

        }
       })
    
    }
    
    
                    /*
     
                        ------------- FUNCTIONS WHICH PLAYS VITAL ROLE IN RUNNING CHAT VIEW -------------
     
                    */
    
   
    
    
    // NUMBER OF COLLECTIONVIEW (LIKE TABLEVIEW )
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    // CELL FOR ITEM  INDEXPATH (LIKE TABLEVIEW)
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
                // CREATE CELL VARIABLE AND LINKING PROTOTYPE VIEWCELL
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
//        print("number of cell :\(messages.count)" )
        return cell
    }
    
    
                        // ************************* UI *************************
    
    
    //  CREATING "messageData" ITEM
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    
    // CREATING messageBubble Image (CUSTOMIZABLE)
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()

        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
        
        return bubbleFactory?.outgoingMessagesBubbleImage(with:.blue)
        }
        else{
        return bubbleFactory?.incomingMessagesBubbleImage(with: .green)
        }
    }
    
    
    // CREATING Avatar Method
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "person"), diameter: 30)
    }



    
    
     // ---------------------------------------------------------------------------------------
    
    
            /*
     
                    --------------------- ACTION ON PRESS "SEND" BUTTON ---------------------
     
            */
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        
        // SAVE MESSAGE ON FIREBASE
        let newMessage = msgRef.childByAutoId()
        let messageData = ["text": text, "senderID": senderId, "senderDisplay": senderDisplayName, "mediaType": "TEXT"]
        newMessage.setValue(messageData)
        
       collectionView.reloadData()
        
        finishSendingMessage()
        
    

    }
    
    
    /*
     
                    --------------------- ACTION ON PRESS "ACCESSORY" BUTTON ---------------------
     
     */

    override func didPressAccessoryButton(_ sender: UIButton!) {

        print("pressed Accessory button")
        
        let sheet = UIAlertController(title: "Media Selection", message: "Please select desire source ", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (AlertAction) in
        }
       
        // SELECTING IMAGE
        let photo = UIAlertAction(title: "PHOTO", style: .default) { (AlertAction) in
            
        
        // FUNCTION TO HANDLE MEDIA TYPE
            self.getMediaFrom(type:kUTTypeImage)
        }
        
        // SELECTING VIDEO
        let video = UIAlertAction(title: "VIDEO", style: .default) { (AlertAction) in
            
            // FUNCTION TO HANDLE MEDIA TYPE
            self.getMediaFrom(type: kUTTypeMovie)

        }
        
        // ASSOSCIATE ACTION TO THE ALERT-VC
        sheet.addAction(photo)
        sheet.addAction(video)
        sheet.addAction(cancel)
        
        present(sheet, animated: true, completion: nil)


    }
   
    // FUNCTION WHICH WILL DECIDE WHETHER TO POP-UP IMAGE OR VIDEO "ALBUM"
    func getMediaFrom(type: CFString){
        
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        

        mediaPicker.mediaTypes = [type as String]
    
        present(mediaPicker, animated: true, completion: nil)
    }
    
  
        /*
                    --------------------- TAP MESSAGE MEDIA to PLAY VIDEO ----------------------------
     
        */
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        print("TAPPED!!!! \(indexPath.item)")
        
        let message = messages[indexPath.item]
        if message.isMediaMessage{
            if let mediaItem = message.media as? JSQVideoMediaItem {
        let playerFile = AVPlayer(url:  mediaItem.fileURL)
        let playVC = AVPlayerViewController()
                playVC.player = playerFile
                self.present(playVC, animated: true, completion: nil)
            }
        }
    }
    
    
    // SENDING TO FIREBASE STORAGE
    
    
    func sendMedia(picture: UIImage?, video:URL?){
        
        
        // FIREBASE STORAGE VARIABLE INITIALIZE
        let storageRef = Storage.storage().reference()
        let filepath = ("\(Auth.auth().currentUser!)/\(Date.timeIntervalSinceReferenceDate)")
        
        
        // STORING PICTURE
        if let picture = picture{
        
            let picData = UIImageJPEGRepresentation(picture, 0.1)
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            storageRef.child(filepath).putData(picData!, metadata: metaData) { (finalMD, err) in
                if err != nil{
                    print(err?.localizedDescription )
                    return
                }
                let fileUrl = finalMD?.downloadURLs![0].absoluteString
                
                let newMessage = self.msgRef.childByAutoId()
                var messageData = ["fileURL": fileUrl, "senderID": self.senderId, "senderDisplay": self.senderDisplayName, "mediaType": "PHOTO"]
                newMessage.setValue(messageData)
                
            }

        }
        
            
            // STORING VIDEO
        else if let video = video {
        
            let vdoData = NSData(contentsOf: video)
            let metaData = StorageMetadata()
            metaData.contentType = "video/mp4"
            
            storageRef.child(filepath).putData(vdoData! as Data, metadata: metaData) { (finalMD, err) in
                if err != nil{
                    print(err)
                    return
                }
                let fileUrl = finalMD?.downloadURLs![0].absoluteString
                
                let newMessage = self.msgRef.childByAutoId()
                let messageData = ["fileURL": fileUrl, "senderID": self.senderId, "senderDisplay": self.senderDisplayName, "mediaType": "VIDEO"]
                newMessage.setValue(messageData)
                
            }
      
        }
    
    }
}

// EXTENSION:   MULTIMEDIA Message (IMAGEPICKER-VC-DELEGATE)
extension chatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        
        // MESSAGE-CASE: MEDIA = PHOTO

        if let  picture = info[UIImagePickerControllerOriginalImage] as? UIImage {

// DUMPY SENDER PHOTO (PRACTICE)
            //        let photo = JSQPhotoMediaItem(image: picture)
            //        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo))
            sendMedia(picture:picture, video:nil)
        }
        
        // MESSAGE-CASE: MEDIA = VIDEO

        if let video = info[UIImagePickerControllerMediaURL] as? URL{
        
// DUMPY SENDER VIDEO (PRACTICE)
//            let vdo = JSQVideoMediaItem(fileURL: video, isReadyToPlay: true)
//            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: vdo))

            sendMedia(picture:nil, video:video)

        }
        
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
        
    }
}

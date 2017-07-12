//
//  ChatRoomViewController.swift
//  ChatApp_Firebase
//
//  Created by Abhijit on 7/11/17.
//  Copyright © 2017 Abhijit. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatRoomViewController: JSQMessagesViewController {
    
    var groupName : String = "Blah"
    var groupId : String = "123"
    
    var username : String = "Not Set yet"
    var userID : String = "Not Set yet"
    
    var messages = [JSQMessage]()
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    @IBOutlet weak var grouptitle: UINavigationItem!
    
    private var ref: DatabaseReference!
    private var messageRef: DatabaseReference!
    private var refHandle: DatabaseHandle?
    
    var formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(username)
        print(userID)
        
        print(groupName)
        grouptitle.title = groupName
        self.senderId = username
        
        ref = Database.database().reference().child("Groups").child(groupId)
        messageRef = Database.database().reference().child("Groups").child(groupId).child("Messages")
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier:"GMT")
        
        
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        //Making the avatar size zero
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        /*addMessage(withId: "foo", name: "Mr.Bolt", text: "I am so fast!")
        // messages sent from local sender
        addMessage(withId: senderId, name: "Me", text: "I bet I can run faster than you!")
        addMessage(withId: senderId, name: "Me", text: "I like to run!")
        // animates the receiving of a new message on the view
        finishReceivingMessage()
        */
        
        observeMessages()

    }
    
    //This function is always executed after viewDidLoad()
    override func viewWillAppear(_ animated: Bool) {
        
        //self.senderId = Auth.auth().currentUser?.uid
        //OR
        self.senderId = username
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        let currentDT = Date()
        let dStr = formatter.string(from: currentDT)
        
        var userRef : DatabaseReference!
        //userRef = Database.database().reference().child("Users")......................................
    }
    
    //Adding a JSQMessage type into Messages array
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
        
        
    }
    
    //Function when send is pressed
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let itemRef = messageRef.childByAutoId()
        let messageItem = [
            "senderId": senderId!,
            "senderName": username,
            "text": text!,
            ]
        
        let currentDT = Date()
        let dStr = formatter.string(from: currentDT)
        
        itemRef.setValue(messageItem)
        
        ref.child("LastMessageAdded").setValue(dStr)
        
        
        finishSendingMessage()
        
    }
    
    //Observing for messages in the Group and adding them to messages array
    private func observeMessages() {
        
        refHandle = messageRef.observe(.childAdded, with: { (snapshot) -> Void in

            //print(snapshot.value)
            if let messageData = snapshot.value as? Dictionary<String, String>{
            print(messageData)
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {

                self.addMessage(withId: id, name: name, text: text)
                
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
            }
        })
    }
    
    //Datasource for the View
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    //number of items necessary = number of messages
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    //Setup outgoing Bubble
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    //Setup incoming bubble
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    //Setting the outgoing and incoming bubble based on SenderID
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else { 
            return incomingBubbleImageView
        }
    }
    
    //Removing the avatar for each bubble
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    //Modifications to the bubble content
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    //Function to write displayName above the message
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        switch message.senderId {
        case senderId:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
            
        }
    }
    
    //How high should the displayName be above the message bubble
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        
        let message = messages[indexPath.item]
        switch message.senderId {
        case senderId:
            return 3
        default:
            return 15
        }
        //return 15
    }
    
    
   
}

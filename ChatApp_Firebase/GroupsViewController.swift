//
//  GroupsViewController.swift
//  ChatApp_Firebase
//
//  Created by Abhijit on 7/11/17.
//  Copyright © 2017 Abhijit. All rights reserved.
//

import UIKit
import Firebase

class GroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var GroupsTable: UITableView!
    
    var username : String = "Anonymous"
    private var groups: [Group] = []
    var selectedCell = ["ID": "", "Name": ""]
    
    private var ref: DatabaseReference!
    private var refHandle: DatabaseHandle?
    
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref = Database.database().reference().child("Groups")
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier:"GMT")
        
        observeGroups()
    }
    
    func observeGroups(){
        
        refHandle = ref.observe(.childAdded, with: { (snapshot) -> Void in
            
            if let groupData = snapshot.value as? Dictionary<String, AnyObject>{
            let groupId = snapshot.key
            let lma = groupData["LastMessageAdded"] as! String
            
            let lmaDate = self.formatter.date(from: lma)
            
            
            let group = Group(id: groupId, name: groupData["Name"] as! String, lma: lmaDate!)
            self.groups.append(group)
            
            self.GroupsTable.reloadData()
            //print(channelData)
            //print(id)
            }
            
        })
    }
    
    /*deinit {
        if let rHandle = refHandle {
            refHandle.
        }
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 
        
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = GroupsTable.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell
        cell.groupName.text = groups[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCell["Name"] = groups[indexPath.row].name
        selectedCell["ID"] = groups[indexPath.row].id
        performSegue(withIdentifier: "groupSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "groupSegue"{
            if let destination = segue.destination as? ChatRoomViewController{
                
                destination.username = username
                destination.groupName = selectedCell["Name"]!
                destination.groupId = selectedCell["ID"]!
                
            }
            
        }
    }
    
    

    @IBAction func newGroupButton(_ sender: Any) {
        
        if groupName.text != ""{
            
            let currentDT = Date()
            let dStr = formatter.string(from: currentDT)
            
            let newRef = ref.childByAutoId()
            let newGroup = [
                "Name" : groupName.text!,
                "CreatedBy" : username,
                "LastMessageAdded" : dStr
            ] as [String : Any]
            
            newRef.setValue(newGroup)
            
            GroupsTable.reloadData()
            groupName.text = ""
            
        }
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

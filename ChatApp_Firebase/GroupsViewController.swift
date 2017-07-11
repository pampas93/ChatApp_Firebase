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
    var selectedCell : String = ""
    
    private var ref: DatabaseReference!
    private var refHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref = Database.database().reference().child("Groups")
        observeGroups()
    }
    
    func observeGroups(){
        
        refHandle = ref.observe(.childAdded, with: { (snapshot) -> Void in // 1
            let groupData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            
            let group = Group(name: groupData["Name"] as! String)
            self.groups.append(group)
            
            self.GroupsTable.reloadData()
            //print(channelData)
            //print(id)
            
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // 2
        
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = GroupsTable.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell
        cell.groupName.text = groups[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCell = groups[indexPath.row].name
        performSegue(withIdentifier: "groupSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "groupSegue"{
            if let destination = segue.destination as? ChatRoomViewController{
                
                destination.username = username
                destination.groupName = selectedCell
            }
            
        }
    }
    
    

    @IBAction func newGroupButton(_ sender: Any) {
        
        if groupName.text != ""{
            
            let newRef = ref.childByAutoId()
            let newGroup = [
                "Name" : groupName.text!,
                "CreatedBy" : username
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

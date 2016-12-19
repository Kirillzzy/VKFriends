//
//  ChatViewController.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 13/12/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    
    var name: String!
    var userId: String!
    var messagesFromUser = [MessageClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        messagesFromUser = ApiWorker.messagesGetByUser(userId: userId)
        chatTableView.estimatedRowHeight = 50
        chatTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollDownTableView()
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        let message = messageTextField.text!
        if message != ""{
            ApiWorker.sendMessageToUser(userId: userId, message: message)
        }
        messagesFromUser = ApiWorker.messagesGetByUser(userId: userId)
        clearMessageTextField()
        chatTableView.reloadData()
        scrollDownTableView()
    }
    
    func scrollDownTableView(){
        if(self.messagesFromUser.count > 0){
            chatTableView.scrollToRow(at: IndexPath(row: self.messagesFromUser.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    func clearMessageTextField(){
        messageTextField.text = ""
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesFromUser.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = messagesFromUser[indexPath.row].text
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatTableView.deselectRow(at: indexPath, animated: true)
    }
    

}

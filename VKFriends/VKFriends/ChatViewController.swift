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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatTableView.deselectRow(at: indexPath, animated: true)
    }
    

}

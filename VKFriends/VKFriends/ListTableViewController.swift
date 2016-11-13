//
//  ListTableViewController.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 09/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit
import SDWebImage

class ListTableViewController: UITableViewController {
    @IBOutlet var friendsTableView: UITableView!
    
    let refreshCtrl = UIRefreshControl()
    
    private let vk: SwiftyVKDelegate = SwiftyVKDelegate()
    var friends = [VKFriendClass]()
    let vkManager = ApiWorker.sharedInstance


    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            friendsTableView.refreshControl = refreshCtrl
        } else {
            friendsTableView.addSubview(refreshCtrl)
        }
        refreshCtrl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshCtrl.addTarget(self, action: #selector(refreshTableView(sender:)), for: .valueChanged)
        if vkManager.state == .authorized {
            reloadTableView()
        }

    }

    func refreshTableView(sender: AnyObject){
        reloadTableView()
        refreshCtrl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadTableView()
    }
    
    private func reloadTableView(){
        self.friends = vkManager.friends
        self.friendsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.reloadUI()
    }
    
    private func reloadUI(){
        self.friendsTableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = indexPath.row
        /*if let cell = cell as? FriendTableViewCell{
            cell.configure(for: friends[row])
        }*/
        let friend = friends[row]
        let name = friend.getName()
        if friend.getCity() == "" {
            cell.textLabel?.text = name
        }
        else{
            cell.textLabel?.text = name + ": " + friend.getCity()
        }
        cell.imageView?.image = friend.profileImage.image
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        friendsTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "fromListSegue", sender: indexPath)
    }
    


}

// MARK: - Prepare for segue
extension ListTableViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "fromListSegue"{
            if let vc = segue.destination as? PersonInformationViewController{
                if let index = sender as? IndexPath{
                    let row = index.row
                    let friend = friends[row]
                    vc.title = friend.getName()
                    vc.city = friend.getCity()
                    vc.name = friend.getName()
                    vc.id = friend.getId()
                    vc.ProfileImage = friendsTableView.cellForRow(at: index)?.imageView?.image
                }
            }
        }
    }
}

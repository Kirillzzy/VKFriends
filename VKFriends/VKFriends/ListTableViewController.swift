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
    
    var friends = [VKFriendClass]()


    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            friendsTableView.refreshControl = refreshCtrl
        } else {
            friendsTableView.addSubview(refreshCtrl)
        }
        refreshCtrl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshCtrl.addTarget(self, action: #selector(refreshTableView(sender:)), for: .valueChanged)
        friendsTableView.rowHeight = CGFloat(60)
//        if ApiWorker.state == .authorized {
//            reloadTableView()
//        }
        reloadTableView()

    }

    func refreshTableView(sender: AnyObject){
        reloadTableView()
        refreshCtrl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.reloadTableView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.friends.count == 0{
            reloadTableView()
        }
    }
    
    private func reloadTableView(){
        ApiWorker.friendsGet(callback: { friends in
            if let lastFriends = friends{
                self.friends = lastFriends
                self.friendsTableView.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendCell")
                self.reloadUI()
            }
        })
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> FriendTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableViewCell
        cell.profileImageView.sd_setImage(with: URL(string: friends[indexPath.row].getLinkPhoto()))
        cell.nameCityLabel.text = friends[indexPath.row].getName()
        cell.cityLabel.text = friends[indexPath.row].getCity()
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        friendsTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "fromListSegue", sender: friends[indexPath.row])
    }
    


}

// MARK: - Prepare for segue
extension ListTableViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "fromListSegue"{
            if let friend = sender as? VKFriendClass{
                let vc = segue.destination as! PersonInformationViewController
                vc.title = friend.getName()
                vc.city = friend.getCity()
                vc.name = friend.getName()
                vc.id = friend.getId()
                vc.linkProfileImage = friend.linkProfileImage
                vc.online = friend.getOnline()
                vc.lastSeen = friend.getLastSeen()
            }
        }
    }
}

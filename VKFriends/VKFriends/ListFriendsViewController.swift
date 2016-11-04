//
//  ListFriendsViewController.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 03/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit

class ListFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendsTable: UITableView!

    let vk: SwiftyVKDelegate = SwiftyVKDelegate()
    var namesAndCities = [String: String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiWorker.authorize()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            if(String(describing: ApiWorker.state()) == "authorized"){
                ApiWorker.friendsGet()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.namesAndCities = ApiWorker.namesAndCities
                    self.friendsTable.delegate = self
                    self.friendsTable.dataSource = self
                    self.friendsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                })
            }
            
        })
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.namesAndCities.count;
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = indexPath.row
        if(Array(namesAndCities.values)[row] == ""){
            cell.textLabel?.text = Array(namesAndCities.keys)[row]
        }
        else{
            cell.textLabel?.text = Array(namesAndCities.keys)[row] + ": " + Array(namesAndCities.values)[row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        friendsTable.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "fromListSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "fromListSegue"{
            if let vc = segue.destination as? PersonInformationViewController{
                if let index = sender as? Int{
                    //goto controller and give information
                }
            }
        }
    }

}


//questions:
//blue screen view controller
//shemes on slider

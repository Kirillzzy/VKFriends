//
//  ChatViewController.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 13/12/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit
import SDWebImage

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

  @IBOutlet weak var messageTextField: UITextView!
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var chatTableView: UITableView!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var activityView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  var name: String!
  var userId: String!
  var messagesFromUser = [MessageClass]()
  var linkProfileImage: String!
  var numOfLines: Int = 2
  var firstConstraintBottom: CGFloat = 0.0

  override func viewDidLoad() {
    super.viewDidLoad()
    //messagesFromUser = ApiWorker.messagesGetByUser(userId: userId)
    chatTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
    chatTableView.estimatedRowHeight = 80
    chatTableView.rowHeight = UITableViewAutomaticDimension
    messageTextField.delegate = self
    notificationCenterInit()
    messageTextField.layer.masksToBounds = true
    messageTextField.layer.cornerRadius = 5
    firstConstraintBottom = bottomConstraint.constant
  }

  override func viewWillAppear(_ animated: Bool){
    super.viewWillAppear(animated)
    activityIndicator.startAnimating()
    reloadTableView()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    scrollDownTableView(true)
    self.activityIndicator.hidesWhenStopped = true
    self.activityView.isHidden = true
    self.activityIndicator.stopAnimating()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    norificationCenterDeinit()
  }

  @IBAction func sendButtonPressed(_ sender: Any) {
    let message = messageTextField.text!
    if message != ""{
      ApiWorker.sendMessageToUser(userId: userId, message: message)
    }
    clearMessageTextField()
    reloadTableView()
  }

  private func reloadTableView(){
    self.messagesFromUser = ApiWorker.messagesGetByUser(userId: userId)
    self.chatTableView.reloadData()
    self.scrollDownTableView(false)
  }


  func scrollDownTableView(_ animate: Bool){
    let numberOfSections = chatTableView.numberOfSections
    let numberOfRows = chatTableView.numberOfRows(inSection: numberOfSections - 1)
    if numberOfRows > 0 {
      let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
      chatTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animate)
    }
  }

  func clearMessageTextField(){
    messageTextField.text = ""
    bottomConstraint.constant = firstConstraintBottom
    messageTextField.isScrollEnabled = false
    messageTextField.isScrollEnabled = true
  }


  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messagesFromUser.count
  }

  func translateUnixTimeToRead(time: String) -> String{
    let date = NSDate(timeIntervalSince1970: TimeInterval(Int(time)!))
    let calendar = NSCalendar.current
    var hour = String(calendar.component(.hour, from: date as Date))
    var minutes = String(calendar.component(.minute, from: date as Date))
    if hour.characters.count == 1{
      hour = "0" + hour
    }
    if minutes.characters.count == 1{
      minutes = "0" + minutes
    }
    return "\(hour):\(minutes)"
  }


  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
    cell.messageLabel.text = messagesFromUser[indexPath.row].text
    cell.dateLabel.text = translateUnixTimeToRead(time: messagesFromUser[indexPath.row].date)
    if messagesFromUser[indexPath.row].fromId == messagesFromUser[indexPath.row].userId{
      cell.profileImageView.sd_setImage(with: URL(string: self.linkProfileImage))
    }else{
      cell.profileImageView.sd_setImage(with: URL(string: CurrentUserClass.linkProfileImage))
    }
    return cell
  }


  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    chatTableView.deselectRow(at: indexPath, animated: true)
  }

  func notificationCenterInit(){
    NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }

  func norificationCenterDeinit(){
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }


  func textViewDidChange(_ textView: UITextView){
    if messageTextField.text.characters.count >= 200{
      messageTextField.text.remove(at: messageTextField.text.index(before: messageTextField.text.endIndex))
    }
    let fixedWidth = textView.frame.size.width
    textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    var newFrame = textView.frame
    newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    textView.frame = newFrame
    let numLines = messageTextField.contentSize.height / (messageTextField.font?.lineHeight)!
    if numOfLines < Int(round(numLines)){
      self.bottomConstraint.constant += round(numLines) * 3
      self.numOfLines = Int(round(numLines))
    } else if numOfLines > Int(round(numLines)) {
      self.bottomConstraint.constant -= round(numLines) * 3
      self.numOfLines = Int(round(numLines))
    }
    if messageTextField.text == ""{
      clearMessageTextField()
    }
  }

  func keyboardWasShown(notification: NSNotification) {
    adjustingHeight(show: true, notification: notification)
    firstConstraintBottom = bottomConstraint.constant
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
      self.scrollDownTableView(true)
    }
  }

  func keyboardWillHide(notification: NSNotification) {
    adjustingHeight(show: false, notification: notification)
    firstConstraintBottom = bottomConstraint.constant
  }

  func adjustingHeight(show:Bool, notification:NSNotification) {
    var userInfo = notification.userInfo!
    let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
    let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
    let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
    UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
      self.bottomConstraint.constant = changeInHeight - 30
    })

  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    bottomConstraint.constant = 8.0
  }

}

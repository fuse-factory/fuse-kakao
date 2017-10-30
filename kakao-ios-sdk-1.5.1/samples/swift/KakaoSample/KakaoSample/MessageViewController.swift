/**
 * Copyright 2015-2017 Kakao Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum OptionType: Int {
        case talkAll = 1
        case talkInvitable
        case talkRegistered
        
        static func toType(_ type: Int) -> OptionType {
            switch type {
            case talkRegistered.rawValue:
                return talkRegistered
            case talkInvitable.rawValue:
                return talkInvitable
            default:
                return talkAll
            }
        }
    }
    
    let searchController: UISearchController! = UISearchController(searchResultsController: nil)
    
    let limitCount: Int = 2000
    
    var friendContext: KOFriendContext!
    var allFriends: [AnyObject] = []
    var filteredFriends: [AnyObject] = []
    var searchText: String?
    
    var requesting: Bool = false
    var optionType: OptionType = .talkAll
    var selectedFriend: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // 일단 내 정보를 먼저 가져온다.
        requestMe()

    }
    
    func updateViews() {
        filteredFriends.removeAll()
        for friend in allFriends {
            var nickName: String?
            if friend is KOFriend {
                nickName = friend.nickName
            } else if friend is KOUser {
                nickName = friend.properties[KOUserNicknamePropertyKey] as! String?
            }
            
            if (searchText ?? "").isEmpty || nickName?.range(of: searchText!, options: NSString.CompareOptions.caseInsensitive) != nil {
                filteredFriends.append(friend)
            }
        }
        tableView.reloadData()
    }
    
    func requestMe(_ displayResult: Bool = false) {
        KOSessionTask.meTask { [weak self] (user, error) -> Void in
            if let error = error as NSError? {
                print("requestMe error=\(error)")
                switch error.code {
                case Int(KOErrorCancelled.rawValue):
                    _ = self?.navigationController?.popViewController(animated: true)
                    break
                default:
                    UIAlertView.showMessage(error.description)
                    break
                }
            } else if let user = user as AnyObject? {
                self?.allFriends.append(user)
                
                // Talk 친구 정보를 가져온다.
                self?.setupFriendContext()
                self?.requestTalkFriends()
            }
        }
    }
    
    func setupFriendContext() {
        switch optionType {
        case .talkInvitable:
            friendContext = KOFriendContext(serviceType: .talk, filterType: .invitableNotRegistered, limit: limitCount)
        case .talkRegistered:
            friendContext = KOFriendContext(serviceType: .talk, filterType: .registered, limit: limitCount)
        default:
            friendContext = KOFriendContext(serviceType: .talk, filterType: .all, limit: limitCount)
        }
    }
    
    func requestTalkFriends() {
        if friendContext == nil {
            print("friendContext must be setup.")
            return
        }
        
        if requesting || !friendContext.hasMoreItems {
            return
        }
        
        requesting = true
        KOSessionTask.friends(with: friendContext, completionHandler: { [weak self] (friends, error) -> Void in
            if let error = error as NSError? {
                print("allFriends error=\(error)")
                switch error.code {
                case Int(KOErrorCancelled.rawValue):
                    _ = self?.navigationController?.popViewController(animated: true)
                    break
                default:
                    UIAlertView.showMessage(error.description)
                    break
                }
            } else if let friends = friends as [AnyObject]? {
                if let totalCount = self?.friendContext.totalCount {
                    self?.title = "Friends (\(totalCount))"
                }
                self?.allFriends.append(contentsOf: friends)
                self?.updateViews()
            }
            self?.requesting = false
        })
    }
    
    @IBAction func selectOptions(_ sender: AnyObject) {
        let alert = UIAlertView(title: "Options?", message: "", delegate: self, cancelButtonTitle: "Cancel",
            otherButtonTitles: "All", "Invitable, Not App Registered", "App Registered")
        alert.tag = 1
        alert.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == alertView.cancelButtonIndex {
            return
        }
        
        switch alertView.tag {
        case 1:
            let type = OptionType.toType(buttonIndex)
            if type == optionType {
                return
            }
            
            optionType = type
            allFriends.removeAll()
            
            if (optionType == .talkAll) {
                requestMe()
            } else {
                setupFriendContext()
                requestTalkFriends()
            }
            
        case 2:
            sendTemplateMessage()
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var normalCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if normalCell == nil {
            normalCell = ThumbnailImageViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }
        
        let friend: AnyObject = filteredFriends[(indexPath as NSIndexPath).row]
        
        if friend is KOUser {
            let user = friend as! KOUser
            
            normalCell?.textLabel?.text = "ToMe(나에게)"
            normalCell?.imageView?.image = UIImage(named: "PlaceHolder")
            if let url = user.properties?[KOUserThumbnailImagePropertyKey], let imageUrl = URL(string: url as! String) {
                normalCell?.imageView?.setImage(withUrl: imageUrl)
            }
        } else {
            normalCell?.textLabel?.text = friend.nickName
            normalCell?.imageView?.image = UIImage(named: "PlaceHolder")
            if let url = friend.thumbnailURL, let imageUrl = URL(string: url) {
                normalCell?.imageView?.setImage(withUrl: imageUrl)
            }
        }
        
        // load more
        let friendsCount = filteredFriends.count
        if (indexPath as NSIndexPath).row > (friendsCount - friendsCount / 3) {
            requestTalkFriends()
        }
        
        return normalCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedFriend = filteredFriends[(indexPath as NSIndexPath).row]
        
        let alert = UIAlertView(title: "Send Message?", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        alert.tag = 2
        alert.show()
    }
    
    func sendTemplateMessage() {
        if selectedFriend == nil {
            return
        }
        
        if selectedFriend is KOUser {
            let user = selectedFriend as! KOUser
            user.sendMemo(withTemplateId: MessageViewControllerConstants.memoTtemplateID, templateArgs: ["MESSAGE":"안녕하세요? 나와의 채팅방으로 보낸 메세지입니다.", "DATE":"2016-XX-XX(swift)"], completionHandler: { (error) -> Void in
                if let error = error as NSError? {
                    UIAlertView.showMessage("message send failed:\(error)")
                } else {
                    UIAlertView.showMessage("message send succeed.")
                }
            })
            
        } else {
            let friend = selectedFriend as! KOFriend
            
            if friend.isAllowedTalkMessaging == false {
                UIAlertView.showMessage("friend set message blocked.")
                return;
            }
            
            if optionType == .talkRegistered {
                let templateID = MessageViewControllerConstants.messageTemplateID  // feed template message id
                friend.sendMessage(withTemplateId: templateID, templateArgs: ["msg":"새로운 연결, 새로운 세상.", "iphoneMarketParam":"test", "iphoneExecParam":"test"], completionHandler: { (error) -> Void in
                    if let error = error as NSError? {
                        UIAlertView.showMessage("message send failed:\(error)")
                    } else {
                        UIAlertView.showMessage("message send succeed.")
                    }
                })
            } else {
                let templateID = MessageViewControllerConstants.inviteTemplateID  // invite template message id
                friend.sendMessage(withTemplateId: templateID, templateArgs: ["name":friend.nickName, "iphoneMarketParam":"test", "iphoneExecParam":"test"], completionHandler: { (error) -> Void in
                    if let error = error as NSError? {
                        UIAlertView.showMessage("message send failed:\(error)")
                    } else {
                        UIAlertView.showMessage("message send succeed.")
                    }
                })
            }
        }
        
        selectedFriend = nil
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        updateViews()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = self.searchText
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = self.searchText
    }
}

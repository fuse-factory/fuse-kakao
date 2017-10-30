/**
 * Copyright 2015-2016 Kakao Corp.
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

class PushViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var menu: [String] = ["My Token", "Register", "Send", "Get Tokens", "Deregister", "Deregister All Devices"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var normalCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if normalCell == nil {
            normalCell = IconTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }
        
        normalCell?.imageView?.image = UIImage(named: "PushMenuIcon\((indexPath as NSIndexPath).row)")
        normalCell?.textLabel?.text = menu[(indexPath as NSIndexPath).row]
        
        return normalCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menu[(indexPath as NSIndexPath).row] {
        case "My Token":
            getMyToken()
        case "Register":
            register()
        case "Send":
            send()
        case "Get Tokens":
            getTokens()
        case "Deregister":
            deregister()
        case "Deregister All Devices":
            deregisterAllDevices()
        default:
            fatalError("no menu item!!")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func deviceToken() -> Data! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.deviceToken as Data!
    }
    
    func getMyToken() {
        UIAlertView.showMessage("My Token = \(deviceToken())")
    }
    
    func register() {
        if let token = deviceToken() {

            KOSessionTask.pushRegisterDevice(withToken: token, completionHandler: { (success, expiredAt, error) -> Void in
                if error == nil {
                    UIAlertView.showMessage("Token register success = \(expiredAt)day available to use.")
                } else {
                    UIAlertView.showMessage("Token register fail.")
                }
            })
        } else {
            UIAlertView.showMessage("Token is not exist.")
        }
    }
    
    func send() {
        if let _ = deviceToken() {
            let customField = ["key1":"value1", "key2":"value2"]
            let apns = KakaoPushMessagePropertyForApns(badgeCount: 10, sound: "default", pushAlert: true, messageString: "푸시 잘 갑니까?", customField: customField)
            let gcm = KakaoPushMessagePropertyForGcm(collapse: "collapse_id_1234", delayWhileIdle: false, returnUrl: "http://www.example.com/test", customField: customField)
            let pushMessageObject = KakaoPushMessageObject(apnsProperty: apns, gcmProperty: gcm)
            
            KOSessionTask.pushSendMsg(pushMessageObject, completionHandler: { (success, error) -> Void in
                if error == nil {
                    UIAlertView.showMessage("Send PushMessage success.")
                } else {
                    UIAlertView.showMessage("Send PushMessage fail.")
                }
            })
        } else {
            UIAlertView.showMessage("Token is not exist.")
        }
    }
    
    func getTokens() {
        KOSessionTask.pushGetTokensTask { (tokens, error) -> Void in
            if error == nil {
                UIAlertView.showMessage("Tokens = \(tokens!)")
            } else {
                UIAlertView.showMessage("Get tokens fail.")
            }
        }
    }
    
    func deregister() {
        if let token = deviceToken() {
            KOSessionTask.pushDeregisterDevice(withToken: token, completionHandler: { (success, error) -> Void in
                if error == nil {
                    UIAlertView.showMessage("Token deregister success.")
                } else {
                    UIAlertView.showMessage("Token deregister fail.")
                }
            })
        } else {
            UIAlertView.showMessage("Token is not exist.")
        }
    }
    
    func deregisterAllDevices() {
        KOSessionTask.pushDeregisterAllDevice { (success, error) -> Void in
            if error == nil {
                UIAlertView.showMessage("All Devices token deregister success.")
            } else {
                UIAlertView.showMessage("All Devices token deregister fail.")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

/**
 * Copyright 2017 Kakao Corp.
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

import Foundation

extension UIView {
    static let LOADING_VIEW_TAG = 23513
    
    func startLoading() -> Void {
        let loadingView = self.viewWithTag(UIView.LOADING_VIEW_TAG)
        if loadingView == nil {
            let loadingView = UIView.init(frame: self.bounds)
            loadingView.tag = UIView.LOADING_VIEW_TAG
            self.addSubview(loadingView)
            
            let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            activityIndicator.center = loadingView.center
            activityIndicator.startAnimating()
            loadingView.addSubview(activityIndicator)
            
            loadingView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: { 
                loadingView.alpha = 1
            })
        }
    }
    
    func stopLoading() -> Void {
        if let loadingView = self.viewWithTag(UIView.LOADING_VIEW_TAG) {
            UIView.animate(withDuration: 0.3, animations: { 
                loadingView.alpha = 0
            }, completion: { (finished) in
                loadingView.removeFromSuperview()
            })
        }
    }
}

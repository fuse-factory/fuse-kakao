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

class StoryPostingActivity: UIActivity {

    let ACTIVITY_NAME = "StoryLink"
    fileprivate let linkUrlString: String!
    
    init(linkUrlString: String!) {
        self.linkUrlString = linkUrlString
    }
   
    override var activityImage : UIImage? {
        return UIImage(named: ACTIVITY_NAME)
    }
    
    override var activityTitle : String? {
        return ACTIVITY_NAME
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return linkUrlString != nil && StoryLinkHelper.canOpenStoryLink()
    }
    
    override func perform() {
        _ = StoryLinkHelper.openStoryLink(linkUrlString)
    }
}

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

#import "UIView+Loading.h"

@implementation UIView (Loading)

static const int LOADING_VIEW_TAG = 23513;

- (void)startLoading {
    UIView *loadingView = [self viewWithTag:LOADING_VIEW_TAG];
    if (loadingView == nil) {
        loadingView = [[UIView alloc] initWithFrame:self.bounds];
        loadingView.tag = LOADING_VIEW_TAG;
        [self addSubview:loadingView];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = loadingView.center;
        [activityIndicator startAnimating];
        [loadingView addSubview:activityIndicator];
        
        loadingView.alpha = 0.0f;
        [UIView animateWithDuration:0.3 animations:^{
            loadingView.alpha = 1.0f;
        }];
    }
}

- (void)stopLoading {
    UIView *loadingView = [self viewWithTag:LOADING_VIEW_TAG];
    if (loadingView) {
        [UIView animateWithDuration:0.3 animations:^{
            loadingView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [loadingView removeFromSuperview];
        }];
    }
}

@end

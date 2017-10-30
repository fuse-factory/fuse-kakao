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

#import "StoryPostingActivity.h"
#import "StoryLinkHelper.h"

@implementation StoryPostingActivity {
    NSString *_activityName;
    NSString *_linkURLString;
}

- (instancetype)initWithLinkURLString:(NSString *)linkURLString {
    if (self = [super init]) {
        _activityName = @"StoryLink";
        _linkURLString = [linkURLString copy];
    }
    
    return self;
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:_activityName];
}

- (NSString *)activityTitle {
    return _activityName;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return _linkURLString.length > 0 && [StoryLinkHelper canOpenStoryLink];
}

- (void)performActivity {
    [StoryLinkHelper openStoryLinkWithURLString:_linkURLString];
}

@end

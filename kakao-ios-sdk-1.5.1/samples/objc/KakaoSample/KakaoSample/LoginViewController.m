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

#import "LoginViewController.h"
#import "UIButton+Addition.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.loginButton setBackgroundColor:[UIColor colorWithRed:0xff / 255.0 green:0xcc / 255.0 blue:0x00 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[UIColor colorWithRed:0xff / 255.0 green:0xb4 / 255.0 blue:0x00 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    self.loginButton.clipsToBounds = YES;
    self.loginButton.layer.cornerRadius = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    KOSession *session = [KOSession sharedSession];
    
    if (session.isOpen) {
        [session close];
    }
    
    [session openWithCompletionHandler:^(NSError *error) {
        if (!session.isOpen) {
            switch (error.code) {
                case KOErrorCancelled:
                    break;
                default:
                    [[[UIAlertView alloc] initWithTitle:@"에러" message:error.description delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil] show];
                    break;
            }
        }
    }];
}

@end

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

#import "PushViewController.h"
#import "IconTableViewCell.h"
#import "UIAlertView+Addition.h"
#import "AppDelegate.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface PushViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PushViewController {
    NSArray *_menu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menu = @[@"My Token", @"Register", @"Send", @"Get Tokens", @"Deregister", @"Deregister All Devices"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[IconTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"PushMenuIcon%d", (int) indexPath.row]];
    cell.textLabel.text = _menu[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *menuString = _menu[indexPath.row];
    if ([menuString isEqualToString:@"My Token"]) {
        [self showMyDeviceToken];
        
    } else if ([menuString isEqualToString:@"Register"]) {
        [self registerToken];
        
    } else if ([menuString isEqualToString:@"Send"]) {
        [self sendPush];
        
    } else if ([menuString isEqualToString:@"Get Tokens"]) {
        [self getTokens];
        
    } else if ([menuString isEqualToString:@"Deregister"]) {
        [self deregister];
        
    } else if ([menuString isEqualToString:@"Deregister All Devices"]) {
        [self deregisterAllDevices];
    }
}

- (NSData *)deviceToken {
    return ((AppDelegate *) [[UIApplication sharedApplication] delegate]).deviceToken;
}

- (void)showMyDeviceToken {
    [UIAlertView showMessage:[NSString stringWithFormat:@"My Token = %@", [self deviceToken]]];
}

- (void)registerToken {
    NSData *deviceToken = [self deviceToken];
    if (deviceToken == nil) {
        [UIAlertView showMessage:@"Token is not exist."];
        return;
    }
    
    [KOSessionTask pushRegisterDeviceWithToken:deviceToken
                             completionHandler:^(BOOL success, NSInteger expiredAt, NSError *error) {
                                 if (error) {
                                     [UIAlertView showMessage:[NSString stringWithFormat:@"Token register error = %@", error]];
                                 } else {
                                     [UIAlertView showMessage:@"Token register success."];
                                 }
                             }];
}

- (void)sendPush {
    NSData *deviceToken = [self deviceToken];
    if (deviceToken == nil) {
        [UIAlertView showMessage:@"Token is not exist."];
        return;
    }

    NSDictionary *customField = @{@"key1":@"value1", @"key2":@"value2"};
    KakaoPushMessagePropertyForApns *apns = [[KakaoPushMessagePropertyForApns alloc] initWithBadgeCount:10 sound:@"default" pushAlert:YES messageString:@"푸시 잘 갑니까?" customField:customField];
    KakaoPushMessagePropertyForGcm *gcm = [[KakaoPushMessagePropertyForGcm alloc] initWithCollapse:@"collapse_id_1234" delayWhileIdle:NO returnUrl:@"http://www.example.com/test" customField:customField];
    KakaoPushMessageObject *pushMessageObject = [[KakaoPushMessageObject alloc] initWithApnsProperty:apns gcmProperty:gcm];
    
    [KOSessionTask pushSendMsg:pushMessageObject completionHandler:^(BOOL success, NSError *error) {
        if (error) {
            [UIAlertView showMessage:[NSString stringWithFormat:@"Push send error = %@", error]];
        } else {
            [UIAlertView showMessage:@"Push send success."];
        }
    }];
}

- (void)getTokens {
    NSData *deviceToken = [self deviceToken];
    if (deviceToken == nil) {
        [UIAlertView showMessage:@"Token is not exist."];
        return;
    }

    [KOSessionTask pushGetTokensTaskWithCompletionHandler:^(NSArray *tokens, NSError *error) {
        if (error) {
            [UIAlertView showMessage:[NSString stringWithFormat:@"Get Tokens error = %@", error]];
        } else {
            [UIAlertView showMessage:[NSString stringWithFormat:@"Get Tokens = %@", tokens.description]];
        }
    }];
}

- (void)deregister {
    NSData *deviceToken = [self deviceToken];
    if (deviceToken == nil) {
        [UIAlertView showMessage:@"Token is not exist."];
        return;
    }

    [KOSessionTask pushDeregisterDeviceWithToken:deviceToken
                               completionHandler:^(BOOL success, NSError *error) {
                                   if (error) {
                                       [UIAlertView showMessage:[NSString stringWithFormat:@"Token deregister error = %@", error]];
                                   } else {
                                       [UIAlertView showMessage:@"Token deregister success."];
                                   }
                               }];
}

- (void)deregisterAllDevices {
    [KOSessionTask pushDeregisterAllDeviceWithCompletionHandler:^(BOOL success, NSError *error) {
        if (error) {
            [UIAlertView showMessage:[NSString stringWithFormat:@"All Devices token deregister error = %@", error]];
        } else {
            [UIAlertView showMessage:@"All Devices token deregister success."];
        }
    }];
}

@end

/**
 * Copyright 2016-2017 Kakao Corp.
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

#import "MainViewController.h"
#import <KakaoNavi/KakaoNavi.h>

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *reuseIdentifier;
@property (strong, nonatomic) NSArray *headers;
@property (strong, nonatomic) NSArray *texts;

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIButton *naviButton;

- (IBAction)execute:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reuseIdentifier = @"KakaoNaviSampleCell";
    self.headers = @[@"목적지 공유", @"목적지 길안내"];
    self.texts = @[@[@[@"카카오판교오피스", @""],
                     @[@"카카오판교오피스", @"WGS84"],],
                   @[@[@"카카오판교오피스", @"WGS84"],
                     @[@"카카오판교오피스", @"전체 경로정보 보기"],],];
    
    self.title = @"카카오내비샘플";
    
    self.naviButton.layer.cornerRadius = 5;
    self.naviButton.layer.borderWidth = 1;
    self.naviButton.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    self.naviButton.backgroundColor = [UIColor colorWithRed:(254 / 255.0) green:(238 / 255.0) blue:(53 / 255.0) alpha:1];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.texts[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.headers[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:self.reuseIdentifier];
    }
    cell.textLabel.text = self.texts[indexPath.section][indexPath.row][0];
    cell.detailTextLabel.text = self.texts[indexPath.section][indexPath.row][1];
    return cell;
}

- (IBAction)execute:(id)sender {
    KNVLocation *destination;
    KNVOptions *options;
    KNVParams *params;
    NSError *error = nil;
    
    if (self.menuTableView.indexPathForSelectedRow) {
        NSIndexPath *selected = self.menuTableView.indexPathForSelectedRow;
        switch (selected.section) {
            case 0:
                switch (selected.row) {
                    case 0:
                        
                        // 목적지 공유 - 카카오판교오피스
                        destination = [KNVLocation locationWithName:@"카카오판교오피스" x:@(321286) y:@(533707)];
                        params = [KNVParams paramWithDestination:destination];
                        [[KNVNaviLauncher sharedLauncher] shareDestinationWithParams:params error:&error];
                        
                        break;
                    case 1:
                        
                        // 목적지 공유 - 카카오판교오피스 - WGS84
                        destination = [KNVLocation locationWithName:@"카카오판교오피스" x:@(127.1087) y:@(37.40206)];
                        options = [KNVOptions options];
                        options.coordType = KNVCoordTypeWGS84;
                        params = [KNVParams paramWithDestination:destination options:options];
                        [[KNVNaviLauncher sharedLauncher] shareDestinationWithParams:params error:&error];
                        
                        break;
                    default:
                        error = [NSError errorWithDomain:@"KakaoNaviSampleErrorDomain" code:1 userInfo:@{NSLocalizedFailureReasonErrorKey:@"존재하지 않는 메뉴입니다."}];
                        break;
                }
                break;
            case 1:
                switch (selected.row) {
                    case 0:
                        
                        // 목적지 길안내 - 카카오판교오피스 - WGS84
                        destination = [KNVLocation locationWithName:@"카카오판교오피스" x:@(127.1087) y:@(37.40206)];
                        options = [KNVOptions options];
                        options.coordType = KNVCoordTypeWGS84;
                        params = [KNVParams paramWithDestination:destination options:options];
                        [[KNVNaviLauncher sharedLauncher] navigateWithParams:params error:&error];
                        
                        break;
                    case 1:
                        
                        // 목적지 길안내 - 카카오판교오피스 - 전체 경로정보 보기
                        destination = [KNVLocation locationWithName:@"카카오판교오피스" x:@(321286) y:@(533707)];
                        options = [KNVOptions options];
                        options.routeInfo = YES;
                        params = [KNVParams paramWithDestination:destination options:options];
                        [[KNVNaviLauncher sharedLauncher] navigateWithParams:params error:&error];
                        
                        break;
                    default:
                        error = [NSError errorWithDomain:@"KakaoNaviSampleErrorDomain" code:1 userInfo:@{NSLocalizedFailureReasonErrorKey:@"존재하지 않는 메뉴입니다."}];
                        break;
                }
                break;
            default:
                error = [NSError errorWithDomain:@"KakaoNaviSampleErrorDomain" code:1 userInfo:@{NSLocalizedFailureReasonErrorKey:@"존재하지 않는 메뉴입니다."}];
                break;
        }
    } else {
        error = [NSError errorWithDomain:@"KakaoNaviSampleErrorDomain" code:2 userInfo:@{NSLocalizedFailureReasonErrorKey:@"메뉴를 선택해 주세요."}];
    }
    
    if (error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.title message:error.localizedFailureReason preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

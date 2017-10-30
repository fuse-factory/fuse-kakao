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

#import "ViewController.h"
#import "IconTableViewCell.h"
#import "KakaoLinkActivity.h"
#import <KakaoLink/KakaoLink.h>

#import "StoryLinkHelper.h"
#import "StoryPostingActivity.h"

#import "UIViewController+Alert.h"
#import "UIView+Loading.h"

#import "ConfigConstants.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController {
    NSArray *_menuItems;
    UIDocumentInteractionController *_documentController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _menuItems = @[@[@"KakaoLink", @[@[@"Send Default", @"(Feed Template)", @"SendFeed"],
                                     @[@"Send Defalut", @"(List Template)", @"SendList"],
                                     @[@"Send Defalut", @"(Location Template)", @"SendLocation"],
                                     @[@"Send Default", @"(Commerce Template)", @"SendCommerce"],
                                     @[@"Send Scrap", @"", @"SendScrap"],
                                     @[@"Send Custom", @"", @"SendCustom"],
                                     ]
                     ],
                   @[@"Image Storage", @[@[@"Upload Image", @"", @"Upload"],
                                         @[@"Scrap Image", @"", @"Upload"],
                                         ]
                     ],
                   @[@"Etc", @[@[@"Story Posting", @"", @"StoryPosting"],
                               @[@"Share File", @"(UIDocumentInteractionController)", @"ShareFile"],
                               ]
                     ]
                ];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _menuItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_menuItems[section][1] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _menuItems[section][0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IconTableViewCell"];
    if (cell == nil) {
        cell = [[IconTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IconTableViewCell"];
    }
    
    NSArray *menuItem = _menuItems[indexPath.section][1][indexPath.row];
    cell.textLabel.text = menuItem[0];
    cell.detailTextLabel.text = menuItem[1];
    cell.imageView.image = [UIImage imageNamed:menuItem[2]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self sendLinkFeed];
                    break;
                case 1:
                    [self sendLinkList];
                    break;
                case 2:
                    [self sendLinkLocation];
                    break;
                case 3:
                    [self sendLinkCommerce];
                    break;
                case 4:
                    [self sendLinkScrap];
                    break;
                case 5:
                    [self sendLinkCustom];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self uploadLocalImage];
                    break;
                case 1:
                    [self scrapRemoteImage];
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    [self postStory];
                    break;
                case 1:
                    [self showChooseSharingFile];
                    break;
            }
            break;
    }
}

- (void)sendLinkFeed {
    
    // Feed 타입 템플릿 오브젝트 생성
    KLKTemplate *template = [KLKFeedTemplate feedTemplateWithBuilderBlock:^(KLKFeedTemplateBuilder * _Nonnull feedTemplateBuilder) {
        
        // 컨텐츠
        feedTemplateBuilder.content = [KLKContentObject contentObjectWithBuilderBlock:^(KLKContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"딸기 치즈 케익";
            contentBuilder.desc = @"#케익 #딸기 #삼평동 #까페 #분위기 #소개팅";
            contentBuilder.imageURL = [NSURL URLWithString:@"http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png"];
            contentBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }];
        
        // 소셜
        feedTemplateBuilder.social = [KLKSocialObject socialObjectWithBuilderBlock:^(KLKSocialBuilder * _Nonnull socialBuilder) {
            socialBuilder.likeCount = @(286);
            socialBuilder.commnentCount = @(45);
            socialBuilder.sharedCount = @(845);
        }];
        
        // 버튼
        [feedTemplateBuilder addButton:[KLKButtonObject buttonObjectWithBuilderBlock:^(KLKButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"웹으로 보기";
            buttonBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
        [feedTemplateBuilder addButton:[KLKButtonObject buttonObjectWithBuilderBlock:^(KLKButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"앱으로 보기";
            buttonBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.iosExecutionParams = @"param1=value1&param2=value2";
                linkBuilder.androidExecutionParams = @"param1=value1&param2=value2";
            }];
        }]];
    }];
    
    // 카카오링크 실행
    [self.view startLoading];
    [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        
        // 성공
        [self.view stopLoading];
        NSLog(@"warning message: %@", warningMsg);
        NSLog(@"argument message: %@", argumentMsg);
        
    } failure:^(NSError * _Nonnull error) {
        
        // 실패
        [self.view stopLoading];
        [self alertWithMessage:error.description];
        NSLog(@"error: %@", error);
        
    }];
}

- (void)sendLinkList {
    
    // List 타입 템플릿 오브젝트 생성
    KLKTemplate *template = [KLKListTemplate listTemplateWithBuilderBlock:^(KLKListTemplateBuilder * _Nonnull listTemplateBuilder) {
        
        // 헤더 타이틀 및 링크
        listTemplateBuilder.headerTitle = @"WEEKLY MAGAZINE";
        listTemplateBuilder.headerLink = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
            linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
        }];
        
        // 컨텐츠 목록
        [listTemplateBuilder addContent:[KLKContentObject contentObjectWithBuilderBlock:^(KLKContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"취미의 특징, 탁구";
            contentBuilder.desc = @"스포츠";
            contentBuilder.imageURL = [NSURL URLWithString:@"http://mud-kage.kakao.co.kr/dn/bDPMIb/btqgeoTRQvd/49BuF1gNo6UXkdbKecx600/kakaolink40_original.png"];
            contentBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
        [listTemplateBuilder addContent:[KLKContentObject contentObjectWithBuilderBlock:^(KLKContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"크림으로 이해하는 커피이야기";
            contentBuilder.desc = @"음식";
            contentBuilder.imageURL = [NSURL URLWithString:@"http://mud-kage.kakao.co.kr/dn/QPeNt/btqgeSfSsCR/0QJIRuWTtkg4cYc57n8H80/kakaolink40_original.png"];
            contentBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
        [listTemplateBuilder addContent:[KLKContentObject contentObjectWithBuilderBlock:^(KLKContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"감성이 가득한 분위기";
            contentBuilder.desc = @"사진";
            contentBuilder.imageURL = [NSURL URLWithString:@"http://mud-kage.kakao.co.kr/dn/c7MBX4/btqgeRgWhBy/ZMLnndJFAqyUAnqu4sQHS0/kakaolink40_original.png"];
            contentBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
        
        // 버튼
        [listTemplateBuilder addButton:[KLKButtonObject buttonObjectWithBuilderBlock:^(KLKButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"웹으로 보기";
            buttonBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
        [listTemplateBuilder addButton:[KLKButtonObject buttonObjectWithBuilderBlock:^(KLKButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"앱으로 보기";
            buttonBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.iosExecutionParams = @"param1=value1&param2=value2";
                linkBuilder.androidExecutionParams = @"param1=value1&param2=value2";
            }];
        }]];
        
    }];
    
    // 카카오링크 실행
    [self.view startLoading];
    [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        
        // 성공
        [self.view stopLoading];
        NSLog(@"warning message: %@", warningMsg);
        NSLog(@"argument message: %@", argumentMsg);
        
    } failure:^(NSError * _Nonnull error) {
        
        // 실패
        [self.view stopLoading];
        [self alertWithMessage:error.description];
        NSLog(@"error: %@", error);
        
    }];
}

- (void)sendLinkLocation {
    
    // Location 타입 템플릿 오브젝트 생성
    KLKTemplate *template = [KLKLocationTemplate locationTemplateWithBuilderBlock:^(KLKLocationTemplateBuilder * _Nonnull locationTemplateBuilder) {
        
        // 주소
        locationTemplateBuilder.address = @"경기 성남시 분당구 판교역로 235 에이치스퀘어 N동 8층";
        locationTemplateBuilder.addressTitle = @"카카오 판교오피스 카페톡";
        
        // 컨텐츠
        locationTemplateBuilder.content = [KLKContentObject contentObjectWithBuilderBlock:^(KLKContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"신메뉴 출시❤️ 체리블라썸라떼";
            contentBuilder.desc = @"이번 주는 체리블라썸라떼 1+1";
            contentBuilder.imageURL = [NSURL URLWithString:@"http://mud-kage.kakao.co.kr/dn/bSbH9w/btqgegaEDfW/vD9KKV0hEintg6bZT4v4WK/kakaolink40_original.png"];
            contentBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }];
        
        // 소셜
        locationTemplateBuilder.social = [KLKSocialObject socialObjectWithBuilderBlock:^(KLKSocialBuilder * _Nonnull socialBuilder) {
            socialBuilder.likeCount = @(286);
            socialBuilder.commnentCount = @(45);
            socialBuilder.sharedCount = @(845);
        }];
    }];
    
    // 카카오링크 실행
    [self.view startLoading];
    [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        
        // 성공
        [self.view stopLoading];
        NSLog(@"warning message: %@", warningMsg);
        NSLog(@"argument message: %@", argumentMsg);
        
    } failure:^(NSError * _Nonnull error) {
        
        // 실패
        [self.view stopLoading];
        [self alertWithMessage:error.description];
        NSLog(@"error: %@", error);
        
    }];
}

- (void)sendLinkCommerce {
    
    // Commerce 타입 템플릿 오브젝트 생성
    KLKTemplate *template = [KLKCommerceTemplate commerceTemplateWithBuilderBlock:^(KLKCommerceTemplateBuilder * _Nonnull commerceTemplateBuilder) {
        
        // 컨텐츠
        commerceTemplateBuilder.content = [KLKContentObject contentObjectWithBuilderBlock:^(KLKContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = @"Ivory long dress (4 Color)";
            contentBuilder.imageURL = [NSURL URLWithString:@"http://mud-kage.kakao.co.kr/dn/RY8ZN/btqgOGzITp3/uCM1x2xu7GNfr7NS9QvEs0/kakaolink40_original.png"];
            contentBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }];
        
        // 가격
        commerceTemplateBuilder.commerce = [KLKCommerceObject commerceObjectWithBuilderBlock:^(KLKCommerceBuilder * _Nonnull commerceBuilder) {
            commerceBuilder.regularPrice = @(208800);
            commerceBuilder.discountPrice = @(146160);
            commerceBuilder.discountRate = @(30);
        }];
        
        // 버튼
        [commerceTemplateBuilder addButton:[KLKButtonObject buttonObjectWithBuilderBlock:^(KLKButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"구매하기";
            buttonBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString:@"https://developers.kakao.com"];
            }];
        }]];
        [commerceTemplateBuilder addButton:[KLKButtonObject buttonObjectWithBuilderBlock:^(KLKButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"공유하기";
            buttonBuilder.link = [KLKLinkObject linkObjectWithBuilderBlock:^(KLKLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.iosExecutionParams = @"param1=value1&param2=value2";
                linkBuilder.androidExecutionParams = @"param1=value1&param2=value2";
            }];
        }]];
        
    }];
    
    // 카카오링크 실행
    [self.view startLoading];
    [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        
        // 성공
        [self.view stopLoading];
        NSLog(@"warning message: %@", warningMsg);
        NSLog(@"argument message: %@", argumentMsg);
        
    } failure:^(NSError * _Nonnull error) {
        
        // 실패
        [self.view stopLoading];
        [self alertWithMessage:error.description];
        NSLog(@"error: %@", error);
        
    }];
}

- (void)sendLinkScrap {
    
    // 스크랩할 웹페이지 URL
    NSURL *URL = [NSURL URLWithString:@"https://store.kakaofriends.com/"];

    // 카카오링크 실행
    [self.view startLoading];
    [[KLKTalkLinkCenter sharedCenter] sendScrapWithURL:URL success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        
        // 성공
        [self.view stopLoading];
        NSLog(@"warning message: %@", warningMsg);
        NSLog(@"argument message: %@", argumentMsg);
        
    } failure:^(NSError * _Nonnull error) {
        
        // 실패
        [self.view stopLoading];
        [self alertWithMessage:error.description];
        NSLog(@"error: %@", error);
        
    }];
}

- (void)sendLinkCustom {
    
    // 템플릿 ID
    NSString *templateId = CUSTOM_TEMPLATE_ID;
    // 템플릿 Arguments
    NSDictionary *templateArgs = @{@"title": @"제목 영역입니다.",
                                   @"description": @"설명 영역입니다."};
    
    // 카카오링크 실행
    [self.view startLoading];
    [[KLKTalkLinkCenter sharedCenter] sendCustomWithTemplateId:templateId templateArgs:templateArgs success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        
        // 성공
        [self.view stopLoading];
        NSLog(@"warning message: %@", warningMsg);
        NSLog(@"argument message: %@", argumentMsg);
        
    } failure:^(NSError * _Nonnull error) {
        
        // 실패
        [self.view stopLoading];
        [self alertWithMessage:error.description];
        NSLog(@"error: %@", error);
        
    }];
}

- (void)uploadLocalImage {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 업로드할 이미지
    UIImage *sourceImage = info[UIImagePickerControllerOriginalImage];
    
    [self.view startLoading];
    [[KLKImageStorage sharedStorage] uploadWithImage:sourceImage success:^(KLKImageInfo * _Nonnull original) {
        
        // 업로드 성공
        [self.view stopLoading];
        [self alertWithMessage:[NSString stringWithFormat:@"업로드 성공\n%@", original.URL]];
        
    } failure:^(NSError * _Nonnull error) {
        
        // 업로드 실패
        [self.view stopLoading];
        [self alertWithMessage:error.description];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrapRemoteImage {
    
    // 원격지 이미지 URL
    NSURL *imageURL = [NSURL URLWithString:@"http://www.kakaocorp.com/images/logo/og_daumkakao_151001.png"];
    
    [self.view startLoading];
    [[KLKImageStorage sharedStorage] scrapWithImageURL:imageURL success:^(KLKImageInfo * _Nonnull original) {
        
        // 업로드 성공
        [self.view stopLoading];
        [self alertWithMessage:[NSString stringWithFormat:@"업로드 성공\n%@", original.URL]];
        
    } failure:^(NSError * _Nonnull error) {
        
        // 업로드 실패
        [self.view stopLoading];
        [self alertWithMessage:error.description];
        
    }];
}

- (void)showChooseSharingFile {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"공유 파일?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"JPG", @"MP4", @"TXT", @"GIF", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [self shareFile:[[NSBundle mainBundle] URLForResource:@"test_img" withExtension:@"jpg"]];
            break;
        case 2:
            [self shareFile:[[NSBundle mainBundle] URLForResource:@"test_vod" withExtension:@"mp4"]];
            break;
        case 3:
            // kakaotalk not support yet.
            [self shareFile:[[NSBundle mainBundle] URLForResource:@"test_text" withExtension:@"txt"]];
            break;
        case 4:
            // kakaotalk not support yet.
            [self shareFile:[[NSBundle mainBundle] URLForResource:@"test_gif" withExtension:@"gif"]];
            break;
        default:
            break;
    }
}

- (void)shareFile:(NSURL *)localPath {
    _documentController = [[UIDocumentInteractionController alloc] init];
    _documentController.URL = localPath;
    _documentController.delegate = self;
    [_documentController presentOptionsMenuFromRect:self.view.frame inView:self.view animated:YES];
}

- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller {
    _documentController = nil;
}

- (void)postStory {
    if (![StoryLinkHelper canOpenStoryLink]) {
        NSLog(@"Cannot open kakao story.");
        return;
    }
    
    NSBundle *bundle = [NSBundle mainBundle];
    ScrapInfo *scrapInfo = [[ScrapInfo alloc] init];
    scrapInfo.title = @"Sample";
    scrapInfo.desc = @"Sample 입니다.";
    scrapInfo.imageURLs = @[@"http://www.daumkakao.com/images/operating/temp_mov.jpg"];
    scrapInfo.type = ScrapTypeVideo;
    
    NSString *storyLinkURLString = [StoryLinkHelper makeStoryLinkWithPostingText:@"Sample Story Posting https://www.youtube.com/watch?v=XUX1jtTKkKs"
                                                                     appBundleID:[bundle bundleIdentifier]
                                                                      appVersion:[bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
                                                                         appName:[bundle objectForInfoDictionaryKey:@"CFBundleName"]
                                                                       scrapInfo:scrapInfo];
    [StoryLinkHelper openStoryLinkWithURLString:storyLinkURLString];
}


@end

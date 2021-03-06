//
//  STDemoViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-2-20.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDemoViewController.h"
#import "STDTextViewController.h"
#import "STDLinkViewController.h"
#import "STDNavigationTestViewController.h"
#import "STDownloadViewController.h"
#import <STKit/STNotificationWindow.h>
#import "STDCardViewController.h"
#import "STDImageBlurViewController.h"
#import "STDScrollViewController.h"


@interface STDemoViewController () <STImagePickerControllerDelegate, STNotificationWindowDelegate, UIGestureRecognizerDelegate,
                                    STNavigationControllerDelegate>

@property(nonatomic, strong) NSMutableArray *dataSource;

@property(nonatomic, strong) STNotificationWindow *notificationWindow;

@property(nonatomic, strong) STSearchDisplayController *searchController;

@end

@implementation STDemoViewController

@dynamic dataSource;

- (id)initWithStyle:(UITableViewStyle)tableViewStyle {
    self = [super initWithStyle:tableViewStyle];
    if (self) {
        // Custom initialization
        NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:2];
        self.clearsSelectionOnViewWillAppear = YES;

        STDTableViewCellItem *item00 =
            [[STDTableViewCellItem alloc] initWithTitle:@"导航适配" target:self action:@selector(testNavigationActionFired)];
        STDTableViewSectionItem *section0 = [[STDTableViewSectionItem alloc]
            initWithSectionTitle:@"包含对导航的一些适配，主要针对于一些NavigationBarHidden时，push或者pop的情况"
                           items:@[ item00 ]];
        [dataSource addObject:section0];

        STDTableViewCellItem *item10 =
            [[STDTableViewCellItem alloc] initWithTitle:@"查看大图" target:self action:@selector(imageDownloadActionFired)];
        STDTableViewCellItem *item11 = [[STDTableViewCellItem alloc] initWithTitle:@"图片加载" target:self action:@selector(imageCardActionFired)];
        STDTableViewCellItem *item12 = [[STDTableViewCellItem alloc] initWithTitle:@"图片选择" target:self action:@selector(imagePickerActionFired)];
        STDTableViewCellItem *item13 = [[STDTableViewCellItem alloc] initWithTitle:@"图片打码" target:self action:@selector(imageBlurActionFired)];

        STDTableViewSectionItem *section1 = [[STDTableViewSectionItem alloc]
            initWithSectionTitle:
                @"以下为一些对图片封装, 包含图片的网络下载，本地缓存，查看大图，从相册选取多张图片等。"
                           items:@[ item10, item11, item12, item13 ]];
        [dataSource addObject:section1];

        STDTableViewCellItem *item20 = [[STDTableViewCellItem alloc] initWithTitle:@"Label样式" target:self action:@selector(linkActionFired)];
        STDTableViewCellItem *item21 = [[STDTableViewCellItem alloc] initWithTitle:@"超链接文本" target:self action:@selector(textActionFired)];
        STDTableViewSectionItem *section2 =
            [[STDTableViewSectionItem alloc] initWithSectionTitle:@"包含UILabel的各种对齐方式" items:@[ item20, item21 ]];
        [dataSource addObject:section2];

        STDTableViewCellItem *item30 = [[STDTableViewCellItem alloc] initWithTitle:@"翻栏提醒" target:self action:@selector(notificationActionFired)];
        STDTableViewSectionItem *section3 =
            [[STDTableViewSectionItem alloc] initWithSectionTitle:@"应用内的提醒, 适合即时通讯类的收到消息时提示"
                                                            items:@[ item30 ]];
        [dataSource addObject:section3];
        

        STDTableViewCellItem *item40 = [[STDTableViewCellItem alloc] initWithTitle:@"内嵌网页" target:self action:@selector(webViewActionFired)];
        STDTableViewSectionItem *section4 =
            [[STDTableViewSectionItem alloc] initWithSectionTitle:@"目前只提供了导航的功能，稍后会加入与Native交互的功能"
                                                            items:@[ item40 ]];
        [dataSource addObject:section4];
        
        STDTableViewCellItem *item50 = [[STDTableViewCellItem alloc] initWithTitle:@"WebViewScrollView" target:self action:@selector(frameVSBoundsActionFired)];
        STDTableViewSectionItem *section5 =
        [[STDTableViewSectionItem alloc] initWithSectionTitle:@"ScrollViewController"
                                                        items:@[ item50 ]];
        [dataSource addObject:section5];

        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"基本组件";
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (self.st_sideBarController) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        button.frame = CGRectMake(0, 0, 60, 44);
        [button setImage:[UIImage imageNamed:@"nav_menu_normal.png"] forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
        [button addTarget:self action:@selector(leftBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)_longPressActionFired:(UIGestureRecognizer *)gesture {
    NSLog(@"%@", NSStringFromCGPoint([gesture locationInView:self.view]));
}
- (void)_changeRowActionFired:(id)sender {
    STDTableViewSectionItem *sectionItem0 = self.dataSource[0];
    STDTableViewSectionItem *sectionItem1 = self.dataSource[1];
    NSMutableArray *items0 = [sectionItem0.items mutableCopy];
    NSMutableArray *items1 = [sectionItem1.items mutableCopy];
    
    NSIndexPath *fromIndexPath;
    NSIndexPath *targetIndexPath;
    
    if (items0.count == 2) {
        // 从0 到2
        id item0 = [items0 lastObject];
        [items1 addObject:item0];
        [items0 removeLastObject];
        sectionItem0.items = items0;
        sectionItem1.items = items1;
        fromIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        targetIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    } else {
        id item1 = [items1 firstObject];
        [items0 addObject:item1];
        [items1 removeObjectAtIndex:0];
        sectionItem0.items = items0;
        sectionItem1.items = items1;
        fromIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        targetIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    
    [self.tableView beginUpdates];
    [self.tableView moveRowAtIndexPath:fromIndexPath toIndexPath:targetIndexPath];
    [self.tableView endUpdates];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testNavigationActionFired {
    STDNavigationTestViewController *viewController = [[STDNavigationTestViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.st_navigationController pushViewController:viewController animated:YES];
}

- (void)imageDownloadActionFired {
    STDownloadViewController *viewController = STDownloadViewController.new;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.st_navigationController pushViewController:viewController animated:YES];
}

- (void)imageCardActionFired {
    STDCardViewController *cardViewController = STDCardViewController.new;
    cardViewController.hidesBottomBarWhenPushed = YES;
    [self.st_navigationController pushViewController:cardViewController animated:YES];
}

- (void)imagePickerActionFired {
    STImagePickerController *imagePickerController = STImagePickerController.new;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)imageBlurActionFired {
    STDImageBlurViewController *imageBlurViewController = [[STDImageBlurViewController alloc] init];
    imageBlurViewController.hidesBottomBarWhenPushed = YES;
    [self.st_navigationController pushViewController:imageBlurViewController animated:YES];
}

- (void)textActionFired {
    STDTextViewController *textViewController = STDTextViewController.new;
    textViewController.hidesBottomBarWhenPushed = YES;
    [self.st_navigationController pushViewController:textViewController animated:YES];
}

- (void)linkActionFired {
    STDLinkViewController *linkViewController = STDLinkViewController.new;
    linkViewController.hidesBottomBarWhenPushed = YES;
    [self.st_navigationController pushViewController:linkViewController animated:YES];
}

- (void)notificationActionFired {
    NSMutableDictionary *notificationInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    [notificationInfo setValue:@"友情提醒" forKey:STNotificationViewTitleTextKey];
    [notificationInfo setValue:@"这是一条来自应用内部的提醒" forKey:STNotificationViewDetailTextKey];
    STNotificationView *notificationView = [STNotificationWindow notificationViewWithInfo:notificationInfo];
    [self.notificationWindow pushNotificationView:notificationView animated:YES];
}

- (void)webViewActionFired {
    STWebViewController *webViewController = [[STWebViewController alloc] initWithURLString:@"http://xstore.duapp.com"];
    [self.st_navigationController pushViewController:webViewController animated:YES];
}

- (void)frameVSBoundsActionFired {
    STDScrollViewController *scrollViewController = [[STDScrollViewController alloc] init];
    [self.st_navigationController pushViewController:scrollViewController animated:YES];
}

- (void)imagePickerController:(STImagePickerController *)picker didFinishPickingImageWithInfo:(NSDictionary *)info {
    NSArray *imageArray = [info valueForKey:@"data"];
    STIndicatorView *indicatorView = [[STIndicatorView alloc] initWithView:self.view];
    indicatorView.indicatorType = STIndicatorTypeText;
    indicatorView.blurEffectStyle = STBlurEffectStyleExtraLight;
    indicatorView.textLabel.text = @"完成选择照片";
    indicatorView.detailLabel.text = [NSString stringWithFormat:@"该次选择 %lld 张照片", (long long)imageArray.count];
    [indicatorView showAnimated:NO];
    [indicatorView hideAnimated:YES afterDelay:2.5];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(STImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (STNotificationWindow *)notificationWindow {
    if (!_notificationWindow) {
        _notificationWindow = [[STNotificationWindow alloc] init];
        _notificationWindow.notificationWindowDelegate = self;
        _notificationWindow.maximumNumberOfWindows = 3;
        _notificationWindow.displayDuration = 5;
    }
    return _notificationWindow;
}

- (void)allNoticationViewDismissed {
    self.notificationWindow = nil;
}

- (void)leftBarButtonItemAction:(id)sender {
    if (self.st_sideBarController.sideAppeared) {
        [self.st_sideBarController concealSideViewControllerAnimated:YES];
    } else {
        [self.st_sideBarController revealSideViewControllerAnimated:YES];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.st_navigationBarHidden = YES;
}

@end

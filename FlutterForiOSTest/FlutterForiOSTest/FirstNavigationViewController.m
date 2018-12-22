//
//  FirstNavigationViewController.m
//  FlutterForiOSTest
//
//  Created by 王鹏 on 2018/12/13.
//  Copyright © 2018年 王鹏. All rights reserved.
//

#import "FirstNavigationViewController.h"
#import "FirstFlutterViewController.h"
#import <Flutter/Flutter.h>

@interface FirstNavigationViewController ()

@end

@implementation FirstNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(handleButtonAction)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Press me" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:button];
}

- (void)handleButtonAction {
    FirstFlutterViewController* flutterViewController = [[FirstFlutterViewController alloc] init];
    [flutterViewController setInitialRoute:@"route1"];
    __weak __typeof(self) weakSelf = self;
    // 要与main.dart中一致
    NSString*channelName = @"com.pages.your/native_get";
    FlutterMethodChannel*messageChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:flutterViewController];
    [messageChannel setMethodCallHandler:^(FlutterMethodCall* _Nonnull call, FlutterResult  _Nonnull result) {
        // call.method 获取 flutter 给回到的方法名，要匹配到 channelName 对应的多个 发送方法名，一般需要判断区分
        // call.arguments 获取到 flutter 给到的参数，（比如跳转到另一个页面所需要参数）
        // result 是给flutter的回调， 该回调只能使用一次
        NSLog(@"flutter 给到我：\nmethod=%@ \narguments = %@",call.method,call.arguments);
        if([call.method isEqualToString:@"toNativeSomething"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"flutter回调" message:[NSString  stringWithFormat:@"%@",call.arguments] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            // 回调给flutter
            if(result) {
                result(@1000);
            }
        } else if([call.method isEqualToString:@"toNativePush"]) {
            //            ThirdViewController *testVC = [[ThirdViewController alloc] init];
            //            testVC.parames = call.arguments;
            //            [weakSelf.navigationController pushViewController:testVC animated:YES];
        } else if([call.method isEqualToString:@"toNativePop"]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [self.navigationController pushViewController:flutterViewController animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

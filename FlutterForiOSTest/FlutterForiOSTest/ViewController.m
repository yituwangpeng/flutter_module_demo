//
//  ViewController.m
//  FlutterForiOSTest
//
//  Created by 王鹏 on 2018/12/12.
//  Copyright © 2018年 王鹏. All rights reserved.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
    FlutterViewController* flutterViewController = [[FlutterViewController alloc] init];
    [flutterViewController setInitialRoute:@"route1"];
    [GeneratedPluginRegistrant registerWithRegistry:flutterViewController];
    
    // 要与main.dart中一致
    NSString *channelName = @"com.pages.your/native_get";
    FlutterMethodChannel *messageChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:flutterViewController];
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
                result(@4);
            }
        } else if([call.method isEqualToString:@"toNativeSomeArguments"]) {
            // 忽略
        } else if([call.method isEqualToString:@"toNativePop"]) {
            [flutterViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    // basicMessageChannel
    FlutterBasicMessageChannel *basicMessageChannel = [FlutterBasicMessageChannel messageChannelWithName:@"com.pages.your/getAsset"
                                                             binaryMessenger:flutterViewController
                                                                       codec:[FlutterStandardMessageCodec sharedInstance]];
    [basicMessageChannel setMessageHandler:^(id message, FlutterReply reply) {
        NSLog(@"message ==%@",message);
        UIImage *image = [UIImage imageNamed:@"image_empty_AddOn"];
        NSData *imagedata = UIImagePNGRepresentation(image);
        reply(imagedata);
    }];
    
    [self presentViewController:flutterViewController animated:false completion:nil];
}

@end

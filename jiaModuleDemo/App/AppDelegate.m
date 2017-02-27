//
//  AppDelegate.m
//  jiaModuleDemo
//
//  Created by wujunyang on 16/9/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "JiaCoreConfigManager.h"
#import "jiaDesignerConfigManager.h"

#import "JiaGT.h"
#import "JiaAnalytics.h"
#import "JiaShare.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//组件的粒度比模块的粒度小。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //JiaCore基础模块相关配置
    JiaCoreConfigManager *jiaCoreConfig=[JiaCoreConfigManager sharedInstance];
    jiaCoreConfig.recordlogger=YES;
    jiaCoreConfig.openDebug=NO;
    
    //jiaCoreConfig.openDebug=YES;//可以测试一把
    
    //jspatch热修复
    [self jspatchInstall];
    
    //设置模块jiaDesigner相关配置
    jiaDesignerConfigManager *jiaDesignerConfig=[jiaDesignerConfigManager sharedInstance];
    jiaDesignerConfig.prefixNetWorkUrl=@"http://private-iary-mock.com/";
    
    
    //设置个推模块的配置
    JiaGTConfigManager *gtConfig=[JiaGTConfigManager sharedInstance];
    gtConfig.jiaGTAppId=@"0uuwznWonIANoK07JeRWgAs";
    gtConfig.jiaGTAppKey=@"26LeO4stbrA7TeyMUJdXlx3";
    gtConfig.jiaGTAppSecret=@"2282vl0IwZd9KL3ZpDyoUL7";
    
    
    //友盟统计设置
    JiaAnalyticsConfigManager *jiaAnalyticsConfig=[JiaAnalyticsConfigManager sharedInstance];
    jiaAnalyticsConfig.analyticsAppKey=@"57e3f1cbe0f55a42080011ec";
    jiaAnalyticsConfig.analyticsChannelID=@"App Store";
    jiaAnalyticsConfig.analyticsLogEnabled=YES;
    
//    //要统计页面的前缀
    jiaAnalyticsConfig.prefixFilterArray=@[@"Jia"];
//    //不符合前缀 但也要被统计进来的页面
//    jiaAnalyticsConfig.fileterNameArray=@[@"defaultViewController",@"nativeViewController"];
//    //符合页面的前缀 但不要进行统计的页面
    jiaAnalyticsConfig.noFileterNameArray=@[@"JiaLoginViewController"];
    
    //开始AOP方式统计
    [JiaAnalyticsHelper jiaAnalyticsViewController];
    
    
    //友盟分享
    JiaShareConfigManager *jiaShareConfig=[JiaShareConfigManager sharedInstance];
    jiaShareConfig.shareAppKey=@"57e3f1cbe0f55a42080011ec";
    jiaShareConfig.shareLogEnabled=NO;
    //设置平台
    [jiaShareConfig setPlaform:JiaSocialPlatConfigType_Tencent appKey:@"100424468" appSecret:@"c7394704798a158208a74ab60104f0ba" redirectURL:@"http://www.umeng.com/social"];
    [jiaShareConfig setPlaform:JiaSocialPlatConfigType_Wechat appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://www.umeng.com/social"];
    [jiaShareConfig setPlaform:JiaSocialPlatConfigType_Sina appKey:@"3921700954" appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *vc = [[ViewController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = navc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


-(void)jspatchInstall {
    JiaCoreConfigManager *jiaCoreConfig=[JiaCoreConfigManager sharedInstance];
    ////    热更新内容（测试一把？）
    JiaPathchModel *sample=[[JiaPathchModel alloc]init];
    sample.patchId = @"patchId_sample1";
    sample.md5 = @"2cf1c6f6c5632dc21224bf42c698706b";
    sample.url = @"http://test.qshmall.net:9090/demo1.js";
    sample.ver = @"1";
    
    JiaPathchModel *sample1=[[JiaPathchModel alloc]init];
    sample1.patchId = @"patchId_sample2";
    sample1.md5 = @"e8a4eaeadce5a4598fb9a868e09c75fd";
    sample1.url = @"http://test.qshmall.net:9090/demo2.js";
    sample1.ver = @"1";
    
    jiaCoreConfig.jSPatchMutableArray=[@[sample,sample1] mutableCopy];

}



//Suspended 挂起 程序在后台不能执行代码。当挂起时，程序还是停留在内存中的，当系统内存低时，系统就把挂起的程序清除掉，为前台程序提供更多的内存。
//当将app挂起时先调用applicationWillResignActive，然后再调用applicationDidEnterBackground进入后台。
- (void)applicationWillResignActive:(UIApplication *)application {
    [super applicationWillResignActive:application];
    /*添加你自己的挂起前准备代码*/
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [super applicationDidEnterBackground:application];
}

//当重新从后台挂起状态激活，先调用applicationWillEnterForeground，然后调用applicationDidBecomeActive。注意如果是APP重新启动是不会调用这个代理方法的applicationWillEnterForeground。
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [super applicationWillEnterForeground:application];
    
//    针对部分用户处于挂起的状态时候，服务器下发了紧急bug热修复补丁，想让用户在APP重新回到激活状态，就能执行热修复，不需要重新启动app。真实的项目中，网络请求处理逻辑具体再说。
       [self jspatchInstall];
}

//已经变成激活状态。
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [super applicationDidBecomeActive:application];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [super applicationWillTerminate:application];
//    当程序将要退出是被调用，通常是用来保存数据和一些退出前的清理工作
}


#pragma mark 消息推送相关处理

/**
 *  @author wujunyang, 16-07-07 16:07:25
 *
 *  @brief  处理个推消息
 *
 *  @param NotificationMessage
 */
-(void)gtNotification:(NSDictionary *)NotificationMessage
{
    NSLog(@"%@",NotificationMessage[@"payload"]);
    NSLog(@"－－－－－接收到个推通知------");
}


/**
 *  @author wujunyang, 16-07-07 16:07:40
 *
 *  @brief  处理远程苹果通知
 *
 *  @param RemoteNotificationMessage
 */
-(void)receiveRemoteNotification:(NSDictionary *)RemoteNotificationMessage
{
    NSLog(@"%@",RemoteNotificationMessage[@"message"]);
    NSLog(@"－－－－－接收到苹果通知------");
}

/**
 *  @author wujunyang, 16-09-21 14:09:33
 *
 *  @brief 获得注册成功时的deviceToken 可以在里面做一些绑定操作
 *
 *  @param deviceToken <#deviceToken description#>
 */
-(void)receiveDeviceToken:(NSString *)deviceToken
{
    NSLog(@"－－－－－当前deviceToken：%@------",deviceToken);
}

@end

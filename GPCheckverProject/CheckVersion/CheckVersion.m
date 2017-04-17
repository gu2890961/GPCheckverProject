//
//  CheckVersion.m
//  GPCheckverProject
//
//  Created by apple on 2017/4/14.
//  Copyright © 2017年 gupeng. All rights reserved.
//
#define APP_ID @"947218515" //  945594471（车老板）  //  947218515（好修养）
#define APP_URL [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",APP_ID]
#import "CheckVersion.h"
#import "VersionUpdateView.h"

@interface CheckVersion ()

/** 升级提示 */
@property (nonatomic, copy) NSString *releaseNotes;
@property (nonatomic , copy) NSString *currentVersion;//当前app的版本
@property (nonatomic , copy) NSString *lastVersion;//App Store上的版本
@property (nonatomic , strong) VersionUpdateView *updateView;

@end

@implementation CheckVersion

+(instancetype)shareVersion {
    static CheckVersion *version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[CheckVersion alloc] init];
    });
    return version;
}

/**
 检查版本
 */
- (void)checkVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    self.currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:APP_URL]];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof (self) weakSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            NSLog(@"%@\n%@",dict.description,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSArray *dateArr = dict[@"results"];
            if (dateArr && dateArr.count) {
                //appStore里面的版本号
                NSDictionary *releaseInfo = [dateArr objectAtIndex:0];
                weakSelf.lastVersion = [releaseInfo objectForKey:@"version"];
                //当前版本小于AppStore的版本  比如1.2.1<1.2.2 提示更新
                if ([weakSelf version:weakSelf.currentVersion lessthan:weakSelf.lastVersion]) {
                    weakSelf.releaseNotes =  [releaseInfo objectForKey:@"releaseNotes"]?:@"1.修复已知bug\n2.优化app性能";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //弹出升级提示
                        [weakSelf showUpdateView];
                    });
                    
                }
            }
        }
        
    }];
    //开始请求
    [task resume];
}


/**
 弹窗提示
 */
- (void)showUpdateView {
    __weak typeof(self) weakSelf = self;
    [self.updateView setContent:self.releaseNotes andNewVersion:self.lastVersion sureButtonBlock:^(NSInteger index){
        if (index) {
            [weakSelf goToAppStoreUpdate];
        }
        else 
        weakSelf.updateView = nil;
    }];
    [self.updateView show];
}



#pragma mark - 懒加载

- (VersionUpdateView *)updateView {
    if (!_updateView) {
        _updateView = [[VersionUpdateView alloc] init];
    }
    return _updateView;
}

//比较数字相关字符串  1.0.1  和 1.0.2
- (BOOL)version:(NSString *)oldver lessthan:(NSString *)newver //系统api
{
    if ([oldver compare:newver options:NSNumericSearch] == NSOrderedAscending)
    {
        return YES;
    }
    return NO;
}

- (void)goToAppStoreUpdate
{
    NSString *urlStr = [self getAppStroeUrlForiPhone];
#ifdef __IPHONE_10_0
    NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:options completionHandler:^(BOOL success) {
        
    }];
#else
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
#endif
    
    [self.updateView dismiss];
    _updateView = nil;
}

-(NSString *)getAppStroeUrlForiPhone{
    return [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@",APP_ID];
}

@end


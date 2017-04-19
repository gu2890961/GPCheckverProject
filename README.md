# GPCheckverProject
检查app版本是否有更新

当你的 app 版本更新之后,一般情况下用户是不会知道的,只有等到 App Store 的图片上有一个大大的"1"的时候,强迫症的用户才会去看看有什么 app 更新了版本.那么这个时候,我们就需要在用户打开你的 app 的时候,提示用户:"我们的 app 已经更新版本啦,快点下载最新版本吧".那么该如何实现这个功能呢?今天就来说下我的实现方法.

> 先来一张demo效果图:

![Simulator Screen Shot 2017年4月17日 18.48.04.png](http://upload-images.jianshu.io/upload_images/1071689-36975befb20390ac.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 再来看看斗鱼TV更新提示

![斗鱼升级.png](http://upload-images.jianshu.io/upload_images/1071689-d2e7e7dec36bf394.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
###实现原理
```
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


``` 
> # 版本对比,返回YES才弹窗

```
//比较数字相关字符串  1.0.1  和 1.0.2
- (BOOL)version:(NSString *)oldver lessthan:(NSString *)newver //系统api
{
    if ([oldver compare:newver options:NSNumericSearch] == NSOrderedAscending)
    {
        return YES;
    }
    return NO;
}
```
> ### ***问：不是说苹果爸爸不允许我们在app中出现更新字样，否则会被拒？***
> #### 答：确实是这样的,但是只要在审核的时候不要让他看到不就好了,反正我的项目都是这样实现的，从来没有被拒过。那这样就要控制好版本了，就是当前版本和App Store身上的版本进行对比，低于就弹窗，也就是上面的代码返回YES才弹窗。没时间解释了，下班了~

## 写的比较匆忙，具体请看源码 ---  The End
[点我进入简书](http://www.jianshu.com/p/407c095a2492)

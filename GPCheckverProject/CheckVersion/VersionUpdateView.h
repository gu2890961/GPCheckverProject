//
//  VersionUpdateView.h
//  GPCheckverProject
//
//  Created by apple on 2017/4/14.
//  Copyright © 2017年 gupeng. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void(^SureButtonBlock)(NSInteger index);

@interface VersionUpdateView : UIView

-(void)setContent:(NSString *)content andNewVersion:(NSString *)newVersion sureButtonBlock:(SureButtonBlock)sureBlock;
- (void)show;
- (void)dismiss;
@end

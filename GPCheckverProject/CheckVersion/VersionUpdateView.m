//
//  VersionUpdateView.m
//  GPCheckverProject
//
//  Created by apple on 2017/4/14.
//  Copyright © 2017年 gupeng. All rights reserved.
//
#define appWindow [UIApplication sharedApplication].keyWindow
#define windowScal [UIScreen mainScreen].scale
#import "VersionUpdateView.h"

@interface VersionUpdateView ()
{
    SureButtonBlock sureBlock;
}
/** 背景蒙层 */
@property (nonatomic, strong) UIView *blackbgView;
/** 背景试图 */
@property (nonatomic, strong) UIView *backgroundView;
/** 更新内容 */
@property (nonatomic, copy) NSString *content;
/** 新版本 */
@property (nonatomic, copy) NSString *theVersion;
/** 顶部图 */
@property (nonatomic, strong) UIImageView *headImageView;
/** scrollview */
@property (nonatomic , strong) UIScrollView *backScrollView;
/** 内容label*/
@property (nonatomic , strong) UILabel *contentLabel;
/** 确定更新按钮 */
@property (nonatomic , strong) UIButton *sureButton;
/** 关闭按钮 */
@property (nonatomic , strong) UIButton *closeButton;
@end

@implementation VersionUpdateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)setContent:(NSString *)content andNewVersion:(NSString *)newVersion sureButtonBlock:(SureButtonBlock)sureBlock1 {
    if (sureBlock1) {
        sureBlock = sureBlock1;
    }
    _content = content;
    _theVersion = newVersion;
    NSAttributedString *str = [self attributedStrWith:[NSString stringWithFormat:@"%02u%%",arc4random()%9+80] newVersion:[NSString stringWithFormat:@"V%@",newVersion] content:content];
    CGRect labelFrame = CGRectMake(10, 0, CGRectGetWidth(_backScrollView.frame)-20, 0);
    CGFloat height = [str boundingRectWithSize:CGSizeMake(CGRectGetWidth(labelFrame), 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height+10;
    labelFrame.size.height = height;
    _backScrollView.contentSize = CGSizeMake(_backScrollView.frame.size.width, height);
    _contentLabel.frame = labelFrame;
    _contentLabel.attributedText = str;
}

//试图
- (void)initUI {
    self.frame = appWindow.bounds;
    self.blackbgView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.blackbgView];
    self.blackbgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self addSubview:self.backgroundView];
}
//显示
- (void)show {
    [appWindow addSubview:self];
    self.blackbgView.alpha = 1.0;
    self.alpha = 1.0;
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    //    [animation setDelegate:self];
    animation.values = @[@(M_PI/64),@(-M_PI/64),@(M_PI/64),@(0)];
    animation.duration = 0.5;
    [animation setKeyPath:@"transform.rotation"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.backgroundView.layer addAnimation:animation forKey:@"shake"];
}
//隐藏
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.blackbgView.alpha = 0.0;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


#pragma mark - 懒加载

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appWindow.bounds.size.width-30*windowScal, appWindow.bounds.size.width+80)];
        _backgroundView.center = self.center;
        [_backgroundView addSubview:self.headImageView];
        _headImageView.frame = CGRectMake(0, 0, CGRectGetWidth(_backgroundView.frame), 150);
        //去掉图片的圆角
        UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImageView.frame)-5, CGRectGetWidth(_backgroundView.frame), 10)];
        theView.backgroundColor = [UIColor whiteColor];
        [_backgroundView addSubview:theView];
        //关闭按钮
        [_backgroundView addSubview:self.closeButton];
        _closeButton.frame = CGRectMake((CGRectGetWidth(_backgroundView.frame)-40)/2.0, CGRectGetHeight(_backgroundView.frame)-10-40, 40, 40);
        //更新按钮试图
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_closeButton.frame)-60-10, CGRectGetWidth(_backgroundView.frame), 60)];
        buttonView.backgroundColor = [UIColor whiteColor];
        [_backgroundView addSubview:buttonView];
        buttonView.layer.cornerRadius = 5;
        
        [buttonView addSubview:self.sureButton];
        _sureButton.frame = CGRectMake(15, (CGRectGetHeight(buttonView.frame)-35)/2.0, CGRectGetWidth(buttonView.frame)-30, 35);
        _sureButton.layer.cornerRadius = _sureButton.frame.size.height/2.0;
        
        [_backgroundView addSubview:self.backScrollView];
        _backScrollView.frame = CGRectMake(0, CGRectGetMaxY(theView.frame), CGRectGetWidth(_backgroundView.frame), CGRectGetMinY(buttonView.frame)-CGRectGetMaxY(theView.frame)+5);
        
    }
    return _backgroundView;
}

- (UIScrollView *)backScrollView {
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _backScrollView.backgroundColor = [UIColor whiteColor];
        [_backScrollView addSubview:_contentLabel];
    }
    return _backScrollView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headImage"]];
    }
    return _headImageView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sureButton setTitle:@"立即更新" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton setBackgroundColor:[UIColor orangeColor]];
        [_sureButton addTarget:self action:@selector(sureButtonClose) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_closeButton setImage:[UIImage imageNamed:@"image_close_30x30_"] forState:UIControlStateNormal];
        _closeButton.tintColor = [UIColor whiteColor];
        [_closeButton addTarget:self action:@selector(closeButtonClose) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark - action

- (void)sureButtonClose {
    if (sureBlock) {
        sureBlock(1);
    }
}

- (void)closeButtonClose {
    if (sureBlock) {
        sureBlock(0);
    }
    [self dismiss];
}



- (NSAttributedString *)attributedStrWith:(NSString *)user newVersion:(NSString *)newVersion content:(NSString *)content {
    NSString *theStr = [NSString stringWithFormat:@"%@的用户正在使用最新版本 %@\n%@",user,newVersion,content];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:theStr];
    [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1.0]} range:NSMakeRange(0, theStr.length)];
    [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor orangeColor]} range:NSMakeRange(0, user.length)];
    [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor orangeColor]} range:[theStr rangeOfString:newVersion]];
    //行间距
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, theStr.length)];
    return str;
}

- (void)dealloc {
    NSLog(@"delloc");
}

@end

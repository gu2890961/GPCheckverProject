//
//  ViewController.m
//  GPCheckverProject
//
//  Created by apple on 2017/4/14.
//  Copyright © 2017年 gupeng. All rights reserved.
//

#import "ViewController.h"
#import "CheckVersion.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(test)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    button.center = self.view.center;
    [self.view addSubview:button];
}

- (void)test {
    CheckVersion *check = [CheckVersion shareVersion];
    [check checkVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

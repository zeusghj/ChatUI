//
//  MainViewController.m
//  ChatUI
//
//  Created by 郭洪军 on 9/14/16.
//  Copyright © 2016 Guo Hongjun. All rights reserved.
//

#import "MainViewController.h"
#import "JY_ChatRoomController.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem.title = @"";
    
    UIButton* testBtn = [[UIButton alloc] init];
    [testBtn setTitle:@"测试" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    
    [testBtn makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
    }];
}

- (void)test:(id)sender {
    JY_ChatRoomController* chatController = [[JY_ChatRoomController alloc] init];
    [self.navigationController pushViewController:chatController animated:YES];
}

@end

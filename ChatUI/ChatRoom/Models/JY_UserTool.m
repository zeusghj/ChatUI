//
//  JY_UserTool.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 9/5/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import "JY_UserTool.h"
#import "JY_UserModel.h"

@implementation JY_UserTool

+ (instancetype)shareInstance
{
    static JY_UserTool *userTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userTool = [self new];
    });
    return userTool;
}

- (JY_UserModel *)userModel
{
    JY_UserModel *model = [[JY_UserModel alloc] init];
    model.icon = @"icon1.jpg";
    model.name = @"Dscore";
    model.weiXinNumber = @"Fronxe";
    model.qrCode = @"";
    model.address = @"北京市 海淀区";
    model.sex = @"男";
    model.area = @"阿拉伯联合酋长国 迪拜";
    model.signature = @"技术无法使其变得更便宜的唯一东西，就是品牌......";
    model.userId = @"000000";
    model.circleBgImage = @"IMG_1208.JPG";
    return model;
}

#pragma mark - modify User information
+ (BOOL)modifyHeadICon:(NSString *)icon
{
    //    DS_UserTool *tool = [DS_UserTool shareInstance];
    return NO;
}

+ (BOOL)modifyUserName:(NSString *)userName
{
    return NO;
}

+ (BOOL)modifyAddress:(NSString *)address
{
    return NO;
}

+ (BOOL)modifySex:(NSString *)sex
{
    return NO;
}

+ (BOOL)modifyArea:(NSString *)area
{
    return NO;
}

+ (BOOL)modifySignature:(NSString *)signature
{
    return NO;
}

@end

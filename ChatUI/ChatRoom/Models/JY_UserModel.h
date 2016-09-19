//
//  JY_UserModel.h
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 9/5/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JY_UserModel : NSObject

//头像
@property (nonatomic,copy)NSString *icon;
//名字
@property (nonatomic,copy)NSString *name;
//微信号
@property (nonatomic,copy)NSString *weiXinNumber;
//我的二维码
@property (nonatomic,copy)NSString *qrCode;
//我的地址
@property (nonatomic,copy)NSString *address;
//性别
@property (nonatomic,copy)NSString *sex;
//地区
@property (nonatomic,copy)NSString *area;
//个性签名
@property (nonatomic,copy)NSString *signature;
//userId
@property (nonatomic,copy)NSString *userId;
//朋友圈背景色
@property (nonatomic,copy)NSString *circleBgImage;

@end

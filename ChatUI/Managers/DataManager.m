//
//  DataManager.m
//  ChatUI
//
//  Created by 郭洪军 on 9/19/16.
//  Copyright © 2016 Guo Hongjun. All rights reserved.
//

#import "DataManager.h"

@implementation DMTarget
@end

@implementation DataManager

+ (instancetype)getInstance {
    static DataManager* sharedInstance = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        if (!sharedInstance) {
            sharedInstance = [[DataManager alloc] init];
            sharedInstance.isVoicePlaying = NO;
        }
    });
    return sharedInstance;
}

@end

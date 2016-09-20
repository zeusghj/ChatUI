//
//  NSString+JYExtensions.m
//  ChatUI
//
//  Created by 郭洪军 on 9/19/16.
//  Copyright © 2016 Guo Hongjun. All rights reserved.
//

#import "NSString+JYExtensions.h"

@implementation NSString (JYExtensions)

- (BOOL)jy_isSpace {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    if ([[self stringByTrimmingCharactersInSet: set] length] == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)jy_containsString:(NSString *)string {
    if ([self rangeOfString:string].location == NSNotFound) {
        return NO;
    }
    return YES;
}

@end

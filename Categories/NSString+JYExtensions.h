//
//  NSString+JYExtensions.h
//  ChatUI
//
//  Created by 郭洪军 on 9/19/16.
//  Copyright © 2016 Guo Hongjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JYExtensions)

/**
 *  是否是空格
 */
- (BOOL)jy_isSpace;

/**
 *  是否包含字符串
 *
 *  @param     string
 */
- (BOOL)jy_containsString:(NSString *)string;

@end

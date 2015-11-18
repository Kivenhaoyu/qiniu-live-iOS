//
//  Help.m
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/9.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "Help.h"

#import <CommonCrypto/CommonDigest.h>

@implementation Help

+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

+ (NSString *)base64StringFromText:(NSString *)text
{
    NSData* originData = [text dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return encodeResult;
}

+ (NSString *)textFromBase64String:(NSString *)base64
{
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    
    NSString* decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
    
    return decodeStr;
}


+ (NSString *)transformAccessToken:(NSString *)sessionId;
{
    NSDate * nowDate = [NSDate date];
    NSString * timeString =  [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
    NSString * md5Token = [Help md5HexDigest:[NSString stringWithFormat:@"%@:%@:%@",sessionId,timeString,sessionId]];
    NSString * accessToken = [NSString stringWithFormat:@"%@:%@",md5Token,[Help base64StringFromText:timeString]];
    return accessToken;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end

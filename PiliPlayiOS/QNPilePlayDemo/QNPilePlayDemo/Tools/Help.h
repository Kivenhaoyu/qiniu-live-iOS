//
//  Help.h
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/9.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Help : NSObject

/**
 *  md5加密
 *
 *  @param input 内容
 *
 *  @return md5加密结果
 */

+ (NSString *)md5HexDigest:(NSString*)input;

/******************************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64StringFromText:(NSString *)text;

/******************************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 ******************************************************************************/
+ (NSString *)textFromBase64String:(NSString *)base64;

/**
 *  生成accessToken
 */

+ (NSString *)transformAccessToken:(NSString *)sessionId;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

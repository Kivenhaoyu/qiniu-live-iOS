//
//  UserInfoClass.h
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/4.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoClass : NSObject
@property(nonatomic,assign)BOOL isLogin;
#pragma mark 用户信息

@property (nonatomic, strong) NSString * userPhone;
@property (nonatomic, strong) NSString * passWord;
@property (nonatomic, strong) NSString * sessionID;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * emailAddress;

+(instancetype)sheardUserInfo;

- (void)setUserInfoLogin:(NSString *)userPhone
            withPassWord:(NSString *)passWord
            withUserName:(NSString *)userName
        withEmailAddress:(NSString *)emailAddress
           withSessionID:(NSString *)sessionID;

- (void)userLogout;

@end

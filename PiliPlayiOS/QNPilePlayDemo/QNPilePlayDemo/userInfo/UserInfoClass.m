//
//  UserInfoClass.m
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/4.
//  Copyright © 2015年   何舒. All rights reserved.
//

#define USER @"UserInfoClass"

#import "UserInfoClass.h"

static UserInfoClass *_userInfo=nil;

@implementation UserInfoClass
+ (instancetype)sheardUserInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _userInfo = [[UserInfoClass alloc] init];
        NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:USER];
        NSDictionary *dict;
        if(!data)
            return ;
        dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        _userInfo.sessionID=[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
        _userInfo.userName=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        _userInfo.emailAddress=[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
        
        
        NSString *userPhone=dict[@"userPhone"];
        
        if(userPhone)
        {
            [_userInfo setValuesForKeysWithDictionary:dict];
            _userInfo.isLogin=YES;
        }else
        {
            _userInfo.isLogin=NO;
        }
        
    });
    return _userInfo;
}

- (void)setUserInfoLogin:(NSString *)userPhone
            withPassWord:(NSString *)passWord
            withUserName:(NSString *)userName
        withEmailAddress:(NSString *)emailAddress
           withSessionID:(NSString *)sessionID
{
    NSDictionary * dict = @{@"userPhone":userPhone,
                            @"passWord":passWord,};
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:jsonData forKey:USER];
    [[NSUserDefaults standardUserDefaults] synchronize];
#pragma markfabuCount
    if (sessionID) {
        [[NSUserDefaults standardUserDefaults] setObject:sessionID forKey:@"sessionID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userName  forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (emailAddress) {
        [[NSUserDefaults standardUserDefaults] setObject:emailAddress forKey:@"emailAddress"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.isLogin=YES;
    [self setValuesForKeysWithDictionary:dict];
    self.sessionID = sessionID;
    self.userName = userName;
    self.emailAddress = emailAddress;
}

- (void)userLogout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sessionID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emailAddress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.isLogin=NO;
    
}

@end

//
//  LoginVC.m
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/4.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "LoginVC.h"
#import "RegistVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.loginBtn.layer.cornerRadius = 10.0;
    self.registBtn.layer.cornerRadius = 10.0;
    
}

- (IBAction)LoginAction:(id)sender
{
    if (!self.userPhoneTextField.text) {
        [SVProgressHUD showAlterMessage:@"请输入电话号码"];
    }
    if (!self.passWordTextField.text) {
        [SVProgressHUD showAlterMessage:@"请输入密码"];
    }
    NSString * urlString = @"login";
    NSDictionary * dic = @{@"mobile":self.userPhoneTextField.text,@"pwd":self.passWordTextField.text};
    [HTTPRequestPost hTTPRequest_PostpostBody:dic andUrl:urlString andSucceed:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        [[UserInfoClass sheardUserInfo] setUserInfoLogin:self.userPhoneTextField.text withPassWord:self.userPhoneTextField.text withUserName:responseObject[@"userName"] withEmailAddress:nil withSessionID:responseObject[@"sessionId"]];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } andISstatus:NO];
}

- (IBAction)registAction:(id)sender
{
    RegistVC * registVC = [[RegistVC alloc] init];
    [self presentViewController:registVC animated:YES completion:^{}];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

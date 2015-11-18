//
//  RegistVC.m
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/4.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "RegistVC.h"

@interface RegistVC ()

@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.registBtn.layer.cornerRadius = 10.0;
}

- (IBAction)registAction:(id)sender
{
    if (isStringEmpty(self.userPhoneTextFild.text)) {
        [SVProgressHUD showAlterMessage:@"请输入电话号码"];
        return;
    }
    if (isStringEmpty(self.userNameTextFild.text)) {
        [SVProgressHUD showAlterMessage:@"请输入姓名"];
        return;
    }
    if (isStringEmpty(self.emailAddressTextField.text)) {
        [SVProgressHUD showAlterMessage:@"请输入邮箱"];
        return;
    }
    if (isStringEmpty(self.passWordTextField.text)) {
        [SVProgressHUD showAlterMessage:@"请输入密码"];
        return;
    }
    NSDictionary * dic = @{@"mobile":self.userPhoneTextFild.text,
                       @"pwd":self.passWordTextField.text,
                       @"name":self.userNameTextFild.text,
                       @"email":self.emailAddressTextField.text};
    NSString * postUrl = @"signup";
//    NSString * postBody = [[NSString alloc]initWithFormat:@"mobile=%@&pwd=%@&name=%@&email=%@",self.userPhoneTextFild.text,self.passWordTextField.text,self.userNameTextFild.text,self.emailAddressTextField.text];
//    NSData * postData = [postBody dataUsingEncoding: NSUTF8StringEncoding];

    [HTTPRequestPost hTTPRequest_PostpostBody:dic andUrl:postUrl andSucceed:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        [[UserInfoClass sheardUserInfo] setUserInfoLogin:self.userPhoneTextFild.text withPassWord:self.passWordTextField.text withUserName:self.userNameTextFild.text   withEmailAddress:self.emailAddressTextField.text withSessionID:nil];
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
    } andISstatus:NO];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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

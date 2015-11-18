//
//  QNPiliChoseVC.m
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/10.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "QNPiliChoseVC.h"
#import "QNPiliCameraVC.h"

@interface QNPiliChoseVC ()<UITextFieldDelegate,UIActionSheetDelegate>

@property (nonatomic, assign) NSInteger  quarlityNum;
@property (nonatomic, assign) NSInteger  orientationNum;
@property (nonatomic, strong) NSDictionary * dic;

@end

@implementation QNPiliChoseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"配置";
    // Do any additional setup after loading the view from its nib.
    [self getStream];
    self.choseOrientationBtn.layer.cornerRadius = 10;
    
    self.choseQuarlityBtn.layer.cornerRadius = 10;
    
    self.starBtn.layer.cornerRadius = 10;
}

- (void)getStream
{
    NSDictionary * dic = @{@"sessionId":[UserInfoClass sheardUserInfo].sessionID,@"accessToken":[Help transformAccessToken:[UserInfoClass sheardUserInfo].sessionID]};
    [HTTPRequestPost hTTPRequest_PostpostBody:dic andUrl:@"get/stream" andSucceed:^(NSURLSessionDataTask *task, id responseObject) {
        self.dic = responseObject;
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
    } andISstatus:NO];
}

- (void)checkStream
{
    NSDictionary * dic = @{@"sessionId":[UserInfoClass sheardUserInfo].sessionID,@"accessToken":[Help transformAccessToken:[UserInfoClass sheardUserInfo].sessionID],@"streamId":self.dic[@"streamId"]};
    [HTTPRequestPost hTTPRequest_PostpostBody:dic andUrl:@"status/stream" andSucceed:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showAlterMessage:responseObject[@"desc"]];
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
    } andISstatus:NO];
}

- (IBAction)choseQuarlityAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"清晰度选择"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"low1",@"low2",@"low3",@"Medium1",@"Medium2",@"Medium3",@"High1",@"High2",@"High3",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 1000;
    [actionSheet showInView:self.view];
}

- (IBAction)choseOrientationAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"屏幕方向"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"横屏",@"竖屏",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 1001;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag%2) {
        //屏幕方向
        self.orientationNum = (buttonIndex == 2)?0:buttonIndex;
        [self.choseOrientationBtn setTitle:[actionSheet buttonTitleAtIndex:buttonIndex]forState:UIControlStateNormal];
    }else
    {
        //清晰度
        self.quarlityNum = (buttonIndex == 9)?0:buttonIndex;
        [self.choseQuarlityBtn setTitle:[actionSheet buttonTitleAtIndex:buttonIndex]forState:UIControlStateNormal];
    }
    
}

- (IBAction)startAction:(id)sender
{
    [self checkStream];
    QNPiliCameraVC * cameraVC = [[QNPiliCameraVC alloc] initWithSharpness:self.quarlityNum withOrientation:self.orientationNum withStreamDic:self.dic withTitle:self.vedioTitleTf.text];
//    [self.navigationController pushViewController:cameraVC animated:YES];
    [self presentViewController:cameraVC animated:YES completion:Nil];
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

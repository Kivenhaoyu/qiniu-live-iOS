//
//  QNPiliUserVC.m
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/10.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "QNPiliUserVC.h"
#import "QNPiliMicrophoneVC.h"
#import "QNPiliChoseVC.h"
#import "QNPiliUserListVC.h"

@interface QNPiliUserVC ()

@end

@implementation QNPiliUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.videoBtn.layer.cornerRadius = 10;
    
    self.videoListBtn.layer.cornerRadius = 10;
    
    self.audioBtn.layer.cornerRadius = 10;
    
    self.userName.text = [UserInfoClass sheardUserInfo].userName;
}

- (IBAction)videoListAction:(id)sender
{
    QNPiliUserListVC * userListVC = [[QNPiliUserListVC alloc] init];
    [self.navigationController pushViewController:userListVC animated:YES];
}

- (IBAction)videoAction:(id)sender
{
    QNPiliChoseVC * choseVC = [[QNPiliChoseVC alloc] init];
    [self.navigationController pushViewController:choseVC animated:YES];
}

- (IBAction)audioAction:(id)sender
{
    QNPiliMicrophoneVC * microVC = [[QNPiliMicrophoneVC alloc] init];
    [self.navigationController pushViewController:microVC animated:YES];
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

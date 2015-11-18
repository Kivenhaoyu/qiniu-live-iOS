//
//  QNPiliPlayBackVC.m
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/6.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "QNPiliPlayBackVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface QNPiliPlayBackVC ()
//视频播放器
@property (strong, nonatomic) MPMoviePlayerController *player;
@property (nonatomic, strong) NSDictionary * dic;
@property (nonatomic, strong) NSDictionary * videoDic;

@end

@implementation QNPiliPlayBackVC

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.dic = dic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.dic[@"title"];
    self.playBtn.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    NSDictionary * dic = @{@"sessionId":[UserInfoClass sheardUserInfo].sessionID,
                           @"accessToken":[Help transformAccessToken:[UserInfoClass sheardUserInfo].sessionID],
                           @"publishId":self.dic[@"publishId"]};
    [HTTPRequestPost hTTPRequest_PostpostBody:dic andUrl:@"get/play/video" andSucceed:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        self.videoDic = responseObject;
        [self playerSet:responseObject[@"playUrls"][@"ORIGIN"]];
        [self.player play];
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
    } andISstatus:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.player stop];
    self.playBtn.hidden = NO;
    [self.player.view removeFromSuperview];
}

- (IBAction)playAction:(id)sender
{
    
    self.playBtn.hidden = YES;
    [self.player play];
}

- (void)playerSet:(NSString *)url
{
    self.player = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:url]];
    self.player.shouldAutoplay = NO;
    //1设置播放器的大小 self.videoDic[@"orientation"] 0为横屏，1为竖屏
    if (self.videoDic[@"orientation"] == 1) {
    }
    [self.player.view setFrame:self.view.frame];
    
    
    self.player.controlStyle = MPMovieControlStyleEmbedded;
    
    //2将播放器视图添加到根视图
    [self.view addSubview:self.player.view];
    [self.view bringSubviewToFront:self.playBtn];
    //2 监听播放完成
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishedPlay) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(thumImageGet:)
                                                 name:MPMoviePlayerThumbnailImageRequestDidFinishNotification   //视频缩略图截取成功时调用
                                               object:nil];
}
//通知视频播放完成
- (void)finishedPlay
{
    [self.player stop];
    self.playBtn.hidden = NO;
    //    [self.player.view removeFromSuperview];
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

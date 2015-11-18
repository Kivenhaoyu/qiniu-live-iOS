//
//  QNPiliCameraVC.m
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/3.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "QNPiliCameraVC.h"
#import <PLCameraStreamingKit/PLCameraStreamingKit.h>
#import "Reachability.h"

const char *stateNames[] = {
    "Unknow",
    "Connecting",
    "Connected",
    "Disconnecting"
    "Disconnected",
    "Error"
};

const char *networkStatus[] = {
    "Not Reachable",
    "Reachable via WiFi",
    "Reachable via CELL"
};

@interface QNPiliCameraVC ()<
PLCameraStreamingSessionDelegate,
PLStreamingSendingBufferDelegate
>
@property (nonatomic, assign) NSInteger orientationNum;
@property (nonatomic, strong) NSString * quality;
@property (nonatomic, strong) PLCameraStreamingSession  *session;
@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) NSDictionary *streamDic;
@property (nonatomic, strong) NSString * streamName;
@property (nonatomic, strong) NSDictionary * startStreamDic;
@property (nonatomic, assign) BOOL isStart;//第一次点击开始，发出请求
@property (nonatomic, assign) NSInteger qualityNum;


@end

@implementation QNPiliCameraVC

- (instancetype)initWithSharpness:(NSInteger)qualityNum
                  withOrientation:(NSInteger)orientationNum
                    withStreamDic:(NSDictionary *)streamDic
                        withTitle:(NSString *)streamName
{
    self = [super init];
    
    if (self) {
        self.streamDic = streamDic;
        self.streamName = streamName;
        self.orientationNum = orientationNum;
        self.qualityNum = qualityNum;
        NSString * qualityString;
        switch (qualityNum) {
            case 0:
                qualityString = kPLVideoStreamingQualityLow1;
                break;
            case 1:
                qualityString = kPLVideoStreamingQualityLow2;
                break;
            case 2:
                qualityString = kPLVideoStreamingQualityLow3;
                break;
            case 3:
                qualityString = kPLVideoStreamingQualityMedium1;
                break;
            case 4:
                qualityString = kPLVideoStreamingQualityMedium2;
                break;
            case 5:
                qualityString = kPLVideoStreamingQualityMedium3;
                break;
            case 6:
                qualityString = kPLVideoStreamingQualityHigh1;
                break;
            case 7:
                qualityString = kPLVideoStreamingQualityHigh2;
                break;
            case 8:
                qualityString = kPLVideoStreamingQualityHigh3;
                break;
                
            default:
                qualityString = kPLVideoStreamingQualityLow2;
                self.qualityNum =1;
                break;
        }
        self.quality = qualityString;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"视频录播";
    
    
    if (!self.orientationNum) {
        self.backBtn1.transform=CGAffineTransformMakeRotation(M_PI/2);
        self.toggleCameraBtn1.transform=CGAffineTransformMakeRotation(M_PI/2);
        self.torchBtn1.transform=CGAffineTransformMakeRotation(M_PI/2);
        self.muteBtn1.transform=CGAffineTransformMakeRotation(M_PI/2);
        self.actionBtn1.transform=CGAffineTransformMakeRotation(M_PI/2);
        self.view = self.rightView;
    }
    
    self.sessionQueue = dispatch_queue_create("pili.queue.streaming", DISPATCH_QUEUE_SERIAL);
    
    //网络状态监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    //    NSDictionary *streamJson = @{@"publishSecurity": @"dynamic",
    //                                @"hub": @"jinxinxin",
    //
    //                                @"title": @"56370fd1d409d29ff00004b4",
    //                                @"publishKey": @"4cc2967cfc182f22",
    //                                @"disabled":@(NO),
    //                                @"hosts":
    //  @{@"live":@{@"http": @"pili-live-hls.live.golanghome.com", @"hdl": @"pili-live-hdl.live.golanghome.com", @"hls": @"pili-live-hls.live.golanghome.com", @"rtmp": @"pili-live-rtmp.live.golanghome.com"}, @"playback": @{@"http": @"pili-playback.live.golanghome.com", @"hls": @"pili-playback.live.golanghome.com"}, @"play": @{@"http": @"pili-live-hls.live.golanghome.com", @"rtmp": @"pili-live-rtmp.live.golanghome.com"}, @"publish": @{@"rtmp": @"pili-publish.live.golanghome.com"}}, @"updatedAt": @"2015-11-02T07:25:05.627Z", @"id": @"z1.jinxinxin.56370fd1d409d29ff00004b4", @"createdAt": @"2015-11-02T07:25:05.627Z"};
    //    NSDictionary * dic = [Help dictionaryWithJsonString:self.streamDic[@"stream"]];
    //    //    [dic setValue:@"disabled" forKey:@(NO)];
    //        NSDictionary *streamJson = @{@"publishSecurity": @"static",
    //                                     @"hub": @"jinxinxin",
    //                                     @"title": @"56370fd1d409d29ff00004b4",
    //                                     @"publishKey": @"cb45f6eed74ea93a",
    //                                     @"disabled":@(NO),
    //                                     @"hosts":
    //                                         @{@"live":@{@"http": @"pili-live-hls.live.golanghome.com",
    //                                                     @"hdl": @"pili-live-hdl.live.golanghome.com",
    //                                                     @"hls": @"pili-live-hls.live.golanghome.com",
    //                                                     @"rtmp": @"pili-live-rtmp.live.golanghome.com"},
    //                                           @"playback":@{@"http": @"pili-playback.live.golanghome.com",
    //                                                         @"hls": @"pili-playback.live.golanghome.com"},
    //                                           @"publish": @{@"rtmp": @"pili-publish.live.golanghome.com"}
    //                                           },
    //                                     @"updatedAt": @"2015-11-02T07:25:05.627Z+08:00",
    //                                     @"id": @"z1.jinxinxin.56370fd1d409d29ff00004b4",
    //                                     @"createdAt": @"2015-11-02T07:25:05.627Z+08:00"};
    //        PLStream *stream = [PLStream streamWithJSON:streamJson];
    
    PLStream *stream = [PLStream streamWithJSON:[Help dictionaryWithJsonString:self.streamDic[@"stream"]]];
    void (^permissionBlock)(void) = ^{
        dispatch_async(self.sessionQueue, ^{
            // 视频编码配置
            
            CGSize videoSize;
            if (self.orientationNum) {
                videoSize = CGSizeMake(kDeviceWidth, KDeviceHeight);
            }else
            {
                videoSize = CGSizeMake(KDeviceHeight,kDeviceWidth);
            }
            PLVideoStreamingConfiguration *videoConfiguration = [PLVideoStreamingConfiguration configurationWithUserDefineDimension:videoSize videoQuality:self.quality];
            // 音频编码配置
            PLAudioStreamingConfiguration *audioConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
            
            // 推流 session
            self.session = [[PLCameraStreamingSession alloc] initWithVideoConfiguration:videoConfiguration
                                                                     audioConfiguration:audioConfiguration
                                                                                 stream:stream
                                                                       videoOrientation:AVCaptureVideoOrientationPortrait];
            self.session.delegate = self;
            self.session.bufferDelegate = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIView * uiview = [[UIView alloc] init];
                if (!self.orientationNum) {
                uiview.transform = CGAffineTransformMakeRotation(M_PI/2);
                self.session.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                }
                uiview.frame =self.view.frame;
                self.session.previewView = uiview;
                
                self.view.backgroundColor = [UIColor clearColor];
                [self.view addSubview:self.session.previewView];
                if (self.orientationNum) {
                    //竖屏
                    [self.view bringSubviewToFront:self.backBtn];
                    [self.view bringSubviewToFront:self.toggleCameraBtn];
                    [self.view bringSubviewToFront:self.torchBtn];
                    [self.view bringSubviewToFront:self.muteBtn];
                    [self.view bringSubviewToFront:self.actionBtn];
                }else{
                    //横屏
                    [self.view bringSubviewToFront:self.backBtn1];
                    [self.view bringSubviewToFront:self.toggleCameraBtn1];
                    [self.view bringSubviewToFront:self.torchBtn1];
                    [self.view bringSubviewToFront:self.muteBtn1];
                    [self.view bringSubviewToFront:self.actionBtn1];
                }
            });
        });
    };
    
    void (^noAccessBlock)(void) = ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Access", nil)
                                                            message:NSLocalizedString(@"!", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    };
    
    switch ([PLCameraStreamingSession cameraAuthorizationStatus]) {
        case PLAuthorizationStatusAuthorized:
            permissionBlock();
            break;
        case PLAuthorizationStatusNotDetermined: {
            [PLCameraStreamingSession requestCameraAccessWithCompletionHandler:^(BOOL granted) {
                granted ? permissionBlock() : noAccessBlock();
            }];
        }
            break;
        default:
            noAccessBlock();
            break;
    }
}

- (void)startStream
{
    NSDictionary * dic = @{@"sessionId":[UserInfoClass sheardUserInfo].sessionID,
                           @"accessToken":[Help transformAccessToken:[UserInfoClass sheardUserInfo].sessionID],
                           @"streamId":self.streamDic[@"streamId"],
                           @"streamTitle":self.streamName,
                           @"streamQuality":[NSString stringWithFormat:@"%d",self.qualityNum],
                           @"streamOrientation":[NSString stringWithFormat:@"%d",self.orientationNum]};
    [HTTPRequestPost hTTPRequest_PostpostBody:dic andUrl:@"start/publish" andSucceed:^(NSURLSessionDataTask *task, id responseObject) {
        self.startStreamDic = responseObject;
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
    } andISstatus:NO];
}

- (IBAction)backAction:(id)sender
{
    if(self.isStart){
        NSDictionary * dic = @{@"sessionId":[UserInfoClass sheardUserInfo].sessionID,@"accessToken":[Help transformAccessToken:[UserInfoClass sheardUserInfo].sessionID],@"publishId":self.startStreamDic[@"publishId"]};
        [HTTPRequestPost hTTPRequest_PostpostBody:dic andUrl:@"stop/publish" andSucceed:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD showAlterMessage:responseObject[@"desc"]];
            [self.session stop];
        } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        } andISstatus:NO];
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    dispatch_sync(self.sessionQueue, ^{
        [self.session destroy];
    });
    self.session = nil;
    self.sessionQueue = nil;
}

#pragma mark - Notification Handler

- (void)reachabilityChanged:(NSNotification *)notif{
    Reachability *curReach = [notif object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (NotReachable == status) {
        // 对断网情况做处理
        [self stopSession];
    }
    
    NSLog(@"Networkt Status: %s", networkStatus[status]);
}

#pragma mark - <PLStreamingSendingBufferDelegate>

- (void)streamingSessionSendingBufferFillDidLowerThanLowThreshold:(id)session {
    if (self.session.isRunning) {
        NSString *oldVideoQuality = self.session.videoConfiguration.videoQuality;
        NSString *newVideoQuality = kPLVideoStreamingQualityLow3;
        
        if ([oldVideoQuality isEqualToString:kPLVideoStreamingQualityLow1]) {
            newVideoQuality = kPLVideoStreamingQualityLow2;
        } else if ([oldVideoQuality isEqualToString:kPLVideoStreamingQualityLow2]) {
            newVideoQuality = kPLVideoStreamingQualityLow3;
        }
        
        dispatch_sync(self.sessionQueue, ^{
            [self.session beginUpdateConfiguration];
            self.session.videoConfiguration.videoQuality = newVideoQuality;
            [self.session endUpdateConfiguration];
        });
    }
}

- (void)streamingSessionSendingBufferFillDidHigherThanHighThreshold:(id)session {
    if (self.session.isRunning) {
        NSString *oldVideoQuality = self.session.videoConfiguration.videoQuality;
        NSString *newVideoQuality = kPLVideoStreamingQualityLow1;
        
        if ([oldVideoQuality isEqualToString:kPLVideoStreamingQualityLow3]) {
            newVideoQuality = kPLVideoStreamingQualityLow2;
        } else if ([oldVideoQuality isEqualToString:kPLVideoStreamingQualityLow2]) {
            newVideoQuality = kPLVideoStreamingQualityLow1;
        }
        
        dispatch_sync(self.sessionQueue, ^{
            [self.session beginUpdateConfiguration];
            self.session.videoConfiguration.videoQuality = newVideoQuality;
            [self.session endUpdateConfiguration];
        });
    }
}

- (void)streamingSessionSendingBufferDidFull:(id)session {
    NSLog(@"Buffer is full");
}

- (void)streamingSession:(id)session sendingBufferDidDropItems:(NSArray *)items {
    NSLog(@"Frame dropped");
}

#pragma mark - <PLCameraStreamingSessionDelegate>

- (void)cameraStreamingSession:(PLCameraStreamingSession *)session streamStateDidChange:(PLStreamState)state {
    NSLog(@"Stream State: %s", stateNames[state]);
    
    // 这个回调会确保在主线程，所以可以直接对 UI 做操作
    if (PLStreamStateConnected == state) {
        [self.actionBtn setImage:[UIImage imageNamed:@"stopLogo"] forState:UIControlStateNormal];
        [self.actionBtn1 setImage:[UIImage imageNamed:@"stopLogo"] forState:UIControlStateNormal];
    } else if (PLStreamStateError == state) {
        // 尝试重连，如果你在霹雳创建的 stream 的 publishSecurity 为 static 时，可以如以下代码一样直接重连;
        // 如果是 dynamic 这里需要重新更新推流地址。注意这里需要你自己来处理重连常识的次数
        [self.actionBtn setTitle:NSLocalizedString(@"Reconnecting", nil) forState:UIControlStateNormal];
        [self startSession];
    } else {
        [self.actionBtn setImage:[UIImage imageNamed:@"playLogo"] forState:UIControlStateNormal];
        [self.actionBtn1 setImage:[UIImage imageNamed:@"playLogo"] forState:UIControlStateNormal];
    }
}

- (void)cameraStreamingSession:(PLCameraStreamingSession *)session didDisconnectWithError:(NSError *)error {
    NSLog(@"Stream State: Error. %@", error);
    
    // 这个回调会确保在主线程，所以可以直接对 UI 做操作
    //    [self.actionBtn setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [self.actionBtn setImage:[UIImage imageNamed:@"playLogo"] forState:UIControlStateNormal];
    [self.actionBtn1 setImage:[UIImage imageNamed:@"playLogo"] forState:UIControlStateNormal];
}

#pragma mark - Operation

- (void)stopSession {
    dispatch_async(self.sessionQueue, ^{
        [self.session stop];
    });
}

- (void)startSession {
    self.actionBtn.enabled = NO;
    dispatch_async(self.sessionQueue, ^{
        [self.session startWithCompleted:^(BOOL success) {
            if (success) {
                NSLog(@"Publish URL: %@", self.session.pushURL.absoluteString);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.actionBtn.enabled = YES;
            });
        }];
    });
}


#pragma mark - Action

- (IBAction)actionButtonPressed:(id)sender {
    if (!self.isStart) {
        [self startStream];
        self.isStart = YES;
    }
    if (PLStreamStateConnected == self.session.streamState) {
        [self stopSession];
    } else {
        [self startSession];
    }
}

- (IBAction)toggleCameraButtonPressed:(id)sender {
    dispatch_async(self.sessionQueue, ^{
        [self.session toggleCamera];
    });
}

- (IBAction)torchButtonPressed:(id)sender {
    dispatch_async(self.sessionQueue, ^{
        self.session.torchOn = !self.session.isTorchOn;
    });
}

- (IBAction)muteButtonPressed:(id)sender {
    dispatch_async(self.sessionQueue, ^{
        self.session.muted = !self.session.isMuted;
    });
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

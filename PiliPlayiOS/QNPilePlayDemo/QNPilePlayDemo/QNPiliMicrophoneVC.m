//
//  QNPiliMicrophoneVC.m
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/4.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "QNPiliMicrophoneVC.h"
#import "Reachability.h"
#import <PLCameraStreamingKit/PLCameraStreamingKit.h>

extern const char *stateNames[];

extern const char *networkStatus[];

@interface QNPiliMicrophoneVC ()<
PLAudioStreamingSessionDelegate
>

@property (nonatomic, strong) PLAudioStreamingSession  *session;
@property (nonatomic, strong) Reachability *internetReachability;
//@property (nonatomic, strong) dispatch_queue_t sessionQueue;

@end

@implementation QNPiliMicrophoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"音频录播";
//    self.sessionQueue = dispatch_queue_create("pili.queue.streaming", DISPATCH_QUEUE_SERIAL);
    
    // 网络状态监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    // PLCameraStreamingKit 使用开始
    //
    // streamJSON 是从服务端拿回的
    //
    // 从服务端拿回的 streamJSON 结构如下：
    //    @{@"id": @"stream_id",
    //      @"title": @"stream_title",
    //      @"hub": @"hub_name",
    //      @"publishKey": @"publish_key",
    //      @"publishSecurity": @"dynamic", // or static
    //      @"disabled": @(NO),
    //      @"profiles": @[@"480p", @"720p"],    // or empty Array []
    //      @"hosts": @{
    //              ...
    //      }
    NSDictionary *streamJSON = @{@"publishSecurity":@"dynamic",
                                 @"hub":@"jinxinxin",
                                 @"title":@"56370fd1d409d29ff00004b4",
                                 @"publishKey":@"4cc2967cfc182f22",
                                 @"disabled":@(NO),
                                 @"hosts":@{
                                         @"live": @{
                                                 @"http":@"pili-live-hls.live.golanghome.com",
                                                 @"hdl":@"pili-live-hdl.live.golanghome.com",
                                                 @"hls": @"pili-live-hls.live.golanghome.com",
                                                 @"rtmp":@"pili-live-rtmp.live.golanghome.com"},
                                         @"playback": @{
                                                 @"http":@"pili-playback.live.golanghome.com",
                                                 @"hls":@"pili-playback.live.golanghome.com"},
                                         @"play":@{
                                                 @"http":@"pili-live-hls.live.golanghome.com",
                                                 @"rtmp": @"pili-live-rtmp.live.golanghome.com"},
                                         @"publish": @{
                                                 @"rtmp":@"pili-publish.live.golanghome.com"}},
                                 @"updatedAt": @"2015-11-02T07:25:05.627Z",
                                 @"id": @"z1.jinxinxin.56370fd1d409d29ff00004b4",
                                 @"profiles": @[@"480p", @"720p"],
                                 @"createdAt":@"2015-11-02T07:25:05.627Z"};
    PLStream *stream = [PLStream streamWithJSON:streamJSON];
    
    void (^permissionBlock)(void) = ^{
//        dispatch_async(self.sessionQueue, ^{
            // 音频编码配置
            PLAudioStreamingConfiguration *audioConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
            
            // 推流 session
            self.session = [[PLAudioStreamingSession alloc] initWithConfiguration:audioConfiguration stream:stream];
            self.session.delegate = self;
            
            // 可以设置为进入后台持续推流
            self.session.backgroundMode = PLStreamingBackgroundModeKeepAlive;
//        });
    };
    
    void (^noAccessBlock)(void) = ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Access", nil)
                                                            message:NSLocalizedString(@"!", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    };
    
    switch ([PLAudioStreamingSession microphoneAuthorizationStatus]) {
        case PLAuthorizationStatusAuthorized:
            permissionBlock();
            break;
        case PLAuthorizationStatusNotDetermined: {
            [PLAudioStreamingSession requestMicrophoneAccessWithCompletionHandler:^(BOOL granted) {
                // 回调确保在主线程，可以安全对 UI 做操作
                granted ? permissionBlock() : noAccessBlock();
            }];
        }
            break;
        default:
            noAccessBlock();
            break;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
//    dispatch_sync(self.sessionQueue, ^{
        [self.session destroy];
//    });
    self.session = nil;
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

#pragma mark - <PLAudioStreamingSessionDelegate>

- (void)audioStreamingSession:(PLAudioStreamingSession *)session streamStateDidChange:(PLStreamState)state {
    NSLog(@"Stream State: %s", stateNames[state]);
    
    if (PLStreamStateConnected == state) {
        [self.actionBtn setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateNormal];
    } else if (PLStreamStateError == state) {
        // 尝试重连，如果你在霹雳创建的 stream 的 publishSecurity 为 static 时，可以如以下代码一样直接重连;
        // 如果是 dynamic 这里需要重新更新推流地址。注意这里需要你自己来处理重连常识的次数
        [self.actionBtn setTitle:NSLocalizedString(@"Reconnecting", nil) forState:UIControlStateNormal];
        [self startSession];
    } else {
        [self.actionBtn setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    }
}

- (void)audioStreamingSession:(PLAudioStreamingSession *)session didDisconnectWithError:(NSError *)error {
    NSLog(@"Stream State: Error. %@", error);
    
    [self.actionBtn setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
}

#pragma mark - Operation

- (void)stopSession {
    [self.session stop];
}

- (void)startSession {
    self.actionBtn.enabled = NO;
    [self.session startWithCompleted:^(BOOL success) {
        if (success) {
            NSLog(@"Publish URL: %@", self.session.pushURL.absoluteString);
        }
        
        self.actionBtn.enabled = YES;
    }];
}

#pragma mark - Action

- (IBAction)actionButtonPressed:(id)sender {
    if (PLStreamStateConnected == self.session.streamState) {
        [self stopSession];
    } else {
        [self startSession];
    }
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

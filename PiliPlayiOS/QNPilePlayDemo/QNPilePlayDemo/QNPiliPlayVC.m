//
//  QNPiliPlayVC.m
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/3.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "QNPiliPlayVC.h"
#import <PLPlayerKit/PLPlayer.h>

static NSString *status[] = {
    @"PLPlayerStatusUnknow",
    @"PLPlayerStatusPreparing",
    @"PLPlayerStatusReady",
    @"PLPlayerStatusPlaying",
    @"PLPlayerStatusPaused",
    @"PLPlayerStatusStopped",
    @"PLPlayerStatusError"
};

@interface QNPiliPlayVC ()<
PLPlayerDelegate
>

@property (nonatomic, strong) PLPlayer  *player;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSDictionary * dic;
@property (nonatomic, strong) UIButton * backBtn;


@end

@implementation QNPiliPlayVC


- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.url = [NSURL URLWithString:dic[@"playUrls"][@"ORIGIN"]];
        self.dic = dic;
    }
    
    return self;
}

- (void)dealloc {
    self.player = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"播放";
    
    PLPlayer *player = [PLPlayer playerWithURL:self.url];
    player.delegate = self;
    self.player = player;
    
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 50)];
    self.backBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backBtn.layer.cornerRadius = 20;
    [self.backBtn setBackgroundColor:[UIColor redColor]];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self) wself = self;
    [self.player prepareToPlayWithCompletion:^(NSError *error) {
        if (!error) {
            __strong typeof(wself) strongSelf = wself;
            UIView *playerView = strongSelf.player.playerView;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:strongSelf action:@selector(tap:)];
            [playerView addGestureRecognizer:tap];
            
//            [playerView addSubview:strongSelf.backBtn];
            
            [strongSelf.view addSubview:playerView];
            [strongSelf.view addSubview:strongSelf.backBtn];
        }
    }];
}


- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ([[NSString stringWithFormat:@"%@",self.dic[@"orientation"]] isEqualToString:@"1"]) {
        return UIDeviceOrientationPortrait;

    }else{
        return UIInterfaceOrientationLandscapeRight;
    }


}

-(NSUInteger)supportedInterfaceOrientations

{
    if ([[NSString stringWithFormat:@"%@",self.dic[@"orientation"]] isEqualToString:@"1"]) {
        return UIInterfaceOrientationMaskPortrait;
    }else
    {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
}

- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.player play];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.player.isPlaying) {
        [self.player stop];
    }
    
    [super viewWillDisappear:animated];
}

#pragma mark -

- (void)tap:(UITapGestureRecognizer *)tap {
    self.player.isPlaying ? [self.player pause] : [self.player resume];
}

#pragma mark - <PLPlayerDelegate>

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    NSLog(@"%@", status[state]);
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    NSLog(@"%@", error);
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

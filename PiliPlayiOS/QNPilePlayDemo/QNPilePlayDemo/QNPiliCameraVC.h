//
//  QNPiliCameraVC.h
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/3.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "BaseVC.h"

@interface QNPiliCameraVC : BaseVC

@property (nonatomic, weak) IBOutlet UIView * proView;
@property (nonatomic, weak) IBOutlet UIButton * actionBtn;
@property (nonatomic, weak) IBOutlet UIButton * toggleCameraBtn;
@property (nonatomic, weak) IBOutlet UIButton * torchBtn;
@property (nonatomic, weak) IBOutlet UIButton * muteBtn;
@property (nonatomic, weak) IBOutlet UIButton * backBtn;

@property (nonatomic, weak) IBOutlet UIView * rightView;
@property (nonatomic, weak) IBOutlet UIButton * actionBtn1;
@property (nonatomic, weak) IBOutlet UIButton * toggleCameraBtn1;
@property (nonatomic, weak) IBOutlet UIButton * torchBtn1;
@property (nonatomic, weak) IBOutlet UIButton * muteBtn1;
@property (nonatomic, weak) IBOutlet UIButton * backBtn1;


- (instancetype)initWithSharpness:(NSInteger)qualityNum
                  withOrientation:(NSInteger)orientationNum
                    withStreamDic:(NSDictionary *)streamDic
                        withTitle:(NSString *)streamName;

@end

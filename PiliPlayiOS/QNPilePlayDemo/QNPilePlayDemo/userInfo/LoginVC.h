//
//  LoginVC.h
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/4.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "BaseVC.h"

@interface LoginVC : BaseVC<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@end

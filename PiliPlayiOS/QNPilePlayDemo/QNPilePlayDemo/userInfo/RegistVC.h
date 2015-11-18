//
//  RegistVC.h
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/4.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "BaseVC.h"

@interface RegistVC : BaseVC
@property (weak, nonatomic) IBOutlet UITextField *userPhoneTextFild;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextFild;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

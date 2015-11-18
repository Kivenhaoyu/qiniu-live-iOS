//
//  PLTabbarVC.m
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/2.
//  Copyright © 2015年   何舒. All rights reserved.
//

//获取当前屏幕宽高
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width        //屏幕宽
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height      //屏幕高
#import "PLTabbarVC.h"
#import "BaseVC.h"
#import "LoginVC.h"



@interface PLTabbarVC ()

@property (nonatomic ,strong) NSMutableArray *vcArray;//VC数组.存储
@property (nonatomic ,strong) NSArray *vcList;

@end

@implementation PLTabbarVC

- (void)viewWillAppear:(BOOL)animated
{
    if (![UserInfoClass sheardUserInfo].isLogin) {
        LoginVC * loginVC = [[LoginVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:^{
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *vcPath=[[NSBundle mainBundle] pathForResource:@"VCList" ofType:@"plist"];
    self.vcList=[NSArray arrayWithContentsOfFile:vcPath];
    
    self.vcArray=[[NSMutableArray alloc] initWithCapacity:45];
    
    for(NSDictionary *dict in self.vcList)
    {
        Class class=NSClassFromString([dict objectForKey:@"VC"]);
        if(class)
        {
            BaseVC *vc=[[class alloc] init];
            
//            vc.tabBarItem.image=[UIImage imageNamed:dict[@"ImageName"]];
            
            vc.tabBarItem.image = [[UIImage imageNamed:dict[@"ImageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            vc.tabBarItem.selectedImage = [[UIImage imageNamed:dict[@"ImageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            vc.title=[dict objectForKey:@"Title"];
            [self.vcArray addObject:vc];
        }
//        self.tabBar.selectedImageTintColor = [UIColor colorWithHue:0.4 saturation:0.61 brightness:0.75 alpha:1];
    }
    UIView *barView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 49)];
    barView.backgroundColor=[UIColor whiteColor];
    self.tabBar.barTintColor=[UIColor whiteColor];
    
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    self.viewControllers=self.vcArray;
    self.delegate=self;
    self.selectedIndex=0;
    self.selectedViewController = [self.viewControllers objectAtIndex:0];
    self.navigationItem.title = self.vcList[self.selectedIndex][@"Title"];
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    viewController.tabBarController.navigationItem.title=self.vcList[tabBarController.selectedIndex][@"Title"];
    NSLog(@"%ld",(long)tabBarController.selectedIndex);
}
-(void)setNavHiden
{
    
    self.navigationController.navigationBar.hidden=YES;
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

//
//  QNPiliComeBackVC.m
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/11/2.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "QNPiliComeBackVC.h"
#import "QNPiliPlayBackVC.h"
#import "MJRefresh.h"
#import "QNPiliCell.h"

@interface QNPiliComeBackVC ()

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation QNPiliComeBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray = [[NSMutableArray alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([UserInfoClass sheardUserInfo].isLogin) {
        [self setupRefresh];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新";
    self.tableView.headerRefreshingText = @"刷新中";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    self.tableView.footerRefreshingText = @"加载中";
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

#pragma mark 下拉刷新
- (void)headerRereshing
{
    NSDictionary * dic = @{@"sessionId":[UserInfoClass sheardUserInfo].sessionID,@"accessToken":[Help transformAccessToken:[UserInfoClass sheardUserInfo].sessionID]};
    [HTTPRequestPost hTTPRequest_PostpostBody:dic andUrl:@"live/video/list" andSucceed:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"responseObject == %@",responseObject);
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:responseObject[@"videoList"]];
            [self.tableView reloadData];
            [self setEndhead];
        });
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        [self setEndhead];
    } andISstatus:NO];
}
#pragma mark 上拉加载
- (void)footerRereshing
{
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"暂无更多数据"];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self setEndFoot];
    });
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdenfier = @"cell";
    QNPiliCell * cell = (QNPiliCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QNPiliCell class]) owner:self options:nil] objectAtIndex:0];
    }
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.userName.text = dic[@"user"];
    cell.videoTile.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QNPiliPlayBackVC * playBackVC = [[QNPiliPlayBackVC alloc] initWithDic:self.dataArray[indexPath.row]];
    [self.navigationController pushViewController:playBackVC animated:YES];
    
    
}

-(void)setEndhead;
{
    [self.tableView headerEndRefreshing];
}
-(void)setEndFoot;
{
    [self.tableView footerEndRefreshing];
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

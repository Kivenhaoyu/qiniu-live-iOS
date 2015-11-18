//
//  QNPiliPlayerVC.h
//  QNPilePlayDemo
//
//  Created by   何舒 on 15/10/27.
//  Copyright © 2015年   何舒. All rights reserved.
//

#import "BaseVC.h"

@interface QNPiliPlayerVC : BaseVC<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

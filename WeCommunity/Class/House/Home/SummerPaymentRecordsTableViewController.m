//
//  SummerPaymentRecordsTableViewController.m
//  WeCommunity
//
//  Created by madarax on 15/10/26.
//  Copyright © 2015年 Harry. All rights reserved.
//

#import "SummerPaymentRecordsTableViewController.h"
#import "SummerPaymentRecordsTableViewCell.h"
#import "SummerPaymentListModel.h"
#import "UIViewController+HUD.h"
#import "SummerAlertView.h"

@interface SummerPaymentRecordsTableViewController ()<SummerPaymentRecordsTableViewCellDelegate ,SummerAlertViewDelegate>
{
    NSInteger pageNumber;
    LoadingView *loadingView;
    SummerNoInfoError *labNoRecords;
}
@property (nonatomic ,strong) NSMutableArray *dataArrary;
@property (nonatomic ,assign) NSInteger indexRow;

@end

@implementation SummerPaymentRecordsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费记录";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    pageNumber = 1;
    _dataArrary = [[NSMutableArray alloc] init];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"SummerPaymentRecordsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellpayment"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 125;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 8)];
    self.tableView.frame = CGRectMake(0, 9, self.view.frame.size.width, self.view.frame.size.height - 9);
    loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
    loadingView.titleLabel.text = @"正在加载";
    [self.view addSubview:loadingView];
    [self takeNoRecords];
    [self receveData];
}

- (void)receveData{
    [Networking retrieveData:get_ORDER_LIST_FEE parameters:@{@"token": [User getUserToken],@"page":[NSNumber numberWithInteger:pageNumber],@"row":@"30"} success:^(id responseObject) {
        NSLog(@"---->%@",responseObject);
        [loadingView removeFromSuperview];
        if (responseObject[@"rows"]&&![responseObject[@"rows"] isEqual:[NSNull null]]) {
            for (NSDictionary *dicTemp in responseObject[@"rows"]) {
                [_dataArrary addObject:[[SummerPaymentListModel alloc] initWithJson:dicTemp]];
            }
            [self.tableView reloadData];
        }
        if (_dataArrary.count) {
            labNoRecords.hidden = YES;
        }else{
            labNoRecords.hidden = NO;
        }
    }];
}

- (void)takeNoRecords{
    labNoRecords = [[SummerNoInfoError alloc] initWithFrame:self.view.bounds];
    labNoRecords.labNoError.text = @"暂无记录";
    labNoRecords.hidden = YES;
    labNoRecords.addNoErrorMore.hidden = YES;
    [self.view addSubview:labNoRecords];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArrary.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SummerPaymentRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellpayment" forIndexPath:indexPath];
    cell.delegate = self;
    [cell confirmCellWithData:_dataArrary[indexPath.row]];
    return cell;
}

#pragma mark - CellDelegate And AlerViewDelegate

- (void)summerPaymentRecordsDeleteCellDataWithData:(UIButton *)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    
    self.indexRow = indexPath.row;
    SummerAlertView *alertView = [[NSBundle mainBundle] loadNibNamed:@"SummerAlertView" owner:self options:nil].firstObject;
    alertView.frame = [UIScreen mainScreen].bounds;
    alertView.delegate = self;
    [self.view.window addSubview:alertView];
}

- (void)summerAlertViewClickIndex:(NSInteger)index{
    if (index == 1) {
        SummerPaymentListModel *listModel = _dataArrary[self.indexRow];
        [Networking retrieveData:get_ORDER_LIST_DELETE parameters:@{@"token": [User getUserToken],@"orderNo":listModel.orderNO}];
        [_dataArrary removeObjectAtIndex:index - 1];
        [self.tableView reloadData];
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

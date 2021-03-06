//
//  SummerRentMyViewController.m
//  WeCommunity
//
//  Created by madarax on 15/11/3.
//  Copyright © 2015年 Harry. All rights reserved.
// 我的租售

#import "SummerRentMyViewController.h"
#import "SummerNoInfoError.h"
@interface SummerRentMyViewController ()
@property(nonatomic,strong)SummerNoInfoError *imgViewError;
@end

@implementation SummerRentMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = nil;
    if (self.playAdvertise) {
        [self setupAdvertisement];
    }
//    [self setupChooseList];
    [self setupTableView];
    _imgViewError = [[SummerNoInfoError alloc] initWithFrame:self.view.bounds];
    _imgViewError.labNoError.text = @"暂无信息";
    _imgViewError.hidden = YES;
    _imgViewError.addNoErrorMore.hidden = YES;
    [self.view addSubview:_imgViewError];
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:10];
    self.loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    self.loadingView.titleLabel.text = @"正在加载";
    self.communityAll = NO;
    self.houseTypeArr = @[@"Sale",@"Rent"];
    [self retrireveData];
    
    // Do any additional setup after loading the view.
}

-(void)setupAdvertisement{
    NSArray *imageArray = @[@"house1",@"house2",@"house3"];
    AdScrollView *adView = [[AdScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 150)];
    adView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    adView.imageNameArray = imageArray;
    adView.PageControlShowStyle = UIPageControlShowStyleCenter;
    adView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    adView.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:adView];
}


-(void)setupTableView{

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[BasicTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    [self.view addSubview:self.tableView];
    
}

#pragma mark filter button

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BasicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if ([self.function isEqualToString:@"rent"]) {
        
        HouseDeal *houseDeal = [[HouseDeal alloc] initWithData:self.dataArray[indexPath.row]];
        NSString *detail = [NSString stringWithFormat:@"%@ %@室-%@厅-%@卫-%@m²",houseDeal.community[@"name"],houseDeal.room,houseDeal.sittingRoom,houseDeal.bathRoom,houseDeal.area];
        [cell configureRentCellImage:houseDeal.pictures[0] title:houseDeal.title detail:detail price:[NSString stringWithFormat:@"%@",houseDeal.price] priceUnit:@"元/月" date: [Util formattedDate:self.dataArray[indexPath.row][@"createTime"] type:3]];
        
    }else  if ([self.function isEqualToString:@"activity"]){
        
        Activity *activity = [[Activity alloc] initWithData:self.dataArray[indexPath.row]];
        [cell configureActivityCellImage:[NSURL URLWithString:activity.coverPhoto] title:activity.title detail:activity.activityTypeName address:activity.address date:activity.beginTime attends:[NSString stringWithFormat:@"%@",activity.applicantCount]];
        
    }else if ([self.function isEqualToString:@"secondHand"]){
        
        SecondHand *secondHand = [[SecondHand alloc] initWithData:self.dataArray[indexPath.row]];
        [cell configureRentCellImage:secondHand.pictures[0] title:secondHand.title detail:secondHand.content price:[NSString stringWithFormat:@"%@",secondHand.dealPrice]  priceUnit:[NSString stringWithFormat:@"原价%@元",secondHand.originalPrice] date:@"" ];
    }
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RentDetailViewController *rentVC = [[RentDetailViewController alloc] init];
    rentVC.detailData = self.dataArray[indexPath.row];
    rentVC.function = self.function;
    if ([self.function isEqualToString:@"rent"]) {
        [self pushVC:rentVC title:@"租售详情"];
    }else if([self.function isEqualToString:@"activity"]){
        [self pushVC:rentVC title:@"活动细节"];
    }else if([self.function isEqualToString:@"secondHand"]){
        [self pushVC:rentVC title:@"详情"];
    }
}

-(void)pushVC:(UIViewController*)vc title:(NSString*)title{
    vc.navigationItem.title = title;
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark networking

-(void)retrireveData{
    [self.view addSubview:self.loadingView];
    NSDictionary *parameters;
    NSString *url;
    if (self.communityAll) {
        parameters = @{@"token":[User getUserToken],@"houseDealTypes":self.houseTypeArr,@"page":@1,@"row":@30};
        url = getMyHouseDealsOfCommunity;
    }else{
        parameters = @{@"token":[User getUserToken],@"houseDealTypes":self.houseTypeArr,@"page":@1,@"row":@30};
        url = getMyHouseDealsOfCommunity;
    }

    __weak typeof(self)weakSelf = self;
    [Networking retrieveData:url parameters:parameters success:^(id responseObject) {
        weakSelf.dataArray = responseObject[@"rows"];
        if (weakSelf.dataArray.count > 0) {
            
        }else{
            weakSelf.imgViewError.hidden = NO;
            
        }
        [weakSelf.tableView reloadData];
    } addition:^{
        [weakSelf.loadingView removeFromSuperview];
    }];
    
}

-(void)refreshHeader{
    
    NSDictionary *parameters;
    NSString *url;
    
    if (self.communityAll) {
        parameters = @{@"token":[User getUserToken],@"houseDealTypes":self.houseTypeArr,@"page":@1,@"row":@30};
        url = getMyHouseDealsOfCommunity;
    }else{
        parameters = @{@"token":[User getUserToken],@"houseDealTypes":self.houseTypeArr,@"page":@1,@"row":@30};
        url = getMyHouseDealsOfCommunity;
    }
    
    __weak typeof(self)weakSelf = self;
    [Networking retrieveData:url parameters:parameters success:^(id responseObject) {
        weakSelf.dataArray = responseObject[@"rows"];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer resetNoMoreData];
        weakSelf.page = 1;
    }];
}

-(void)refreshFooter{
    NSDictionary *parameters;
    NSString *url;
    self.page ++;
    if (self.communityAll) {
        parameters = @{@"token":[User getUserToken],@"houseDealTypes":self.houseTypeArr,@"page":@1,@"row":@30};
        url = getMyHouseDealsOfCommunity;
    }else{
        parameters = @{@"token":[User getUserToken],@"houseDealTypes":self.houseTypeArr,@"page":@1,@"row":@30};
        url = getMyHouseDealsOfCommunity;
    }
    __weak typeof(self)weakSelf = self;
    [Networking retrieveData:url parameters:parameters success:^(id responseObject) {
        weakSelf.dataArray = responseObject[@"rows"];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (weakSelf.dataArray.count < 30*self.page) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark alertView
-(void)authentication{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还未认证，是否现在认证？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 10;
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 && alertView.tag == 10) {
        AccreditationPostViewController *postView = [[AccreditationPostViewController alloc] init];
        [self pushVC:postView title:@"发布认证"];
    }
    if (alertView.tag == 11) {
        RentPostViewController *postVC  = [[RentPostViewController alloc] init];
        postVC.step = 0;
        if (buttonIndex == 0) {
            postVC.houseDealType = SummerHouseDealTypeSale;
        }else{
            postVC.houseDealType = SummerHouseDealTypeRent;
        }
        [self pushVC:postVC title:@"发布"];
    }
}

@end


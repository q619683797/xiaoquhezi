//
//  LikeTableViewController.m
//  WeCommunity
//
//  Created by Harry on 7/21/15.
//  Copyright (c) 2015 Harry. All rights reserved.
// 表扬

#import "LikeTableViewController.h"
#import "AccreditationTableViewController.h"
@interface LikeTableViewController ()<TextPostViewControllerDelegate>

@end

@implementation LikeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    UIBarButtonItem *postBtn = [[UIBarButtonItem alloc] initWithTitle:@"点赞" style:UIBarButtonItemStylePlain target:self action:@selector(post:)];
    self.navigationItem.rightBarButtonItem = postBtn;
    
    [self.tableView registerClass:[BasicTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];

    self.loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    self.loadingView.titleLabel.text = @"正在加载";
    [self retrireveData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    if (section == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BasicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        [cell configureLikeCell:[NSString stringWithFormat:@"收到%@个赞",self.totalLike]];
    }else{
        Like *like =[[Like alloc] initWithData:self.dataArray[indexPath.row]];
        [cell configureLikeCellImage:like.praiseType[@"logo"] title:like.content userName:like.creatorInfo[@"nickName"] date:like.createTime pictures:like.pictures];
    }
    
    

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 200;
    }else{
        Like *like =[[Like alloc] initWithData:self.dataArray[indexPath.row]];
        if (![like.pictures isEqual:[NSNull null]]) {
            return 180;
        }else{
            return 120;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00000001;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self post:nil];
    }
}


# pragma mark - function
-(void)post:(id)sender{
    NSString *userAuthType = [User getAuthenticationOwnerType];
    if ([userAuthType isEqualToString:@"未认证"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"还未认证，是否现在去认证" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1000;
        [alertView show];
    }else if ([userAuthType isEqualToString:@"认证户主"] || [userAuthType isEqualToString:@"认证业主"]){
        TextPostViewController *textPostVC = [[TextPostViewController alloc] init];
        textPostVC.delegate = self;
        textPostVC.navigationItem.title = @"发布表扬";
        textPostVC.function = @"praise";
        [self.navigationController pushViewController:textPostVC animated:YES];
    }else if ([userAuthType isEqualToString:@"认证失败"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"认证失败，是否再次去认证" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1002;
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"还在认证中" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1001;
        [alertView show];
    }
}

#pragma mark networking

-(void)retrireveData{
    
    [self.tableView addSubview:self.loadingView];
    NSDictionary *parameters = @{@"communityId":[Util getCommunityID],@"page":@1,@"row":[NSNumber numberWithInt:row]};
     [Networking retrieveData:getPraisesOfCommunity parameters:parameters success:^(id responseObject) {
         self.dataArray = responseObject[@"rows"];
         self.totalLike = responseObject[@"total"];
         [self.tableView reloadData];
     } addition:^{
         [self.loadingView removeFromSuperview];
     }];
}

-(void)refreshHeader{
    NSDictionary *parameters = @{@"communityId":[Util getCommunityID],@"page":@1,@"row":[NSNumber numberWithInt:row]};
    [Networking retrieveData:getPraisesOfCommunity parameters:parameters success:^(id responseObject) {
        self.dataArray = responseObject[@"rows"];
        self.totalLike = responseObject[@"total"];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer resetNoMoreData];
        self.page = 1;
    }];
}

-(void)refreshFooter{
    self.page ++;
    NSDictionary *parameters = @{@"communityId":[Util getCommunityID],@"page":@1,@"row":[NSNumber numberWithInt:row*self.page]};
    [Networking retrieveData:getPraisesOfCommunity parameters:parameters success:^(id responseObject) {
        self.dataArray = responseObject[@"rows"];
        self.totalLike = responseObject[@"total"];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        if (self.dataArray.count < row*self.page) {
            [self.tableView.footer noticeNoMoreData];
        }
    }];
}

#pragma mark alertView
-(void)authentication{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还未认证，是否现在认证？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1000:
        {//认证
            if (buttonIndex == 1) {
                AccreditationTableViewController *accreditation = [[AccreditationTableViewController alloc] init];
                [self pushVC:accreditation title:@"认证信息"];
            }
        }
            break;
        case 1001:
            break;
        case 1002:
        {
            if (buttonIndex == 1) {
                AccreditationTableViewController *accreditation = [[AccreditationTableViewController alloc] init];
                [self pushVC:accreditation title:@"认证信息"];
            }
        }
            break;
            
        default:
        {
            if (buttonIndex == 1) {
                AccreditationPostViewController *postView = [[AccreditationPostViewController alloc] init];
                [self pushVC:postView title:@"发布认证"];
            }
        }
            break;
    }

}

-(void)pushVC:(UIViewController*)vc title:(NSString*)title{
    vc.navigationItem.title = title;
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)issueInformationSeccess{
    [self refreshHeader];
}

@end

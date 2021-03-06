//
//  LikeTableViewController.m
//  WeCommunity
//
//  Created by Harry on 7/21/15.
//  Copyright (c) 2015 Harry. All rights reserved.
// 表扬

#import "LikeTableViewController.h"
#import "SummerLikeTableViewCell.h"
#import "SummerNoInfoError.h"
#import "AccreditationTableViewController.h"
@interface LikeTableViewController ()<TextPostViewControllerDelegate ,MWPhotoBrowserDelegate>
@property(nonatomic ,strong)NSMutableArray *photos;
@property(nonatomic ,strong)SummerNoInfoError *noInfoError;
@end

@implementation LikeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *postBtn = [[UIBarButtonItem alloc] initWithTitle:@"点赞" style:UIBarButtonItemStylePlain target:self action:@selector(post:)];
    self.navigationItem.rightBarButtonItem = postBtn;
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    _noInfoError = [[SummerNoInfoError alloc] initWithFrame:self.view.bounds];
    _noInfoError.labNoError.text = @"物业还没有收到赞，快去点赞吧～";
    [_noInfoError.addNoErrorMore setTitle:@"点赞" forState:UIControlStateNormal];
    [_noInfoError.addNoErrorMore addTarget:self action:@selector(post:) forControlEvents:UIControlEventTouchUpInside];
    _noInfoError.hidden = YES;
    [self.view addSubview:_noInfoError];
    
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENSIZE.width, SCREENSIZE.height - 64) style:UITableViewStyleGrouped];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    [self.mTableView registerClass:[BasicTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.mTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    self.mTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    [self.view addSubview:self.mTableView];
    
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
    if (indexPath.section == 0) {
        BasicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell configureLikeCell:[NSString stringWithFormat:@"收到%@个赞",self.totalLike]];
        return cell;
    }else{
        SummerLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellItem"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"SummerLikeTableViewCell" owner:self options:nil].firstObject;
        }
        Like *like =[[Like alloc] initWithData:self.dataArray[indexPath.row]];
        [cell confirmsSummerLikeTableViewData:like];        
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200;
    }else{
        Like *like =[[Like alloc] initWithData:self.dataArray[indexPath.row]];
        CGFloat heightSection = [Util getHeightForString:like.content width:SCREENSIZE.width - 80 font:[UIFont systemFontOfSize:15]];
        
        if (![like.pictures isEqual:[NSNull null]]) {
            return 142 + heightSection;
        }else{
            return 90 + heightSection;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00000001;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self post:nil];
    }else{
        NSDictionary *dicTemp = self.dataArray[indexPath.row];
        if (![dicTemp[@"pictures"] isEqual:[NSNull null]]) {
            if ([dicTemp[@"pictures"] count] > 0) {
                //显示图片
                if (self.photos) {
                    [self.photos removeAllObjects];
                }else{
                    self.photos = [[NSMutableArray alloc] initWithCapacity:0];
                }
                for (int i = 0; i< [dicTemp[@"pictures"] count]; i++) {
                    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:dicTemp[@"pictures"][i]]];
                    [self.photos addObject:photo];
                }
                // Create browser
                MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
                browser = [Util fullImageSetting:browser];
                
                browser.displayActionButton = NO;
                //    [browser setCurrentPhotoIndex:self.rentView.headImg.adPageControl.currentPage];
                [self.navigationController pushViewController:browser animated:YES];
            }
        }
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

# pragma mark - function
-(void)post:(id)sender{
    NSString *userAuthType = [User getAuthenticationOwnerType];
    if ([userAuthType isEqualToString:@"未认证"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还未认证，是否现在去认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1000;
        [alertView show];
    }else if ([userAuthType isEqualToString:@"户主"] || [userAuthType isEqualToString:@"业主"]){
        TextPostViewController *textPostVC = [[TextPostViewController alloc] init];
        textPostVC.delegate = self;
        textPostVC.navigationItem.title = @"发布表扬";
        textPostVC.function = @"praise";
        [self.navigationController pushViewController:textPostVC animated:YES];
    }else if ([userAuthType isEqualToString:@"认证失败"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"认证失败，是否再次去认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1002;
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还在认证中" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1001;
        [alertView show];
    }
}

#pragma mark networking

-(void)retrireveData{
    [self.mTableView addSubview:self.loadingView];
    __weak typeof(self)weakSelf = self;
    NSDictionary *parameters = @{@"communityId":[Util getCommunityID],@"page":@1,@"row":@30};
     [Networking retrieveData:getPraisesOfCommunity parameters:parameters success:^(id responseObject) {
         weakSelf.totalLike = responseObject[@"total"];
         for (NSDictionary *dic in responseObject[@"rows"]) {
             [weakSelf.dataArray addObject:dic];
         }
         if (weakSelf.dataArray.count > 0) {
             [weakSelf.mTableView reloadData];
         }else{
             weakSelf.mTableView.hidden = YES;
             _noInfoError.hidden = NO;
         }
         
     } addition:^{
         [self.loadingView removeFromSuperview];
     }];
}

-(void)refreshHeader{
    __weak typeof(self)weakSelf = self;
    
    NSDictionary *parameters = @{@"communityId":[Util getCommunityID],@"page":@1,@"row":@30};
    [Networking retrieveData:getPraisesOfCommunity parameters:parameters success:^(id responseObject) {
        if (weakSelf.dataArray.count > 0) {
            [weakSelf.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in responseObject[@"rows"]) {
            [weakSelf.dataArray addObject:dic];
        }
        weakSelf.totalLike = responseObject[@"total"];
        [weakSelf.mTableView reloadData];
        if (weakSelf.dataArray.count > 0) {
            [weakSelf.mTableView reloadData];
        }else{
            weakSelf.mTableView.hidden = YES;
            _noInfoError.hidden = NO;
        }
        [weakSelf.mTableView.mj_header endRefreshing];
        [weakSelf.mTableView.mj_footer resetNoMoreData];
       weakSelf.page = 1;
    }];
}

-(void)refreshFooter{
    self.page ++;
    __weak typeof(self)weakSelf = self;
    NSDictionary *parameters = @{@"communityId":[Util getCommunityID],@"page":[NSNumber numberWithInt:self.page],@"row":@30};
    [Networking retrieveData:getPraisesOfCommunity parameters:parameters success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[@"rows"]) {
            [weakSelf.dataArray addObject:dic];
        }
        weakSelf.totalLike = responseObject[@"total"];
        [weakSelf.mTableView reloadData];
        [weakSelf.mTableView.mj_footer endRefreshing];
        if (weakSelf.dataArray.count < 30*self.page) {
            [weakSelf.mTableView.mj_footer endRefreshingWithNoMoreData];
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
                AccreditationPostViewController *accreditation = [[AccreditationPostViewController alloc] init];
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

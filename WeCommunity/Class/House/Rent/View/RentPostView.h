//
//  RentPostView.h
//  WeCommunity
//
//  Created by Harry on 8/5/15.
//  Copyright (c) 2015 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Util.h"
#import "GrayLine.h"
#import "BasicHeadDetailView.h"
#import "CameraImageView.h"
@interface RentPostView : UIView

@property (nonatomic,strong) UIImageView *headView;
@property (nonatomic,strong) UIButton *imgBtn;
@property (nonatomic,strong) UIButton *houseTypeBtn;
@property (nonatomic,strong) UITextField *sittingRoomField;
@property (nonatomic,strong) UITextField *titleField;
@property (nonatomic,strong) UITextField *roomField;
@property (nonatomic,strong) UITextField *bathRoomField;
@property (nonatomic,strong) UITextField *floorField;
@property (nonatomic,strong) UITextField *totalFloorField;
@property (nonatomic,strong) UITextField *priceField;
@property (nonatomic,strong) UITextField *areaField;
@property (nonatomic,strong) UITextField *contentField;
@property (nonatomic,strong) UIButton * houseOrientationBtn;
@property (nonatomic,strong) UILabel *imageCount;
@property (nonatomic,strong) UIButton *imageBtn;
@property (nonatomic,strong) CameraImageView *cameraView;
-(void)setupFirstPart;
-(void)setupSecondPart;
-(void)setupThirdPart;
@end
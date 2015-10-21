//
//  User.m
//  WeCommunity
//
//  Created by Harry on 7/31/15.
//  Copyright (c) 2015 Harry. All rights reserved.
//

#import "User.h"
#import "FileManager.h"
@implementation User


- (id) initWithData {
    self = [super init];
    
    if ( self ){
        
        if ([User judgeLogin]) {
            
            NSDictionary *dataAll = [FileManager getData:@"MyAppCache"];
            NSDictionary *data = dataAll[@"user"];
            
            self.token = dataAll[@"token"];
            self.userName = data[@"userName"];
            self.continuousSignDay = data[@"continuousSignDay"];
            self.nickName = data[@"nickName"];
            self.job = data[@"job"];
            self.point = data[@"point"];
            self.sex = data[@"sex"];
            self.sexName = data[@"sexName"];
            self.totalSignDay = data[@"totalSignDay"];
            self.userType = data[@"userType"];
            self.userTypeName = data[@"userTypeName"];
            self.lastSignTime = [Util formattedDate:data[@"lastSignTime"] type:1];
            self.createTime = [Util formattedDate:data[@"createTime"] type:1];
            self.communityId = data[@"communityId"];
            self.headPhoto = [NSURL URLWithString:data[@"headPhoto"]] ;
            self.continuousSignDay = data[@"continuousSignDay"];
            self.hobby = data[@"hobby"];
            
        }
        
    }
    
    return self;
}

+(NSString*)getUserToken{
     NSDictionary *dataAll = [FileManager getData:@"MyAppCache"];
    return dataAll[@"token"];
}

//判断是否登录了
+(BOOL)judgeLogin{
    
    NSDictionary *data = [FileManager getData:@"MyAppCache"];
    NSString *event = [NSString stringWithFormat:@"%@",data[@"userName"]];
    NSDictionary *password = [FileManager getData:@"Password"];
    if ([event isEqualToString:@"0"] || event == nil  || password == nil ) {
        return false;
    }else{
        return true;
    }
}


//用户登陆
+(void)login{
    
    if ([self judgeLogin]) {
        
        NSDictionary *username = [FileManager getData:@"MyAppCache"];
        NSDictionary *password = [FileManager getData:@"Password"];
        NSDictionary *parameters = @{@"phoneNumber":username[@"user"][@"userName"],@"password":password[@"password"]};
                
        [Networking retrieveData:phoneLogin parameters:parameters success:^(id responseObject) {
            NSDictionary *userData = [Util removeNullInDictionary:responseObject[@"user"]];
            NSDictionary *data = @{@"token":responseObject[@"token"],@"user":userData};
            [FileManager saveDataToFile:data filePath:@"MyAppCache"];
            
            NSLog(@"Login success");
            [User SaveAuthentication];
            
        }];
    }
}



+(void)SaveAuthentication{
    
    NSString *communityID = @"1";
    if ([Util judgeChooseCommunity]) {
        communityID =[Util getCommunityID];
    }
    
    [Networking retrieveData:getAuthenticationStatus parameters:@{@"token":[User getUserToken],@"communityId":communityID} success:^(id responseObject) {
        
        NSString *event = [NSString stringWithFormat:@"%@",responseObject];
        
        if ([event isEqualToString:@"<null>"]) {
            
            NSDictionary *authentication = @{
                                             @"communityName":@"",
                                             @"addressName":@"",
                                             @"owerType":@"未认证"
                                             };
            
            [FileManager saveDataToFile:authentication filePath:@"Authentication"];
            
            
        }else{
            NSString *owerType = @"";
            if ([responseObject[@"ownerType"] isEqualToString:@"Owner"]) {
                owerType = @"认证户主";
            }else if ([responseObject[@"OwnerType"] isEqualToString:@"NoOwner"]){
                owerType = @"认证业主";
            }
            
            NSDictionary *authentication = @{
                                             @"communityName":responseObject[@"community"][@"name"],
                                             @"addressName":[NSString stringWithFormat:@"%@%@",responseObject[@"buildingName"],responseObject[@"houseName"]],
                                             @"owerType":owerType
                                             };
            [FileManager saveDataToFile:authentication filePath:@"Authentication"];
            
        }
        
        
        
    }];

}

+(NSString*)getAuthenticationAddress{
    NSDictionary *dataAll = [FileManager getData:@"Authentication"];
    return dataAll[@"addressName"];
}

+(NSString*)getAuthenticationOwnerType{
    NSDictionary *dataAll = [FileManager getData:@"Authentication"];
    return dataAll[@"owerType"];
}


@end
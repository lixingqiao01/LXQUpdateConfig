//
//  LXQUpdateConfig.h
//  LXQUpdateConfig
//
//  Created by bsj－mac1 on 2018/6/4.
//

#import <Foundation/Foundation.h>

@interface LXQUpdateConfig : NSObject
@property (nonatomic, copy)     NSString        *appID;
@property (nonatomic, copy, readonly)   NSString *appVersion;
@property (nonatomic, copy)     NSString        *alertTitle;
@property (nonatomic, copy)     NSString        *alertMessage;
+ (instancetype)shareInstance;
@end

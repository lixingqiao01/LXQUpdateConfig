//
//  LXQUpdateConfig.m
//  LXQUpdateConfig
//
//  Created by bsj－mac1 on 2018/6/4.
//

#import "LXQUpdateConfig.h"
#import <UIKit/UIKit.h>
//#import <>
static LXQUpdateConfig *config = nil;
@implementation LXQUpdateConfig

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc]init];
    });
    return config;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self getTheCurrentVersion];
    }
    return self;
}

- (void)getTheCurrentVersion{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    _appVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
}

- (void)setAppID:(NSString *)appID{
    _appID = appID;
    [self getAppVersion];
}

- (void)getAppVersion{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@",self.appID]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([(NSHTTPURLResponse *)response statusCode] == 200) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *netVersion = [[[json objectForKey:@"results"] firstObject] objectForKey:@"version"];
            if (![netVersion isEqualToString:self.appVersion]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    UIWindow *showWindow = [[UIApplication sharedApplication].delegate window];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.alertTitle?self.alertTitle:@"检测到新版本" message:self.alertMessage?self.alertMessage:@"新版本已经发布" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        if (@available(iOS 10.0, *)) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",self.appID]] options:@{} completionHandler:nil];
                        } else {
                            // Fallback on earlier versions
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",self.appID]]];
                        }
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [showWindow.rootViewController presentViewController:alertController animated:YES completion:^{
                        
                    }];
                });
            }
        }
    }];
    [dataTask resume];
}

@end

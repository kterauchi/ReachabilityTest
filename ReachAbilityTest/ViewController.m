//
//  ViewController.m
//  ReachAbilityTest
//
//  Created by Keiichiro on 2016/06/01.
//  Copyright © 2016年 Keiichiro. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()
@property (nonatomic, assign) AFNetworkReachabilityStatus status;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    /*** 案1 ***/
//    // Unknown以外になるまで指定時間ごとに呼び出しまくる
//    [self tryConfirmReachabilityStatusWithoutUnknown];
    
    /*** 案2 ***/
    // KVOでnetworkReachabilityStatusを監視してみる。
    self.status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    NSLog(@"status:%ld", self.status);
    
    [[AFNetworkReachabilityManager sharedManager] addObserver:self forKeyPath:@"networkReachabilityStatus" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] removeObserver:self forKeyPath:@"networkReachabilityStatus"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 note:指定した時間ごとにUnknown以外のstatusが出るまでReachabilityStatusを確認し続ける
      このメソッドはもうちょっとなんとかならなかったのか。
 */
- (void)tryConfirmReachabilityStatusWithoutUnknown
{
    static NSInteger count;
    
    if ([self confirmRachabilityStatusLog] == AFNetworkReachabilityStatusUnknown) {
        count++;
        [NSTimer scheduledTimerWithTimeInterval:0.00001f target:self selector:@selector(tryConfirmReachabilityStatusWithoutUnknown) userInfo:nil repeats:NO];
    }else{
        NSLog(@"合計%lu回でした。", count);
    }
}

/**
 note:ReachAbilityの状態を取得し、NSLogで表示するメソッド
 */
- (AFNetworkReachabilityStatus)confirmRachabilityStatusLog
{
    // Reachabilityの状態を取得
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            NSLog(@"Unknown");
            break;
        case AFNetworkReachabilityStatusNotReachable:
            NSLog(@"not Reachable");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@"WWAN");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            NSLog(@"WiFi");
            break;
        default:
            break;
    }
    
    return status;
}

#pragma mark - observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self callFromOvserve];
}

- (void)callFromOvserve
{
    NSLog(@"statusに変化があったのでメソッド動かしました。\nstatus:%ld", self.status);
}
@end

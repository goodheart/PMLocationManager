//
//  ViewController.m
//  LocationDemo
//
//  Created by majian on 15/9/30.
//  Copyright © 2015年 majian. All rights reserved.
//

#import "ViewController.h"
#import "PMLocationManager.h"
@interface ViewController ()<PMLocationManagerDelegate>
{
    PMLocationManager * _locationManager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _locationManager = [[PMLocationManager alloc] init];
    _locationManager.delegate = self;
}

- (void)locationManager:(PMLocationManager *)locationManager didLocateAddress:(NSString *)address {
    NSLog(@"address : %@",address);
}

- (void)locationManager:(PMLocationManager *)locationManager faildLocateWithFailType:(PMLocationManagerFailType)failType {
    NSLog(@"faild %ld",failType);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_locationManager startLocate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

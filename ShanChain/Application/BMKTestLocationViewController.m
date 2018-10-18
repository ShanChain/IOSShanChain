//
//  BMKTestLocationViewController.m
//  ShanChain
//
//  Created by 千千世界 on 2018/10/16.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "BMKTestLocationViewController.h"
#import "UITextView+Placeholder.h"
#import "UIViewController+SYBase.h"

@interface BMKTestLocationViewController ()<UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate>
@property (nonatomic, strong)BMKLocationService *locService;
@property (nonatomic, strong)BMKGeoCodeSearch *searcher;
@property BOOL isGeoSearch;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic,copy)   NSString  *latitude;
@property (nonatomic,copy)   NSString  *longitude;
@property (nonatomic,assign)  CLLocationCoordinate2D   pt;

@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@end

@implementation BMKTestLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百度地图测试";
    [self pn_ConfigurationMapView];
    self.textView.placeholder = @"请输入URL...";
    _locService = [[BMKLocationService alloc]init];//定位功能的初始化
    _locService.delegate = self;//设置代理位self
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    [_locService startUserLocationService];//启动定位服务
    [self addNavigationRightWithName:@"确定" withTarget:self withAction:@selector(determine)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //初始化检索对象
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
        //发起逆地理编码检索
        // {self.latitude.doubleValue, self.longitude.doubleValue}
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = self.pt;
        BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"逆geo检索发送成功");
        }
        else
        {
            NSLog(@"逆geo检索发送失败");
        }
        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = self.pt;
        annotation.title = @"您当前位置";
        [self.mapView addAnnotation:annotation];
        
        
    });
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.searcher.delegate = nil;
}

- (void)pn_ConfigurationMapView{
    [self.mapView setMapType:BMKMapTypeStandard];//标准地图
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;// 定位模式
    self.mapView.zoomLevel = 21;//地图级别
    self.mapView.showsUserLocation = YES; //是否显示定位图层
    // _mapView.compassPosition = CGPointMake(ScreenWidth - 50, 25);//指南针的位置
    //打开实时路况图层
    //    [_mapView setTrafficEnabled:YES];
    //设定地图View能否支持用户多点缩放(双指)
    self.mapView.zoomEnabled = YES;
    //设置地图上是否显示比例尺
    self.mapView.showMapScaleBar = YES;
    // 隐藏百度地图的logo
    [self.mapView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([view isKindOfClass:NSClassFromString(@"BMKInternalMapView")]) {
            [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[UIImageView class]]) {
                    obj.hidden = YES;
                    
                }
                if ([obj isKindOfClass:NSClassFromString(@"BaseMapScaleView")]) {
                    
                }
            }];
        }
    }];
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.mapView addGestureRecognizer:tap];
}

- (void)tap{
    [self.view endEditing:YES];
}

- (void)determine{
    [[SCNetwork shareInstance]HH_postWithUrl:self.textView.text params:@{@"latitude":self.latitude,@"longitude":self.longitude} showLoading:YES success:^(HHBaseModel *baseModel) {
        [HHTool showSucess:baseModel.message];
//            [self hrShowAlertWithTitle:nil message:[NSString stringWithFormat:@"latitude:%@\nlongitude:",latitude,longitude] buttonsTitles:@[@"确定"] andHandler:nil];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - BMK_LocationDelegate 百度地图
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"地图定位失败======%@",error);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    
    //从manager获取左边
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;//位置坐标
    self.pt = coordinate;
    self.mapView.centerCoordinate = coordinate;
    if ((userLocation.location.coordinate.latitude != 0 || userLocation.location.coordinate.longitude != 0))
    {
        
        
        //发送反编码请求
        //[self sendBMKReverseGeoCodeOptionRequest];
        
        NSString *latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
        self.latitude = latitude;
        NSString *longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
        self.longitude = longitude;
        
        self.latLabel.text = [NSString stringWithFormat:@"维度:%@",latitude];
        self.longLabel.text = [NSString stringWithFormat:@"经度:%@",longitude];
        
//        [self reverseGeoCodeWithLatitude:latitude withLongitude:longitude];
        
    }else{
        NSLog(@"位置为空");
    }
    
    //关闭坐标更新
    [self.locService stopUserLocationService];
}

//地图定位
- (BMKLocationService *)locService
{
    if (!_locService)
    {
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
    }
    return _locService;
}



- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        self.detailsLabel.text = [NSString stringWithFormat:@"详细地址:%@ \n %@ \n ",result.address,result.sematicDescription];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
       [self.view endEditing:YES];
}

@end

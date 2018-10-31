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
#import "ShanChain-Swift.h"
#import "UIView+LSCore.h"

static  NSString  * const kCurrentUserName = @"kJCCurrentUserName";

@interface BMKTestLocationViewController ()< UITableViewDelegate,CLLocationManagerDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate>
@property (nonatomic, strong)BMKLocationService *locService;
@property (nonatomic, strong)BMKGeoCodeSearch *searcher;
@property BOOL isGeoSearch;


@property (nonatomic,copy)   NSString  *latitude;
@property (nonatomic,copy)   NSString  *longitude;
@property (nonatomic,assign)  CLLocationCoordinate2D   pt;
@property (weak, nonatomic) IBOutlet UILabel *locationLb;

@property (weak, nonatomic) IBOutlet UIView *lcView;

@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIView *moreView;

@property (weak, nonatomic) IBOutlet UIButton *noteBtn;

@property (weak, nonatomic) IBOutlet UIButton *footprintBtn;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (nonatomic,assign)  BOOL    isLBS;

@end

@implementation BMKTestLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百度地图测试";
    ViewRadius(self.joinBtn, 10);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.lcView addRoundedCorners:UIRectCornerTopRight|UIRectCornerBottomRight withRadii:CGSizeMake(self.view.height/2.0, self.view.height/2.0)];
    [self.moreView addRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withRadii:CGSizeMake(self.view.height/2.0, self.view.height/2.0)];
    [self pn_ConfigurationMapView];
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
    
}

- (void)sc_addOverlay{
    // 添加折线覆盖物
   // CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(39.90868, 116.3956);//原始坐标
    
    //转换国测坐标（google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标）至百度坐标
//    CLLocationCoordinate2D testdic =  BMKCoordTrans(coor,BMK_COORDTYPE_GPS,BMK_COORDTYPE_BD09LL);
    
    CLLocationCoordinate2D coor[5] = {0};
    coor[0].latitude = 20.046381;
    coor[0].longitude = 110.325502;
  //  coor[0] = BMKCoordTrans(coor[0],BMK_COORDTYPE_GPS,BMK_COORDTYPE_BD09LL);
    
    
    coor[1].latitude = 20.046381;
    coor[1].longitude = 110.331246;
  //  coor[1] = BMKCoordTrans(coor[1],BMK_COORDTYPE_GPS,BMK_COORDTYPE_BD09LL);
    
    coor[2].latitude = 20.051780;
    coor[2].longitude = 110.331246;
 //   coor[2] = BMKCoordTrans(coor[2],BMK_COORDTYPE_GPS,BMK_COORDTYPE_BD09LL);
    
    coor[3].latitude = 20.051780;
    coor[3].longitude = 110.325502;
//    coor[3] = BMKCoordTrans(coor[3],BMK_COORDTYPE_GPS,BMK_COORDTYPE_BD09LL);
    
    coor[4].latitude = 20.046381;
    coor[4].longitude = 110.325502;
 //   coor[4] = BMKCoordTrans(coor[4],BMK_COORDTYPE_GPS,BMK_COORDTYPE_BD09LL);
    
    BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coor count:5];
    [self.mapView addOverlay:polyline];
}

- (void)sc_getLbsCoordinate{
    if (!self.latitude || !self.longitude || self.isLBS) {
        return;
    }
    weakify(self);
    [[SCNetwork shareInstance]HH_postWithUrl:GETCOORDINATE params:@{@"latitude":self.latitude,@"longitude":self.longitude} showLoading:YES callBlock:^(HHBaseModel *baseModel, NSError *error) {
        weak_self.isLBS = YES;
        [weak_self sc_addOverlay];
    }];
 
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
    self.mapView.zoomLevel = 20;//地图级别
    self.mapView.showsUserLocation = YES; //是否显示定位图层
    self.mapView.delegate = self;
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
- (IBAction)notePressed:(id)sender {
}

// 足迹
- (IBAction)footprintPressed:(id)sender {
}

- (void)determine{
//    [[SCNetwork shareInstance]HH_postWithUrl:self.textView.text params:@{@"latitude":self.latitude,@"longitude":self.longitude} showLoading:YES success:^(HHBaseModel *baseModel) {
//        [HHTool showSucess:baseModel.message];
////            [self hrShowAlertWithTitle:nil message:[NSString stringWithFormat:@"latitude:%@\nlongitude:",latitude,longitude] buttonsTitles:@[@"确定"] andHandler:nil];
//    } failure:^(NSError *error) {
//        
//    }];

   
    
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
    //从manager获取左边
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;//位置坐标
    self.pt = coordinate;
    if (!self.isLBS) {
        self.mapView.centerCoordinate = coordinate;
    }
    
    if ((userLocation.location.coordinate.latitude != 0 || userLocation.location.coordinate.longitude != 0))
    {
        //发送反编码请求
        //[self sendBMKReverseGeoCodeOptionRequest];
        
        NSString *latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
        self.latitude = latitude;
        NSString *longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
        self.longitude = longitude;
        
        [self sc_getLbsCoordinate];// 上传用户实时坐标
        NSString *long_title = coordinate.longitude > 0 ?@"东经":@"西经";
        NSString *lat_title = coordinate.latitude > 0 ?@"北纬":@"南纬";
        self.locationLb.text = [NSString stringWithFormat:@"%@%.2f°%@%.2f°",long_title,coordinate.longitude,lat_title,coordinate.latitude];
        
      
        
//        [self reverseGeoCodeWithLatitude:latitude withLongitude:longitude];
        
    }else{
        NSLog(@"位置为空");
    }
    
    //关闭坐标更新
   // [self.locService stopUserLocationService];
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
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

// AnnotationView
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        BMKPinAnnotationView*annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.pinColor = BMKPinAnnotationColorPurple;
        annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop=YES;         //设置标注动画显示，默认为NO
        annotationView.draggable = YES;          //设置标注可以拖动，默认为NO
        return annotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState{
    if (newState == BMKAnnotationViewDragStateEnding) {
        [mapView.annotations enumerateObjectsUsingBlock:^(BMKPointAnnotation *  _Nonnull pointAnnotation, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([pointAnnotation.title isEqualToString:@"您当前位置"]) {
               // CLLocationCoordinate2D  coods = pointAnnotation.coordinate;
                
            }
        }];
    }
}

// Override
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:1];
        polylineView.fillColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:1];
        polylineView.lineWidth = 1.0;
        polylineView.lineDash = YES;
        return polylineView;
    }
    return nil;
}




- (IBAction)joinPressed:(id)sender{
    

    
    [HHTool mainWindow].rootViewController = nil;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kCurrentUserName]){
        JCMainTabBarController  *tabBarVC = [[JCMainTabBarController alloc]init];
        [HHTool mainWindow].rootViewController = tabBarVC;
//        JCConversationListViewController *chatListView = [[JCConversationListViewController alloc]init];
//         [self.navigationController pushViewController:chatListView animated:YES];
    }else{
        JCNavigationController *nav = [[JCNavigationController alloc]initWithRootViewController:[JCLoginViewController new]];
       // [self.navigationController pushViewController:nav animated:YES];
        [HHTool mainWindow].rootViewController = nav;

    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
       [self.view endEditing:YES];
}




@end
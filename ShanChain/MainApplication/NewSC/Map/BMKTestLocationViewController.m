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
#import "CoordnateInfosModel.h"
#import "SCLoginController.h"
#import "SCBaseNavigationController.h"


@interface BMKTestLocationViewController ()< UITableViewDelegate,CLLocationManagerDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate>
@property (nonatomic, strong)BMKLocationService *locService;
@property (nonatomic, strong)BMKGeoCodeSearch *searcher;
@property BOOL isGeoSearch;


@property (nonatomic,copy)   NSString  *latitude;
@property (nonatomic,copy)   NSString  *longitude;
@property (nonatomic,assign)  CLLocationCoordinate2D   pt;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@property (weak, nonatomic) IBOutlet UIButton *noteBtn;

@property (weak, nonatomic) IBOutlet UIButton *footprintBtn;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic,assign)  BOOL    isLBS;
@property (nonatomic,assign)  BOOL    isClickJoin;

@property (nonatomic,strong)  NSArray  <CoordnateInfosModel*> *roomInfos;

@property (nonatomic,copy)    NSString   *currentRoomId; //当前的聊天室ID
@property (nonatomic,strong)   CoordnateInfosModel   *myLocationCoordModel; //我当前位置所在的聊天室model
@property (nonatomic,copy)    NSString   *currentRoomName; //当前的聊天室名称



@end

@implementation BMKTestLocationViewController

- (void)sc_ConfigurationUI{
    
    [self.view bringSubviewToFront:self.bottomView];
    [self.joinBtn _setCornerRadiusCircle];
    [self.noteBtn _setCornerRadiusCircle];
    [self.footprintBtn _setCornerRadiusCircle];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self pn_ConfigurationMapView];
    _locService = [[BMKLocationService alloc]init];//定位功能的初始化
    _locService.delegate = self;//设置代理位self
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    [_locService startUserLocationService];//启动定位服务
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kJMSGNetworkDidSetupNotification) name:kJMSGNetworkDidSetupNotification object:nil];
    [self.joinBtn setTitle:NSLocalizedString(@"sc_enter", nil) forState:0];
    
}

- (void)kJMSGNetworkDidSetupNotification{
    [HHTool dismiss];
    if (self.isClickJoin) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getAllChatRoomConversation];
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sc_ConfigurationUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.mapView viewWillAppear];
    self.navigationController.navigationBarHidden = YES;
}

- (void)sc_addOverlayWithCoordnates{
  
    for (CoordnateInfosModel * Coordnatemodel in self.roomInfos) {
        [self sc_addOverlayWithModel:Coordnatemodel];
    }
}


- (NSDictionary*)getParameter{
    if (NULLString(self.latitude) || NULLString(self.longitude)) {
        return @{};
    }
    return @{@"latitude":self.latitude,@"longitude":self.longitude};
}

- (void)sc_getLbsCoordinate{
    if (!self.latitude || !self.longitude || self.isLBS) {
        return;
    }
    weakify(self);
    [[SCNetwork shareInstance]getWithUrl:GETCOORDINATE parameters:[self getParameter] success:^(id responseObject) {
        NSArray  *arr = responseObject[@"data"][@"room"];
        if(arr.count > 0){
            NSMutableArray  *mAry = [NSMutableArray arrayWithCapacity:0];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                CoordnateInfosModel  *model = [CoordnateInfosModel yy_modelWithDictionary:dic];
                if (idx == 0) {
                    self.myLocationCoordModel = model;
                }
                if (model) {
                    [mAry addObject:model];
                }
            }];
            weak_self.roomInfos = mAry.copy;
        }
        
        if(weak_self.roomInfos.count > 0){
            [weak_self sc_addOverlayWithCoordnates];
            [weak_self setChatRoomCenterPoint];
        }
         weak_self.isLBS = YES;
    } failure:^(NSError *error) {
         weak_self.isLBS = YES;
    }];
}

- (void)setChatRoomCenterPoint{
    CoordnateInfosModel *model = self.roomInfos.firstObject;
    [self sc_configurationMapViewCenterLocationWithModel:model];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
//    self.mapView.delegate = nil; // 不用时，置nil
//    self.searcher.delegate = nil;
}

- (void)pn_ConfigurationMapView{
    [self.mapView setMapType:BMKMapTypeStandard];//标准地图
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;// 定位模式
    self.mapView.zoomLevel = 16;//地图级别
    self.mapView.showsUserLocation = YES; //是否显示定位图层
    self.mapView.delegate = self;
    self.mapView.buildingsEnabled = YES;


    
    self.mapView.mapScaleBarPosition = CGPointMake(100, 100);
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

}

// 复位
- (IBAction)notePressed:(id)sender {
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(self.myLocationCoordModel.focusLatitude.floatValue, self.myLocationCoordModel.focusLongitude.floatValue);
    self.mapView.zoomLevel = 17.95;
    [self configurationLocationButtonTitle:CLLocationCoordinate2DMake(self.myLocationCoordModel.focusLatitude.floatValue, self.myLocationCoordModel.focusLongitude.floatValue)];
    self.currentRoomId = self.myLocationCoordModel.roomId;
}

// 足迹
- (IBAction)footprintPressed:(id)sender {
    [HHTool showSucess:@"该功能暂未开通，敬请期待~"];
//    MapFootprintViewController  *footprintVC = [[MapFootprintViewController alloc]initWithType:0];
//    [self pushPage:footprintVC
//          Animated:YES];
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

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{
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
    

    
}


//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //从manager获取左边
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;//位置坐标
    self.pt = coordinate;
    [SCCacheTool shareInstance].pt = coordinate;
    if (!self.isLBS) {
        self.mapView.centerCoordinate = coordinate;
        if(self.mapView.annotations.count == 0){
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            annotation.coordinate = coordinate;
            annotation.title = @"您当前位置";
            [self.mapView addAnnotation:annotation];
        }
    }
    
    if ((userLocation.location.coordinate.latitude != 0 || userLocation.location.coordinate.longitude != 0))
    {
        //发送反编码请求
        //[self sendBMKReverseGeoCodeOptionRequest];
        
        NSString *latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
        self.latitude = latitude;
        NSString *longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
        self.longitude = longitude;
        
        
        
        [self sc_getLbsCoordinate];// 上传用户实时坐标获取聊天室
       // [self configurationLocationButtonTitle:coordinate];
//        [self reverseGeoCodeWithLatitude:latitude withLongitude:longitude];
        
    }else{
        NSLog(@"位置为空");
    }
    
    //关闭坐标更新
   // [self.locService stopUserLocationService];
}

- (void)configurationLocationButtonTitle:(CLLocationCoordinate2D)coordinate{
    
    NSString  *sc_E = NSLocalizedString(@"sc_E", nil);
    NSString  *sc_W = NSLocalizedString(@"sc_W", nil);
    NSString  *sc_N = NSLocalizedString(@"sc_N", nil);
    NSString  *sc_S = NSLocalizedString(@"sc_S", nil);
    
    
    NSString *long_title = coordinate.longitude > 0 ?sc_E:sc_W;
    NSString *lat_title = coordinate.latitude > 0 ?sc_N:sc_S;
    NSString  *roomName = [NSString stringWithFormat:@"%@%.2f°%@%.2f°",long_title,coordinate.longitude,lat_title,coordinate.latitude];
    [self.locationBtn setTitle:roomName forState:0];
    self.currentRoomName = roomName;
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
        annotationView.enabled3D = YES;
        annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop=YES;         //设置标注动画显示，默认为NO
        annotationView.draggable = YES;          //设置标注可以拖动，默认为NO
        annotationView.image = [UIImage imageNamed:@"sc_com_icon_myPosition"];
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
    
    if ([overlay isKindOfClass:[BMKPolygon class]]){
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0 blue:0.5 alpha:1];
//        polygonView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:0.2];
        polygonView.lineWidth =2.0;
        polygonView.lineDash = YES;
        
        return polygonView;
    }
    
    return nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedBMKOverlayView:(BMKOverlayView *)overlayView{
    NSLog(@"onClickedBMKOverlayView");
    
}


- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    NSString  *latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString  *longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    weakify(self);
    [HHTool show:@"正在为您查找当前地址匹配的广场..."];
    [[SCNetwork shareInstance] getWithUrl:COORDINATEINFO parameters:@{@"latitude":latitude,@"longitude":longitude} success:^(id responseObject) {
        [HHTool dismiss];
        NSDictionary  *dic = responseObject[@"data"];
        if (dic.allValues > 0) {
            CoordnateInfosModel  *model = [CoordnateInfosModel yy_modelWithDictionary:dic];
            [weak_self sc_configurationMapViewCenterLocationWithModel:model];
            __block  BOOL isContainRoom = NO;
            [self.mapView.overlays enumerateObjectsUsingBlock:^(BMKPolygon *  _Nonnull polygon, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([polygon.mark isEqualToString:model.roomId]) {
                    isContainRoom = YES;
                }
            }];
            if (!isContainRoom) {
                [self sc_addOverlayWithModel:model];
            }
        }
    } failure:^(NSError *error) {
        [HHTool showError:error.localizedDescription];
    }];
}

#pragma mark -- 添加地址围栏
- (void)sc_addOverlayWithModel:(CoordnateInfosModel*)model{
    CLLocationCoordinate2D coor[4] = {0};
    for (int i = 0; i < model.coordinates.count; i++) {
        CLLocationCoordinate2D transfromCoord =  CLLocationCoordinate2DMake(model.coordinates[i].latitude.doubleValue, model.coordinates[i].longitude.doubleValue);
        CLLocationCoordinate2D transToCoord = [self BD09TransfromGPSCoordinateFrom:transfromCoord];
        coor[i].latitude = transToCoord.latitude;
        coor[i].longitude = transToCoord.longitude;
    }
    BMKPolygon*  polygon = [BMKPolygon polygonWithCoordinates:coor count:4];
    polygon.mark = model.roomId;
    [_mapView addOverlay:polygon];
}

- (void)sc_configurationMapViewCenterLocationWithModel:(CoordnateInfosModel*)model{
    self.mapView.centerCoordinate = [self BD09TransfromGPSCoordinateFrom:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    self.mapView.zoomLevel = 17.95;
    [self configurationLocationButtonTitle:self.mapView.centerCoordinate];
    self.currentRoomId = model.roomId;
}

// 坐标转换 BD09 -> GPS
- (CLLocationCoordinate2D)BD09TransfromGPSCoordinateFrom:(CLLocationCoordinate2D)transfromCoord{
    return transfromCoord;
    //return  BMKCoordTrans(transfromCoord,BMK_COORDTYPE_GPS,BMK_COORDTYPE_BD09LL);
}

- (IBAction)joinPressed:(id)sender{
    
   // [HHTool mainWindow].rootViewController = nil;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"kJCCurrentUserName"]){
//        JCMainTabBarController  *tabBarVC = [[JCMainTabBarController alloc]init];
//        [HHTool mainWindow].rootViewController = tabBarVC;
//        JCConversationListViewController *chatListView = [[JCConversationListViewController alloc]init];
//         [self.navigationController pushViewController:chatListView animated:YES];
        
        if ([SCCacheTool shareInstance].isJGSetup) {
            [self getAllChatRoomConversation];
        }else{
            [HHTool show:@"正在获取该元社区信息，请稍等"];
            self.isClickJoin = YES;
        }
        
    }else{
        SCLoginController *loginVC=[[SCLoginController alloc]init];
        [HHTool mainWindow].rootViewController = [[SCBaseNavigationController alloc]initWithRootViewController:loginVC];
//        JCNavigationController *nav = [[JCNavigationController alloc]initWithRootViewController:[JCLoginViewController new]];
//        [HHTool mainWindow].rootViewController = nav;

    }
}






- (void)jg_automaticLoginComplete:(dispatch_block_t)complete{
    [JGUserLoginService jg_automaticLoginWithLoginComplete:^(id _Nullable result, NSError * _Nullable error) {
        if (!error) {
            BLOCK_EXEC(complete);
        }else{
            [HHTool showError:error.localizedDescription];
            return ;
        }
    }];
}

- (void)createChatRoomConversation{
    // 创建会话 有的话直接返回
    weakify(self);
    [JGUserLoginService
     jg_createChatRoomConversationWithRoomId:self.currentRoomId callBlock:^(JMSGConversation * _Nullable conversation, NSError * _Nullable error) {
         if (!error) {
              [weak_self enterChatRoom];
             return ;
         }
         if (error.code == 863004) {
             // 未登录
             [weak_self jg_automaticLoginComplete:^{
                 [weak_self enterChatRoom];
             }];
         }
         [HHTool showError:error.localizedDescription];
     }];
}

- (void)getAllChatRoomConversation{
    weakify(self);
    [JMSGConversation allChatRoomConversation:^(id resultObject, NSError *error) {
         strongify(self);
        if (error) {
            if (error.code == 863004) {
                // 未登录
                [self jg_automaticLoginComplete:^{
                    [self createChatRoomConversation];
                }];
            }else{
                [self createChatRoomConversation];
            }
            return ;
        }
        
        NSArray <JMSGConversation*> *conversations = resultObject;
        __block  BOOL  isEnter = NO;
        if (conversations.count > 0) {
            [conversations enumerateObjectsUsingBlock:^(JMSGConversation * _Nonnull conversation, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([conversation.target isKindOfClass:[JMSGChatRoom class]]) {
                    if ([((JMSGChatRoom*)conversation.target).roomID isEqualToString:self.currentRoomId]) {
                        [self enterChatRoom];
                        isEnter = YES;
                    }
                }
            }];
        }
        if (!isEnter) {
            [self createChatRoomConversation];
        }
    }];
}

// 加入聊天室
- (void)enterChatRoom{
    weakify(self);
    __block HHChatRoomViewController *roomVC;
    [EditInfoService enterChatRoomWithId:self.currentRoomId callBlock:^(JMSGConversation * resultObject, NSError *error) {
        strongify(self)
        roomVC = [[HHChatRoomViewController alloc]initWithConversation:resultObject isJoinChat:NO navTitle:self.currentRoomName];
        [self pushPage:roomVC Animated:YES];
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
       [self.view endEditing:YES];
  
}


@end

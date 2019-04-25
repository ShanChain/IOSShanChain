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
#import "NewYearActivitiesView.h"
#import "CommonShareModel.h"
#import "NewYearActiveInfoModel.h"
#import "NewYearActiveRushModel.h"

@interface BMKTestLocationViewController ()< UITableViewDelegate,CLLocationManagerDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate>{
     NSTimer  * _timer;
     NSTimer  * _timer1;
}
@property (nonatomic, strong)BMKLocationService *locService;
@property (nonatomic, strong)BMKGeoCodeSearch *searcher;
@property BOOL isGeoSearch;


@property (nonatomic,copy)   NSString  *latitude;
@property (nonatomic,copy)   NSString  *longitude;
@property (nonatomic,assign)  CLLocationCoordinate2D   pt;

@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@property (weak, nonatomic) IBOutlet UIButton *noteBtn;

@property (weak, nonatomic) IBOutlet UIButton *footprintBtn;

@property (weak, nonatomic) IBOutlet UIButton *collapseBtn;

@property (weak, nonatomic) IBOutlet UIButton *activeRuleBtn;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (nonatomic,assign)  BOOL    isLBS;
@property (nonatomic,assign)  BOOL    isClickJoin;

@property (nonatomic,strong)  NSArray  <CoordnateInfosModel*> *roomInfos;

@property (nonatomic,copy)    NSString   *currentRoomId; //当前的聊天室ID
@property (nonatomic,copy)    NSString   *currentLocationRoomId; //当前位置的聊天室ID

@property (nonatomic,strong)   CoordnateInfosModel   *myLocationCoordModel; //我当前位置所在的聊天室model
@property (nonatomic,copy)    NSString   *currentRoomName; //当前的聊天室名称


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *joinBtnBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *laveDayLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLb;

@property (nonatomic,strong)  UIImage  *takeImage;

@property (nonatomic,strong)  NewYearActiveInfoModel  *activeInfo;
@property (nonatomic,strong)  NewYearActiveRushModel  *activeInRush;

@property (nonatomic,assign)    BOOL    isActiveStar; //活动是否开始

@property (nonatomic,strong)    NewYearActivitiesView    *activeView;


@end

@implementation BMKTestLocationViewController
- (void)dealloc {
    NSLog(@"%s",__func__);
}
- (void)sc_ConfigurationUI{
    
    self.title = @"元社区";
   // [self.joinBtn _setCornerRadiusCircle];
    [self.noteBtn _setCornerRadiusCircle];
    [self.footprintBtn _setCornerRadiusCircle];
    
    [self.mapView bringSubviewToFront:self.topView];
    [self.mapView bringSubviewToFront:self.joinBtn];
    [self.mapView bringSubviewToFront:self.noteBtn];
    [self.mapView bringSubviewToFront:self.collapseBtn];
    [self.mapView bringSubviewToFront:self.footprintBtn];
    [self.mapView bringSubviewToFront:self.locationLb];
    [self.mapView bringSubviewToFront:self.activeRuleBtn];
    
    [self.collapseBtn setEnlargeEdgeWithTop:20 right:20 bottom:0 left:20];
    [self.topView mas_makeConstraints:^(MASConstraintMaker * x) {
        x.height.equalTo(@42);
        x.width.equalTo(@220);
        x.centerX.equalTo(self.view);
        x.top.equalTo(@(37 + IPHONE_TOPSENSOR_HEIGHT));
        //x.top.equalTo(self.mas_topLayoutGuide);
    }];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self pn_ConfigurationMapView];
    _locService = [[BMKLocationService alloc]init];//定位功能的初始化
    _locService.delegate = self;//设置代理位self
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    [_locService startUserLocationService];//启动定位服务
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kJMSGNetworkDidSetupNotification) name:kJMSGNetworkDidSetupNotification object:nil];
    [self.joinBtn setTitle:NSLocalizedString(@"sc_enter", nil) forState:0];
    //self.activeRuleBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
}

- (void)kJMSGNetworkDidSetupNotification{
    [HHTool immediatelyDismiss];
    if (self.isClickJoin) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self joinPressed:self.joinBtn];
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sc_ConfigurationUI];
    [self sc_newYearActive];
}


-(void)sc_newYearActiveInfo{
    
    self.isActiveStar = NO;
    
    // 活动开始时间
    MCDate *activeStartDate = [MCDate dateWithInterval:self.activeInfo.startTimeInterval];
    // 活动结束时间
    MCDate *activeEndDate = [MCDate dateWithInterval:self.activeInfo.endTimeInterval];
    
    // 活动已结束
    if ([activeEndDate isEarlierThanOrEqualTo:[MCDate date]]) {
        [self activeEnd];
        return;
    }
    
    [SCCacheTool shareInstance].isActivitying = YES;
    NSInteger  days = [activeStartDate daysFrom:[MCDate date]];
    if (days == 0) {
        NSInteger  second = [activeStartDate secondsFrom:[MCDate date]];
        if (second > 0) {
            days = 1;
        }
    }

    if (days >= 3) {
        self.activeRuleBtn.hidden = NO;
            // 活动倒计时未开始倒计时
        if ([[MCDate date] isEarlierThanOrEqualTo:activeStartDate]) {
            __weak typeof(self) weakSelf = self;
            _timer1 = [NSTimer bl_scheduledTimerWithTimeInterval:1 block:^{
                [weakSelf _startTiveCountdown];
            } repeats:YES];
//
//
//            _timer1 = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(_startTiveCountdown) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_timer1 forMode:NSRunLoopCommonModes];

        }
    }
    
    // 活动倒计时开始
    if (days > 0 && days < 3) {
        self.topView.hidden = NO;
        self.activeRuleBtn.hidden = NO;
        __weak typeof(self) weakSelf = self;
        _timer = [NSTimer bl_scheduledTimerWithTimeInterval:1 block:^{
            [weakSelf activeCountdown];
        } repeats:YES];
//        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(activeCountdown) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
//        self.laveDayLabel.attributedText = [NSString setAttrFirstString:[NSString stringWithFormat:@"%ld ",(long)days] color:[UIColor redColor] font:Font(18) secendString:NSLocalizedString(@"sc_NewYear_day", nil) color:Theme_MainTextColor font:Font(14)];
    }
    
    // 活动开始
    if ([activeStartDate isEarlierThanOrEqualTo:[MCDate date]]) {
        self.topView.hidden = YES;
        self.isActiveStar = YES;
        self.activeRuleBtn.hidden = NO;
        [self rushActiveStar:YES];
    }
}

// 活动开始倒计时倒计时
- (void)_startTiveCountdown{
     MCDate *activeStartDate = [MCDate dateWithInterval:self.activeInfo.startTimeInterval];
    NSInteger  count = activeStartDate.date.timeIntervalSince1970 - NSDate.date.timeIntervalSince1970;
    if (count <= 3 * 24 * 60 * 60) {
        [_timer1 invalidate];
        _timer1 = nil;
        [self sc_newYearActiveInfo];
    }
}

// 活动开始倒计时
- (void)activeCountdown{
    
    NSInteger  timeInterval = self.activeInfo.startTimeInterval - [NSDate date].timeIntervalSince1970;
    if (timeInterval == 0) {
        // 活动开始
        self.topView.hidden = YES;
        self.isActiveStar = YES;
        [self rushActiveStar:YES];
        [_timer invalidate];
        _timer = nil;
    }else{
       
        int days = (int)(timeInterval/(3600*24));
        int hours = (int)((timeInterval-days*24*3600)/3600);
        int minute = (int)(timeInterval-days*24*3600-hours*3600)/60;
        NSInteger second = timeInterval - days*24*3600 - hours*3600 - minute*60;
        self.laveDayLabel.text = [NSString stringWithFormat:@"%02ld : %02ld : %02ld",  (long)hours + days * 24, (long)minute, (long)second];
    }
}

#pragma mark -- 新年活动
-(void)sc_newYearActive{
    
    [[SCNetwork shareInstance]HH_GetWithUrl:NewYearActiveInfo_URL parameters:@{} showLoading:NO callBlock:^(HHBaseModel *baseModel, NSError *error){
        if (error) {
            [HHTool showError:error.localizedDescription];
            return;
        }
        
        self.activeInfo = [NewYearActiveInfoModel yy_modelWithDictionary:baseModel.data];
        if (self.activeInfo.startTime && self.activeInfo.endTime) {
            [self sc_newYearActiveInfo];
        }else{
            [self activeEnd];
        }
    }];
    
    
    [[SCNetwork shareInstance]HH_GetWithUrl:RedPaperObtainList_URL parameters:@{@"characterId":[SCCacheTool shareInstance].getCurrentCharacterId,@"userId":[SCCacheTool shareInstance].getCurrentUser,@"size":@(2),@"page":@(0)} showLoading:NO callBlock:^(HHBaseModel *baseModel, NSError *error) {
         NSArray  *datas = baseModel.data[@"content"];
        if (datas.count > 0) {
           //  福包领取
            AppointmentMyReceiveView *receiveView = [[AppointmentMyReceiveView alloc]initWithFrame:self.view.frame];
            [self.view addSubview:receiveView];
           
            
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.mapView viewWillAppear];
  //  self.navigationController.navigationBarHidden = YES;
    if (self.isAddChatRoom) {

//        [[HHTool getCurrentVC] sc_hrShowAlertWithTitle:@"选择需要创建元社区的区域" message:nil buttonsTitles:@[@"好的👌"] andHandler:nil];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择需要创建元社区的区域" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的👌" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
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

// 获取区域截图
- (void)getTakeSnapshot{
    weakify(self);
    [self sc_mapViewRestoration:^{
        strongify(self);
        __block CGPoint point0;
        __block CGPoint point2;
        [self.myLocationCoordModel.coordinates enumerateObjectsUsingBlock:^(CoordnateInfosModel_coordinates * _Nonnull coordinate, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                point0 = [self.mapView convertCoordinate:CLLocationCoordinate2DMake(coordinate.latitude.floatValue, coordinate.longitude.floatValue) toPointToView:self.mapView];
            }else if (idx == 2){
                point2 = [self.mapView convertCoordinate:CLLocationCoordinate2DMake(coordinate.latitude.floatValue, coordinate.longitude.floatValue) toPointToView:self.mapView];
            }
        }];
        
        
        UIImage  *takeImage = [self.mapView takeSnapshot:CGRectMake(point0.x, point2.y, point2.x - point0.x, point0.y - point2.y)];
        self.takeImage = [takeImage mc_resetToSize:CGSizeMake(point2.x - point0.x,  point0.y - point2.y)];
        [SCCacheTool shareInstance].takeImage = self.takeImage;
    }];
}

- (void)sc_getLbsCoordinate{
    if (!self.latitude || !self.longitude || self.isLBS) {
        return;
    }
    self.isLBS = YES;
    weakify(self);
    
    [[SCNetwork shareInstance]HH_GetWithUrl:COORDINATEINFO parameters:[self getParameter] showLoading:NO callBlock:^(HHBaseModel *baseModel, NSError *error) {
        if (error) {
            return ;
        }
        CoordnateInfosModel  *model = [CoordnateInfosModel yy_modelWithDictionary:baseModel.data];
        weak_self.myLocationCoordModel = model;
        weak_self.currentLocationRoomId = model.roomId;
        [weak_self sc_mapViewRestoration:nil];
        [weak_self sc_addOverlayWithModel:model];
        
    }];
    
    [[SCNetwork shareInstance]HH_GetWithUrl:GETCOORDINATE parameters:[self getParameter] showLoading:NO callBlock:^(HHBaseModel *baseModel, NSError *error) {
        if (error) {
//            weak_self.isLBS = NO;
            return ;
        }
          NSArray  *arr = baseModel.data[@"room"];
        if(arr.count > 0){
            NSMutableArray  *mAry = [NSMutableArray arrayWithCapacity:0];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                CoordnateInfosModel  *model = [CoordnateInfosModel yy_modelWithDictionary:dic];
                if (idx == 0) {
                    weak_self.myLocationCoordModel = model;
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
    }];
}



- (void)setChatRoomCenterPoint{
    CoordnateInfosModel *model = self.roomInfos.firstObject;
    [self sc_configurationMapViewCenterLocationWithModel:model];
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
    self.mapView.zoomLevel = 16;//地图级别
    self.mapView.showsUserLocation = YES; //是否显示定位图层
    self.mapView.delegate = self;
    self.mapView.buildingsEnabled = YES;
//    self.mapView.baiduHeatMapEnabled = YES;
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
            }];
        }
    }];

}

- (IBAction)activeRuleAction:(UIButton *)sender {
    
    // 活动规则
    NewYearActivityRuleView *ruleView =  [[NewYearActivityRuleView alloc]initWithRuleDes:self.activeInfo.ruleDescribe frame:self.view.frame];
    [self.view addSubview:ruleView];
    
}


// 复位
- (IBAction)notePressed:(id)sender {
    
    NSString  *latitude = [NSString stringWithFormat:@"%f",self.pt.latitude];
    NSString  *longitude = [NSString stringWithFormat:@"%f",self.pt.longitude];
    weakify(self);
    [HHTool showChrysanthemum];
    [[SCNetwork shareInstance] getWithUrl:COORDINATEINFO parameters:@{@"latitude":latitude,@"longitude":longitude} success:^(id responseObject) {
        [HHTool immediatelyDismiss];
        NSDictionary  *dic = responseObject[@"data"];
        if (dic.allValues > 0) {
            CoordnateInfosModel  *model = [CoordnateInfosModel yy_modelWithDictionary:dic];
            weak_self.myLocationCoordModel = model;
            [weak_self sc_mapViewRestoration:nil];
        }
    } failure:^(NSError *error) {
        [HHTool showError:error.localizedDescription];
    }];
    
}

- (void)sc_mapViewRestoration:(dispatch_block_t)callback{

    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(self.myLocationCoordModel.focusLatitude.floatValue, self.myLocationCoordModel.focusLongitude.floatValue);
    self.mapView.zoomLevel = 17.95;
    [self configurationLocationButtonTitle:CLLocationCoordinate2DMake(self.myLocationCoordModel.focusLatitude.floatValue, self.myLocationCoordModel.focusLongitude.floatValue)];
    self.currentRoomId = self.myLocationCoordModel.roomId;
    
    BLOCK_EXEC(callback);
}

#pragma 热门元社区
- (IBAction)footprintPressed:(id)sender {
    
    PopularCommunityViewController *popularVC = [[PopularCommunityViewController alloc]init];
    [self pushPage:popularVC Animated:YES];
}


- (void)configurationCreatChatRoomAlertLatitude:(NSString *)latitude Longitude:(NSString *)longitude {

    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入元社区名称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *creatAction = [UIAlertAction actionWithTitle:@"创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *field = alert.textFields.firstObject;
        NSLog(@"text = %@", field.text);
        
        
        
        if (field.text.length > 0) {
            
            [HHTool showChrysanthemum];
            
            [SCAliyunUploadMananger uploadImage:self.takeImage withCompressionQuality:0.5 withCallBack:^(NSString *url) {
                
                if (!NULLString(url)) {
                    NSDictionary *params = @{
                                             @"latitude":latitude,
                                             @"longitude":longitude,
                                             @"roomName":field.text,
                                             @"thumbnails":url
                                             };
                    
                    [[SCNetwork shareInstance]HH_postWithUrl:ADDCHATROOM params:params showLoading:NO callBlock:^(HHBaseModel *baseModel, NSError *error) {
                        SCLog(@"code:%@msg:%@",baseModel.code,baseModel.message);
                        if ([baseModel.message isEqualToString:@"ok"]) {
                            
                            [HHTool immediatelyDismiss];
                            
                            NSDictionary *data = (NSDictionary *)baseModel.data;
                            NSDictionary *hotChatRoomDic = data[@"hotChatRoom"];
                            NSString *roomId = hotChatRoomDic[@"roomId"];
                            NSString *roomName = hotChatRoomDic[@"roomName"];
                            if ([SCCacheTool shareInstance].isJGSetup) {
                                
                                [JGUserLoginService jg_enterchatRoomWithRoomId:roomId callBlock:^(JMSGConversation * _Nullable Conversation, NSError * _Nullable error) {
                                    
                                    HHChatRoomViewController *roomVC = [[HHChatRoomViewController alloc]initWithConversation:Conversation isJoinChat:NO navTitle:roomName];
                                    [self pushPage:roomVC Animated:YES];
                                }];
                            }else{
                                [HHTool show:NSLocalizedString(@"sc_map_Loading", nil)];
                            }
                            
                            if (self.addChatRoomBlock) {
                                self.addChatRoomBlock();
                            }
                        }
                    }];
                }
            } withErrorCallBack:^(NSError *error) {
                [HHTool showError:error.localizedDescription];
                
            }];
        } else {
            [HHTool showTip:@"请输入元社区名称" duration:0.5];
        }
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"例如：x x x 社区";
    }];
    
    [alert addAction:creatAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
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
//    long long delta = [Util getSystemTime];
//    SCLog(@"当前时间戳---->%lld",delta);
    //从manager获取左边
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;//位置坐标
    self.pt = coordinate;
    [SCCacheTool shareInstance].pt = coordinate;
    if (!self.isLBS) {
        self.mapView.centerCoordinate = coordinate;
        if(self.mapView.annotations.count == 0){
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            annotation.coordinate = coordinate;
            annotation.title = NSLocalizedString(@"sc_map_Imhere", nil);
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
    
    NSString  *roomName;
    
    NSString *long_title = coordinate.longitude > 0 ?sc_E:sc_W;
    NSString *lat_title = coordinate.latitude > 0 ?sc_N:sc_S;
    
    NSString  *language = [HHTool getPreferredLanguage];
    
    if ([language isEqualToString:@"zh-Hans-CN"]) {
          roomName = [NSString stringWithFormat:@"%@%.2f° %@%.2f°",long_title,coordinate.longitude,lat_title,coordinate.latitude];
    }else{
          roomName = [NSString stringWithFormat:@"%.2f°%@ %.2f°%@",coordinate.longitude,long_title,coordinate.latitude,lat_title];
    }
    
  
    self.locationLb.text = roomName;
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
            if ([pointAnnotation.title isEqualToString:NSLocalizedString(@"sc_map_Imhere", nil)]) {
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
    
    
    weakify(self);
    NSString  *latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    self.latitude = latitude;
    NSString  *longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    self.longitude = longitude;
    
    if (self.isAddChatRoom) {
        
        NSDictionary *parameters = @{
                                     @"latitude":latitude,
                                     @"longitude":longitude,
                                     @"token":[[SCCacheTool shareInstance] getUserToken]
                                     };
        [[SCNetwork shareInstance] getWithUrl:ADDCHATROOM_COORDINATEINFO parameters:parameters success:^(id responseObject) {
            NSDictionary  *dic = responseObject[@"data"];
            if (dic.allValues > 0) {
                [weak_self getTakeSnapshot];
                CoordnateInfosModel  *model = [CoordnateInfosModel yy_modelWithDictionary:dic];
                [weak_self sc_configurationMapViewCenterLocationWithModel:model];
                [weak_self sc_addOverlayWithModel:model];
                [weak_self configurationCreatChatRoomAlertLatitude:latitude Longitude:longitude];
            }
        } failure:^(NSError *error) {
            [HHTool showError:error.localizedDescription];
        }];
        
    }else {
        
        [HHTool show:NSLocalizedString(@"sc_map_Locating", nil)];
        [[SCNetwork shareInstance] getWithUrl:COORDINATEINFO parameters:@{@"latitude":latitude,@"longitude":longitude} success:^(id responseObject) {
            [HHTool immediatelyDismiss];
            NSDictionary  *dic = responseObject[@"data"];
            if (dic.allValues > 0) {
                CoordnateInfosModel  *model = [CoordnateInfosModel yy_modelWithDictionary:dic];
                //self.myLocationCoordModel = model;
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
    
    
    
    if (self.isActiveStar) {
        [self rushActiveStar:NO];
    }
}

// 活动结束
- (void)activeEnd{
    self.isActiveStar = NO;
    self.activeRuleBtn.hidden = YES;
    self.activeView.hidden = YES;
    self.topView.hidden = YES;
    [SCCacheTool shareInstance].isActivitying = NO;
}

-(NewYearActivitiesView *)activeView{
    if (!_activeView) {
        _activeView = [[NewYearActivitiesView alloc]initWithFrame:CGRectMake(40, IPHONE_TOPSENSOR_HEIGHT, SCREEN_WIDTH - 80, 70) activeEndInterval:self.activeInfo.endTimeInterval];
    }
    return _activeView;
}

// 活动闯关  isQuery:是否只做查询
- (void)rushActiveStar:(BOOL)isQuery {
    
    [[SCNetwork shareInstance]HH_GetWithUrl:NewYearActiveRush_URL parameters:@{@"currentUserId":SCCacheTool.shareInstance.getCurrentUser,@"currentCharaterId":SCCacheTool.shareInstance.getCurrentCharacterId,@"action": isQuery? @"query ":@"",@"latitude":self.latitude ?:@"",@"longitude":self.longitude ?:@""} showLoading:NO callBlock:^(HHBaseModel *baseModel, NSError *error) {
        if (error) {
            return ;
        }
        
        NewYearActiveRushModel  *rushModel = [NewYearActiveRushModel yy_modelWithDictionary:baseModel.data];
        if (rushModel.rushActivityVo.clearance ||  self.activeInfo.endTimeInterval <= NSDate.date.timeIntervalSince1970) {
            [self activeEnd];
            return;
        }
        
        if (!self.activeView.superview) {
            [self.mapView addSubview:self.activeView];
            [self.mapView bringSubviewToFront:self.activeView];
        }
        
        [self.activeView setActiveRushModel:rushModel];
        weakify(self)
        self.activeView.activeEndBlock = ^{
            [weak_self activeEnd];
            [weak_self hrShowAlertWithTitle:@"点亮元社区活动已结束" message:@"快去【我的钱包】中看看你赢得了多少奖励吧！" buttonsTitles:@[@"确定"] andHandler:^(UIAlertAction * _Nullable action, NSInteger indexOfAction) {
                
            }];
            
        };
        // 分享
        if (rushModel.rushActivityVo.surplusCount.integerValue == 0) {
            [self shareActiveRewardWithLevel:rushModel.rushActivityVo.level.integerValue];
        }
        
    }];
}

- (void)shareActiveRewardWithLevel:(NSInteger)level{
    weakify(self);
    [PublicShareService commonShareWith:level == 4 ? HHShareType_IMAGE:HHShareType_WEBPAGE callBlock:^(HHBaseModel *baseModel, NSError *error) {
        CommonShareModel  *shareModel = [CommonShareModel yy_modelWithDictionary:baseModel.data];
            // 活动分享
        HHShareView  *shareView = [[HHShareView alloc]initWithFrame:self.view.frame shareImage:nil type:level == 4? level:3 shareModel:shareModel];
            [self.view addSubview:shareView];
        shareView.closure = ^{
            [weak_self rushActiveStar:YES];
        };
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


- (IBAction)collapseAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [UIView animateWithDuration:0.35 animations:^{
        if (sender.selected) {
            [sender setImage:[UIImage imageNamed:@"sc_com_icon_show"] forState:0];
            self.joinBtnBottomConstraint.constant = IS_IPHONE_X? IPHONE_SAFEBOTTOMAREA_HEIGHT - 128: - 128;
        }else{
            self.joinBtnBottomConstraint.constant = 71;
            [sender setImage:[UIImage imageNamed:@"sc_com_icon_collapse"] forState:0];
        }
        [self.view layoutIfNeeded];
    }];
    
   
}

- (IBAction)joinPressed:(id)sender{
    
    __block  BOOL  _status = NO;
    [self appNetworkStatus:^(AFNetworkReachabilityStatus status) {
        if (status > 0) {
            _status = YES;
        }
    }];
    if (!self.currentRoomId._notEmpty && _status) {
        [HHTool showTip:NSLocalizedString(@"sc_map_Loading", nil) duration:0.8];
        return;
    }
   // [HHTool mainWindow].rootViewController = nil;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"kJCCurrentUserName"]){
//        JCMainTabBarController  *tabBarVC = [[JCMainTabBarController alloc]init];
//        [HHTool mainWindow].rootViewController = tabBarVC;
//        JCConversationListViewController *chatListView = [[JCConversationListViewController alloc]init];
//         [self.navigationController pushViewController:chatListView animated:YES];
        
        if ([SCCacheTool shareInstance].isJGSetup) {
            [HHTool showChrysanthemum];
//            [self getAllChatRoomConversation];
            NSString *roomId = self.currentRoomId;
            if (NULLString(self.currentRoomId)) {
                roomId = self.currentLocationRoomId;
            }
            [JGUserLoginService jg_enterchatRoomWithRoomId:roomId callBlock:^(JMSGConversation * _Nullable Conversation, NSError * _Nullable error) {
                [self getTakeSnapshot];
                HHChatRoomViewController *roomVC = [[HHChatRoomViewController alloc]initWithConversation:Conversation isJoinChat:NO navTitle:self.currentRoomName];
                [self pushPage:roomVC Animated:YES];
            }];
        }else{
            [HHTool show:NSLocalizedString(@"sc_map_Loading", nil)];
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


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
       [self.view endEditing:YES];
}


@end

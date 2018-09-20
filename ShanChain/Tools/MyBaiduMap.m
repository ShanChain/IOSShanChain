//
//  MyBaiduMap.m
//  smartapc-ios
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 list. All rights reserved.
//

#import "MyBaiduMap.h"

@implementation CustomPointAnnotation

@end

@interface MyBaiduMap()<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
{
    BOOL _isSetMapSpan;
}
@property (nonatomic, strong) BMKLocationService *locService; // 获取当前位置
@property (nonatomic, strong) BMKGeoCodeSearch  *geoCodeSearch; // 根据地址获取地理位置

@end

@implementation MyBaiduMap

#pragma mark -

DEF_SINGLETON(MyBaiduMap);

// 初始化百度地图
- (BMKMapView *)mapView {
    if (_mapView == nil) {
        _mapView                    = [[BMKMapView alloc] init];
        _mapView.mapType            = BMKMapTypeStandard;                   // 标准图
        _mapView.showsUserLocation  = YES;                                  // 是否显示定位图层（即我的位置的小圆点）
        _mapView.zoomLevel          = 19;                                   // 地图显示比例
        _mapView.minZoomLevel       = 12;
        _mapView.rotateEnabled      = YES;                                  // 设置是否可以旋转
        _mapView.overlooking        = 0;
    }
    return _mapView;
}

- (void)mapViewWillAppear {
    if (_mapView) {
        _mapView.delegate = self;
    }
}

- (void)mapViewWillDisappear {
    if (_mapView) {
        _mapView.delegate = nil;
    }
}

- (void)flyToTargetWithLat:(double)lat lng:(double)lng {
    CLLocationCoordinate2D coor;
    coor.latitude   = lat;
    coor.longitude  = lng;
    if (_mapView) {
        if (!_isSetMapSpan) { // 这里用一个变量判断一下,只在第一次锁定显示区域时 设置一下显示范围 Map Region
            _isSetMapSpan = YES;
            BMKCoordinateRegion viewRegion      = BMKCoordinateRegionMakeWithDistance(coor, 200, 200);
            BMKCoordinateRegion adjustedRegion  = [_mapView regionThatFits:viewRegion];
            [_mapView setRegion:adjustedRegion animated:YES];
        }
        
        [_mapView setCenterCoordinate:coor animated:YES];
    }
}

#pragma mark - 地址位置正向检索
- (void)mapViewGeoCodeSearchWithCityName:(NSString *)cityName address:(NSString *)address {
    if (!_geoCodeSearch) {
        _geoCodeSearch =[[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
    }
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= cityName;
    geoCodeSearchOption.address = address;
    
    BOOL flag = [_geoCodeSearch geoCode:geoCodeSearchOption];
    if(flag) {
        //LOG(@"GeoCodeSearch检索发送成功");
    } else {
        //LOG(@"GeoCodeSearch检索发送失败");
    }
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher
                    result:(BMKGeoCodeResult *)result
                 errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
    } else {
        //LOG(@"抱歉，GeoCodeSearch未找到结果");
    }
}


#pragma mark - 定位
- (void)mapViewStartLocation {
    if (!_locService) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    [_locService startUserLocationService];
}

//处理位置坐标更新回调
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    double lat = userLocation.location.coordinate.latitude;
    double lng = userLocation.location.coordinate.longitude;
    //LOG(@"didUpdateUserLocation lat %f,long %f",lat, lng);
    
    if (!_geoCodeSearch) {
        _geoCodeSearch =[[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
    }
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){lat, lng};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
      //LOG(@"反geo检索发送成功");
    }
    else
    {
      //LOG(@"反geo检索发送失败");
    }
}

//接收反向地理编码结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      //在此处理正常结果
      NSString *strProvince = result.addressDetail.province;//省份
      NSString *strCity = result.addressDetail.city;//城市
      NSString *strDistrict = result.addressDetail.district;//地区
      //LOG(@"省份: %@ 城市: %@ 地区: %@",strProvince,strCity,strDistrict);
  }
  else {
      //LOG(@"抱歉，未找到结果");
  }
}

#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    /*
    if (_mapView) {
        [_mapView setCompassPosition:CGPointMake(10, 10)];
    }
     */
}

#pragma mark -

/*
#pragma  地图的显示的代理
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[CustomPointAnnotation class]]) {
        newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        newAnnotationView.frame=CGRectMake(0, 0, 56, 56);
        newAnnotationView.image=[UIImage imageNamed:@"bottom04"];
        
        //城区
        _cityLabel.frame=CGRectMake(10,14,36, 12);
        _cityLabel.font = [UIFont systemFontOfSize:12];
        _cityLabel.adjustsFontSizeToFitWidth=YES;
        _cityLabel.textAlignment=NSTextAlignmentCenter;
        _cityLabel.textColor = RGB(255, 255, 255);
        [newAnnotationView addSubview:_cityLabel];
        
        //城区数量
        _cityCountLabel.frame=CGRectMake(10, 14+12+6, 36, 12);
        _cityCountLabel.font=[UIFont systemFontOfSize:12];
        _cityCountLabel.textColor = RGB(255, 255, 255);
        _cityCountLabel.textAlignment=NSTextAlignmentCenter;
        [newAnnotationView addSubview:_cityCountLabel];
        
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
        return newAnnotationView;
    }
    if ([annotation isKindOfClass:[CustomPointAnnotation1 class]]) {
        newAnnotationView1 = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation1"];
        newAnnotationView1.frame=CGRectMake(0, 0, 56, 56);
        newAnnotationView1.image=[UIImage imageNamed:@"bottom04"];
        
        //城区
        _regionLabel.frame=CGRectMake(10,14,36, 12);
        _regionLabel.font = [UIFont systemFontOfSize:12];
        _regionLabel.adjustsFontSizeToFitWidth=YES;
        _regionLabel.textAlignment=NSTextAlignmentCenter;
        _regionLabel.textColor = RGB(255, 255, 255);
        [newAnnotationView1 addSubview:_regionLabel];
        
        //城区数量
        _regionCountLabel.frame=CGRectMake(10, 14+12+6, 36, 12);
        _regionCountLabel.font=[UIFont systemFontOfSize:12];
        _regionCountLabel.textColor = RGB(255, 255, 255);
        _regionCountLabel.textAlignment=NSTextAlignmentCenter;
        [newAnnotationView1 addSubview:_regionCountLabel];
        
        
        newAnnotationView1.animatesDrop = NO;// 设置该标注点动画显示
        return newAnnotationView1;
    }
    if ([annotation isKindOfClass:[CustomPointAnnotation2 class]]) {
        newAnnotationView2 = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation2"];
        
        newAnnotationView2.frame=CGRectMake(0, 0, 44, 44);
        newAnnotationView2.image=[UIImage imageNamed:@"bottom05"];
        _buildCountLabel.frame=CGRectMake(0, 16, 44, 12);
        _buildCountLabel.font=[UIFont systemFontOfSize:12];
        _buildCountLabel.textColor = RGB(255, 255, 255);
        _buildCountLabel.textAlignment=NSTextAlignmentCenter;
        [newAnnotationView2 addSubview:_buildCountLabel];
        return newAnnotationView2;
        
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    //点击城区
    if ([view.annotation isKindOfClass:[CustomPointAnnotation class]]) {
        CustomPointAnnotation *ann = view.annotation;
        regionann=ann;
        //ann.id是城区id
        clickcity=YES;
        [self downloadRegionlist:ann.departID];
        
        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(ann.locy, ann.locx);
        BMKCoordinateSpan span = BMKCoordinateSpanMake(1, 1);
        BMKCoordinateRegion region = BMKCoordinateRegionMake(centerCoordinate, span);
        [mapView removeAnnotation:ann];
        [mapView setRegion:region];
    }
    //点击片区
    if ([view.annotation isKindOfClass:[CustomPointAnnotation1 class]])
    {
        clickregion = YES;
        CustomPointAnnotation1 * ann = view.annotation;
        bulidann=view.annotation;
        [self downloadbuildList:ann.departID];
        //ann.departID:是片区Id；
        
        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(ann.locy, ann.locx);
        BMKCoordinateSpan span = BMKCoordinateSpanMake(1, 1);
        BMKCoordinateRegion region = BMKCoordinateRegionMake(centerCoordinate, span);
        [_findMapView.mapView setRegion:region];
        
    }
    if([view.annotation isKindOfClass:[CustomPointAnnotation2 class]])
    {
        CustomPointAnnotation2 * ann = view.annotation;
        [self drawMapUI];
        [self downloadBuildDetail:ann.departID];
    }
    [mapView deselectAnnotation:view.annotation animated:YES];
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (clickregion && clickcity) {
        if (14<mapView.zoomLevel && mapView.zoomLevel<15) {
            [self downloadRegionlist:regionann.departID];
        }
    }
    
    if (clickcity) {
        if (mapView.zoomLevel<14 && mapView.zoomLevel>12) {
            if (self.clickchoose == YES) {
                [self downloadMaplist1];
            } else {
                [self downloadMaplist];
            }
        }
    }
    
}
*/

@end

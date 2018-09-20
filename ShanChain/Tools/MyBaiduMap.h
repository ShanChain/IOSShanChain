//
//  MyBaiduMap.h
//  smartapc-ios
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 list. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "Singleton.h"

@interface CustomPointAnnotation : BMKPointAnnotation

@property(nonatomic, strong) NSString *pointID;
@property(nonatomic, assign) double lat;
@property(nonatomic, assign) double lng;

@end

@interface MyBaiduMap : NSObject

@property (nonatomic, strong) BMKMapView *mapView;

AS_SINGLETON(MyBaiduMap);

@end

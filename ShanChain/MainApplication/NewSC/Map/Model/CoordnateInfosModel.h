//
//  CoordnateInfosModel.h
//  ShanChain
//
//  Created by 千千世界 on 2018/11/10.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoordnateInfosModel_coordinates;

@interface CoordnateInfosModel : NSObject

@property   (nonatomic,copy)  NSString  *roomId;
@property   (nonatomic,copy)  NSString  *roomName;
@property   (nonatomic,copy)  NSString  *focusLatitude;
@property   (nonatomic,copy)  NSString  *focusLongitude;
@property   (nonatomic,copy)  NSArray  <CoordnateInfosModel_coordinates*> *coordinates;

@property   (nonatomic,assign)  double  latitude;
@property   (nonatomic,assign)  double  longitude;

@end


@interface CoordnateInfosModel_coordinates : NSObject

@property   (nonatomic,copy)  NSString  *latitude;
@property   (nonatomic,copy)  NSString  *longitude;


@end

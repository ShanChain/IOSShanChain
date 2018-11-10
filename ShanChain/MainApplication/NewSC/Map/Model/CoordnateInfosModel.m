//
//  CoordnateInfosModel.m
//  ShanChain
//
//  Created by 千千世界 on 2018/11/10.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "CoordnateInfosModel.h"

@implementation CoordnateInfosModel


-(double)latitude{
    return self.focusLatitude.doubleValue;
}

-(double)longitude{
    return self.focusLongitude.doubleValue;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"coordinates" : [CoordnateInfosModel_coordinates class]};
}

@end

@implementation CoordnateInfosModel_coordinates


@end

//
//  SCAlertModule.h
//  ShanChain
//
//  Created by krew on 2017/10/25.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#ifndef SCDialogModule_h
#define SCDialogModule_h

#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>

@interface SCAlertModule : NSObject <RCTBridgeModule>

@property(nonatomic,strong)NSDictionary *options;

@end

#endif

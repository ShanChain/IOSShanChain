//
//  SystemInformationViewController.h
//  ShanChain
//
//  Created by 千千世界 on 2019/4/15.
//  Copyright © 2019 ShanChain. All rights reserved.
//

#import "SCBaseVC.h"


@interface SystemInformationViewController : SCBaseVC

@property (nonatomic, strong) NSMutableArray *systemInfo;

- (void)reloadViewWithNewObj:(NSDictionary *)obj;

@end

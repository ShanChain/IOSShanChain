//
//  EnvironmentConfiguration.h
//  ShanChain
//
//  Created by 千千世界 on 2018/9/13.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#ifndef EnvironmentConfiguration_h
#define EnvironmentConfiguration_h


#define Prtocol @"http://"


#define PN_ENVIRONMENT 0  // 2 测试环境   0 生产环境


#if PN_ENVIRONMENT == 0

#define HostName @"95.169.24.11"
#define PORT @"8081"
/******************************************/

#elif PN_ENVIRONMENT == 1

#define HostName @"95.169.24.11"
#define PORT @"8081"
/******************************************/

#elif PN_ENVIRONMENT == 2

#define HostName @"95.169.24.11"
#define PORT @"8081"

#else

#endif

#define Base_url [NSString stringWithFormat:@"%@%@:%@",Prtocol,HostName,PORT]

#endif /* EnvironmentConfiguration_h */

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


#define PN_ENVIRONMENT 0


#if PN_ENVIRONMENT == 0

#define HostName @"95.169.24.11"
#define PORT @"8081"
#define Base_url [NSString stringWithFormat:@"%@%@:%@",Prtocol,HostName,PORT]


#define SC_BASE_PORT_8082  @"http://95.169.24.11:8082"
#define SC_BASE_PORT_8083  @"http://95.169.24.11:8083"

/******************************************/

#elif PN_ENVIRONMENT == 1

#define HostName @"47.100.20.170"
#define Base_url [NSString stringWithFormat:@"%@%@",Prtocol,HostName]

#define SC_BASE_PORT_8082  Base_url
#define SC_BASE_PORT_8083  Base_url

/******************************************/

#elif PN_ENVIRONMENT == 2

#define HostName @"test.qianqianshijie.com"
#define Base_url [NSString stringWithFormat:@"%@%@",Prtocol,HostName]
#define SC_BASE_PORT_8082  Base_url
#define SC_BASE_PORT_8083  Base_url


#elif PN_ENVIRONMENT == 3

#define HostName @"api.qianqianshijie.com"
#define Base_url [NSString stringWithFormat:@"%@%@",Prtocol,HostName]
#define SC_BASE_PORT_8082  Base_url
#define SC_BASE_PORT_8083  Base_url


#else

#endif



#endif /* EnvironmentConfiguration_h */

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
//#define SC_APP_CHANNEL     @"appStore"
#define SC_APP_CHANNEL     @"pgyer"



#define PN_ENVIRONMENT 3   // 3 生产  2 测试


#if PN_ENVIRONMENT == 0

#define HostName @"67.218.159.56"
#define PORT @"9090"
#define Base_url [NSString stringWithFormat:@"%@%@:%@",Prtocol,HostName,PORT]


#define SC_BASE_PORT_8082  @"http://67.218.159.56:8082"
#define SC_BASE_PORT_8083  @"http://67.218.159.56:8083"
#define SC_BASE_PORT_8081  @"http://67.218.159.56:8081"

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
//#define HostName @"api.qianqianshijie.com"
#define Base_url [NSString stringWithFormat:@"%@%@",Prtocol,HostName]
#define SC_BASE_PORT_8082  Base_url
#define SC_BASE_PORT_8083  Base_url


#else

#define HostName @"2zgjurtx0g.51http.tech"
#define Base_url [NSString stringWithFormat:@"%@%@",Prtocol,HostName]
#define SC_BASE_PORT_8082  Base_url
#define SC_BASE_PORT_8083  Base_url

#endif



#endif /* EnvironmentConfiguration_h */

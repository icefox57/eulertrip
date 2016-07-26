//
//  Foundation.h
//  Youyue
//
//  Created by XiaoJun Hu on 11-9-8.
//  Copyright 2011年 apple energy . All rights reserved.
//


//API字段
#define API_ReturnData @"Data"
#define API_ErrorMessage @"message"
#define API_Head @"Basic"

#define API_OAuth_accesstoken @"access_token"
#define API_OAuth_deviceID    @"device_id"


typedef enum
{
    CRequestAccessToken = 0,
    CRequestAPI
} HttpRequestTypes;//模块类型


typedef enum
{
    MessageTypeNone   = 0,
    MessageTypeDL     = 1,//收货问题
    MessageTypeAG     = 2,//投诉建议
    MessageTypeQR     = 3,//二维码系统问题
    MessageTypeAdvice = 4,//活动政策问询
    MessageTypeOther  = 5,//其他
    MessageTypeLvUp   = 6//申请升级
} MessageTypes;//MessageTypes

typedef enum
{
    ChatTypeDisToDealer = 1,//分销商发给经销商
    ChatTypeDealerToDis = 2//经销商发给分销商
} ChatTypes;//ChatTypes

typedef enum
{
    StaticTypePointMBM   = 1,//逐月积分
    StaticTypePointMAM   = 2,//累月积分
    StaticTypeProductMBM = 3,//逐月机器
    StaticTypeProductMAM = 4//累月机器
} StaticTypes;//统计类型


#ifndef Debug_DbInterface_Status
#define Debug_DbInterface_Status 1
#endif

///-------------------------API---------------------------

#define clientId     @"3fb00702654adac9deceaf77"
#define clientSecret @"KaLXVmo9f0RBADXkBqjqE/2F/ytoSDdJ"



///-------------------------友盟---------------------------
#define UMAppKey                @"5794442367e58e6b8f004aaf"
#define AppDownloadSource @"App Store"

///-------------------------高德地图---------------------------
#define AmapAppKey @"82bef24c24e3be951744dfe5ec7597c8"

//-----------------------  系统函数  -------------------------------

#define UTColor(r,g,b,a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]
#define UTLocalizeString(s)                                                                NSLocalizedString(s,nil)

#define RANDOM_SEED()                                                           srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + arc4random() % ((__MAX__+1) - (__MIN__)))

//-----------------------  系统宏 -----------------------------
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

//-----------------------  系统基本变量 -----------------------------

#define ApplicationDelegate (AppDelegate *)[UIApplication sharedApplication].delegate

#define FIRE_TIME_KEY 10

//-----------------------  系统颜色值 ------------------------------

#define Bosch_Blue100   UTColor(0,38,64,1)
#define Bosch_Blue75    UTColor(26,69,99,1)
#define Bosch_Blue50    UTColor(74,114,142,1)
#define Bosch_Blue25    UTColor(143,168,185,1)
#define Bosch_BlueLight UTColor(71,149,182,1)
#define Bosch_Blue      UTColor(33,96,139,1)

#define Bosch_Red       UTColor(213,23,35,1)
#define Bosch_RedDark   UTColor(157,50,54,1)
#define Bosch_Gray      UTColor(98,100,100,1)
#define Bosch_GrayLight UTColor(216,216,216,1)
#define Bosch_Slive     UTColor(184,184,181,1)


#define Bosch_Green UTColor(1,143,2,1)
//-----------------------  UserDefaultKey ------------------------------
#define UD_UserInfo                                       @"currentUserDic"
#define UD_TempAccessToken                                @"temp_accesstoken"
#define UD_UserAccessToken                                @"user_accesstoken"
#define UD_refreshToken                                   @"refreshtoken "


//-----------------------  系统字符串 ------------------------------
#define LoadingMessage      UTLocalizeString(@"连接中...")
#define LoginTitleString    UTLocalizeString(@"登录")
#define InputUserNameString UTLocalizeString(@"请输入用户名")
#define InputPasswordString UTLocalizeString(@"请输入密码")
#define UserTitleString     UTLocalizeString(@"用户信息")


//-----------------Server Info------------
#define AppDBHost @"http://api.eulertrip.com/"

//Customer Value
#define EventRadius 200.0
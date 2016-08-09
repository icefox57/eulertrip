//
//  Foundation.h
//  Youyue
//
//  Created by XiaoJun Hu on 11-9-8.
//  Copyright 2011年 apple energy . All rights reserved.
//

//Error Code
#define SESSION_EXPIRED_CODE 401

//API字段
//Respone
#define API_ReturnData @"Data"
#define API_ReturnDataCount @"Total"
#define API_ReturnMessage @"Msg"
#define API_ReturnCode @"Code"

//Error
#define API_ErrorMessage @"Message"
//OAuth
#define API_Head @"Basic"

#define API_OAuth_accesstoken @"access_token"
#define API_OAuth_refreshtoken @"refresh_token"
#define API_OAuth_token_type @"token_type"
#define API_OAuth_expires_in @"expires_in"
#define API_OAuth_expires_date @"expires_date"
#define API_OAuth_deviceID    @"device_id"

//User
#define MD_User_Id @"Id"
#define MD_User_Birth @"Birth"
#define MD_User_NickName @"NickName"
#define MD_User_Sex @"Sex"
#define MD_User_Mobile @"Mobile"
#define MD_User_BirthLocal @"District"
#define MD_User_LiveLocal @"CurrentDistrict"
#define MD_User_School @"College"
#define MD_User_Speciality @"Speciality"
#define MD_User_BloodType @"BloodType"
#define MD_User_Favorites @"Favorites"

//calendar
#define MD_Calendar_Day @"Day"
#define MD_Calendar_DayType @"Type"
#define MD_Calendar_Memo @"Memo"



//-----------------------  UserDefaultKey ------------------------------
#define UD_UserInfo                             @"currentUserDic"
#define UD_TempAccessToken                      @"temp_accesstoken"
#define UD_UserAccessToken                      @"user_accesstoken"

#define UD_UserCredentialDic                    @"credentialDic"
#define UD_UserId                               @"user_id"
#define UD_SearchHistroyArray                   @"searchHistoryArray"
#define UD_CalendarDataDic                    @"calendarDataDic"


typedef enum
{
    CRequestAccessToken = 0,
    CRequestAPI
} HttpRequestTypes;//模块类型


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

#define color_tab_bg_white   UTColor(0,0,0,0.6)
#define color_common_red    UTColor(255,97,102,1)
#define color_vlight_gray    UTColor(0,0,0,0.2)


//-----------------------  系统字符串 ------------------------------
#define StringLoadingMessage      UTLocalizeString(@"连接中...")

//api error
#define StringErrorGetUserInfo     UTLocalizeString(@"获取用户信息失败!")

//login sigin
#define StringLoginAlertMoblie     UTLocalizeString(@"请输入您的手机号!")
#define StringLoginAlertPassword     UTLocalizeString(@"请输入您的密码!")
#define StringLoginAlertCode     UTLocalizeString(@"请输入验证码!")
#define StringLoginAlertCPassword     UTLocalizeString(@"请输入确认密码!")
#define StringLoginAlertCPWrong     UTLocalizeString(@"2次密码输入不相同!")
#define StringLoginAlertAgree     UTLocalizeString(@"您尚未同意协议!")
#define StringLoginAlertName     UTLocalizeString(@"请输入您的昵称!")
#define StringLoginAlertBirth     UTLocalizeString(@"请选择您的生日!")
#define StringLoginAlertSex     UTLocalizeString(@"请选择您的性别!")

//-----------------Server Info------------
#define AppDBHost @"http://api.eulertrip.com/"
//API
#define API_GetUser @"v1/User/GetUser"
#define API_GetSms @"v1/Sms/GetSms"
#define API_Register @"v1/User/Register"
#define API_BaseInfo @"v1/User/BaseInfo"
#define API_DetailInfo @"v1/User/DetailInfo"


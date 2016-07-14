//
//  Foundation.h
//  Youyue
//
//  Created by XiaoJun Hu on 11-9-8.
//  Copyright 2011年 apple energy . All rights reserved.
//


//数据库字段
#define Column_objectid                @"objectId"
#define Column_createdAt               @"createdAt"
#define Column_updatedAt               @"updatedAt"

#define Table_Distributor              @"distributor"
#define Distributor_distributorNo      @"distributorNo"
#define Distributor_userName           @"uname"
#define Distributor_userRole           @"role"
#define Distributor_saleName           @"salename"
#define Distributor_distributorName    @"distributorName"
#define Distributor_ownerName          @"OwnerName"
#define Distributor_userTel            @"tel"
#define Distributor_province           @"province"
#define Distributor_point              @"point"
#define Distributor_dealers            @"dealers"
#define Distributor_level              @"level"
#define Distributor_levelNum           @"LevelNum"
#define Distributor_limit              @"limit"
#define Distributor_disCount           @"disCount"
#define Distributor_dealerNo           @"dealerNo"
#define Distributor_dealerName         @"dealerName"
#define Distributor_newMessage         @"newMessage"
#define Distributor_address            @"address"
#define Distributor_disSalesName       @"disSalesName"
#define Distributor_disSalesPhone      @"disSalesPhone"
#define Distributor_password           @"password"
#define Distributor_locationStatus     @"status"

#define Table_Event                    @"Event"
#define Event_eventName                @"eventName"
#define Event_eventDescription         @"eventDescription"
#define Event_eventUrl                 @"eventUrl"
#define Event_eventStartDate           @"eventStartDate"
#define Event_eventEndDate             @"eventEndDate"
#define Event_eventImages              @"eventImages"
#define Event_detailImages             @"detailImages"
#define Event_distributorNos           @"distributorNos"

#define Table_EventPrize               @"EventPrize"
#define EventPrize_eventId             @"eventId"
#define EventPrize_prizeName           @"prizeName"
#define EventPrize_prizeCost           @"prizeCost"
#define EventPrize_prizeDescription    @"prizeDescription"
#define EventPrize_prizeImage          @"prizeImage"
#define EventPrize_prizeStock          @"prizeStock"
#define EventPrize_prizeType           @"prizeType"
#define EventPrize_prizelevel          @"prizeLevel"
#define EventPrize_prizeLevelNum       @"prizeLevelNum"
#define EventPrize_prizeUrl            @"prizeUrl"


#define Table_DistributorEvent         @"DistributorEvent"
#define DistributorEvent_eventId       @"eventId"
#define DistributorEvent_distributorNo @"distributorNo"
#define DistributorEvent_point         @"point"

#define Table_DistributorOrder         @"DistributorOrder"
#define DistributorOrder_eventId       @"eventId"
#define DistributorOrder_prizeId       @"prizeId"
#define DistributorOrder_distributorNo @"distributorNo"
#define DistributorOrder_deviNo        @"orderNo"
#define DistributorOrder_prizeNum      @"prizeNum"
#define DistributorOrder_status        @"status"

#define Table_Message                  @"Message"
#define Message_messageId              @"messageId"
#define Message_distributorNo          @"distributorNo"
#define Message_distributorName        @"distributorName"
#define Message_dealerNo               @"dealerNo"
#define Message_dealerName             @"dealerName"
#define Message_ctime                  @"ctime"
#define Message_messageType            @"messageType"
#define Message_messagStatus           @"messagStatus"
#define Message_chat                   @"chat"
#define Message_chatType               @"chatType"
#define Message_message                @"message"


typedef enum
{
	PrizeTypeBosch = 0,
	PrizeTypeOther
} PrizeTypes;//模块类型


typedef enum
{
    MessageTypeNone   = 0,
    MessageTypeDL     = 1, //收货问题
    MessageTypeAG     = 2, //投诉建议
    MessageTypeQR     = 3, //二维码系统问题
    MessageTypeAdvice = 4, //活动政策问询
    MessageTypeOther  = 5, //其他
    MessageTypeLvUp  = 6 //申请升级
} MessageTypes;//MessageTypes

typedef enum
{
    ChatTypeDisToDealer     = 1, //分销商发给经销商
    ChatTypeDealerToDis     = 2 //经销商发给分销商
} ChatTypes;//ChatTypes

typedef enum
{
    StaticTypePointMBM   = 1, //逐月积分
    StaticTypePointMAM   = 2, //累月积分
    StaticTypeProductMBM = 3, //逐月机器
    StaticTypeProductMAM = 4 //累月机器
} StaticTypes;//统计类型


#ifndef Debug_DbInterface_Status
#define Debug_DbInterface_Status 1
#endif

///-------------------------系统命名---------------------------
#define roleSale        @"销售"
#define roleDistributor @"分销商"
#define roleDealer      @"经销商"


#define UserDictionary @"UserDictionary"
#define ImageCaches @"ImageCaches"
#define ScanHistory @"ScanHistory"
#define TodayScanSum @"今日扫描合计"
#define LastDisCheckCountDate @"LastDisCheckCountDate"
#define LastDealerCheckCountDate @"LastDealerCheckCountDate"
#define DearlerCountDic @"DearlerCountDic"

///-------------------------友盟---------------------------
#define UMAppKey @"51ee0b8556240b482703b591"
#define AppDownloadSource @""

//-----------------------  系统函数  -------------------------------

#define UTColor(r,g,b,a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]
#define UTLocalizeString(s) NSLocalizedString(s,nil)

#define RANDOM_SEED() srandom(time(NULL)) 
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


#define Bosch_Green     UTColor(1,143,2,1)
//-----------------------  系统字符串 ------------------------------

#define LoginTitleString			UTLocalizeString(@"登录")
#define InputUserNameString			UTLocalizeString(@"请输入用户名")
#define InputPasswordString			UTLocalizeString(@"请输入密码")
#define UserTitleString				UTLocalizeString(@"用户信息")


//-----------------Server Info------------
#define ServerMainAddress @"http://www.vvpen.com:8000/webapi/phone/"
#define AppDBHost @"http://42.121.128.202/app/"

//Customer Value
#define EventRadius 200.0
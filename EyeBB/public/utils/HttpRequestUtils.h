//
//  HttpRequestUtils.h
//  EyeBB
//
//  Created by liwei wang on 3/3/15.
//  Copyright (c) 2015 EyeBB. All rights reserved.
//

#ifndef EyeBB_HttpRequestUtils_h
#define EyeBB_HttpRequestUtils_h


#endif
/*
 * http request
 */
//LoginViewController
#define LOGIN_TO_CHECK @"j_spring_security_check"
//RegViewController
#define REG_PARENTS @"regService/api/regParents"


#define CONNECT_TIMEOUT  5000
/**
 * 158.182.246.221 == test.eyebb.com (Testing)
 * 158.182.8.221 == srv.eyebb.com (Production)
 * 158.182.220.206 == test.eyebb.com (Testing)
 * 158.182.246.223 == srv.eyebb.com (Production)
 */
#define SERVER_URL @"http://test.eyebb.com:8089/"
// #define SERVER_URL @"http://158.182.220.206:8089/"
// #define SERVER_URL @"http://158.182.246.223:8080/"
// #define SERVER_URL @"http://158.182.220.203:8080/"
#define HTTP_POST_RESPONSE_URL_NULL @"Url Null"
#define HTTP_POST_RESPONSE_EXCEPTION @"Failed to connect to server"

#define JSON_KEY_CHILD_ID @"childId"
#define JSON_KEY_CHILD_NAME @"name"
#define JSON_KEY_CHILD_ICON @"icon"

#define LOGIN @"j_spring_security_check"
#define JSON_KEY_USER @"guardian"
#define JSON_KEY_USER_ID @"guardianId"
#define JSON_KEY_USER_NAME @"name"
#define JSON_KEY_USER_PHONE @"phoneNumber"
#define JSON_KEY_USER_TYPE @"type"
#define JSON_KEY_REGISTRATION_ID @"registrationId"

#define GET_KINDERGARTEN_LIST @"kindergartenList"
#define JSON_KEY_AREAS_INFO @"allLocationAreasInfo"
#define JSON_KEY_AREAS_id @"areaId"
#define JSON_KEY_KINDERGARTEN_NAME_EN @"name"
#define JSON_KEY_KINDERGARTEN_NAME_TC @"nameTc"
#define JSON_KEY_KINDERGARTEN_NAME_SC @"nameSc"

// #define GET_CHILDREN_LIST =
// "reportService/api/childrenList"
#define GET_CHILDREN_INFO_LIST @"reportService/api/childrenInfoList"
#define JSON_KEY_CHILDREN_INFO @"childrenInfo"

#define GET_CHILDREN_LOC_LIST @"reportService/api/childrenLocList"
#define JSON_KEY_CHILDREN_BY_AREA @"childrenByArea"
#define JSON_KEY_CHILDREN_BEAN @"childrenBean"

#define JSON_KEY_CHILD_REL @"childRel"
#define JSON_KEY_CHILD @"child"
#define JSON_KEY_CHILD_RELATION @"relation"
#define JSON_KEY_CHILD_MAC_ADDRESS @"macAddress"
#define JSON_KEY_CHILD_LAST_APPEAR_TIME @"lastAppearTime"
#define JSON_KEY_CHILD_LOC_ID @"locId"

#define JSON_KEY_LOCATION_ALL @"allLocations"
#define JSON_KEY_LOCATION_AREA @"area"
#define JSON_KEY_LOCATION_AREA_ID @"areaId"
#define JSON_KEY_LOCATION_AREA_NAME @"name"
#define JSON_KEY_LOCATION_AREA_NAME_TC @"nameTc"
#define JSON_KEY_LOCATION_AREA_NAME_SC @"nameSc"
#define JSON_KEY_LOCATION_AREA_ICON @"icon"
#define JSON_KEY_LOCATIONS @"locations"
#define JSON_KEY_LOCATION_ID @"locationId"
#define JSON_KEY_LOCATION_NAME @"locationName"
#define JSON_KEY_LOCATION_NAME_SC @"nameSc"
#define JSON_KEY_LOCATION_NAME_TC @"nameTc"
#define JSON_KEY_LOCATION_TYPE @"type"
#define JSON_KEY_LOCATION_ICON @"icon"

#define JSON_KEY_PARENTS @"parents"
#define JSON_KEY_PARENTS_PHONE @"phoneNumber"
#define JSON_KEY_PARENTS_TYPE @"type"

#define GET_REPORTS @"reportService/api/stat"
#define JSON_KEY_REPORT_PERFORMANCE @"dailyAvgFigure"
#define JSON_KEY_REPORT_PERFORMANCE_LOC_NAME @"locName"
#define JSON_KEY_REPORT_PERFORMANCE_DAILY @"daily"
#define JSON_KEY_REPORT_PERFORMANCE_AVERAGE @"average"
#define JSON_KEY_REPORT_PERFORMANCE_LAST_UPDATE_TIME @"lastUpdateTime"

#define JSON_KEY_REPORT_ACTIVITY_INFO @"activityInfos"
#define JSON_KEY_REPORT_ACTIVITY_INFO_TITLE @"title"
#define JSON_KEY_REPORT_ACTIVITY_INFO_TITLE_TC @"titleTc"
#define JSON_KEY_REPORT_ACTIVITY_INFO_TITLE_SC @"titleSc"
#define JSON_KEY_REPORT_ACTIVITY_INFO_URL @"activity"
#define JSON_KEY_REPORT_ACTIVITY_INFO_URL_TC @"activityTc"
#define JSON_KEY_REPORT_ACTIVITY_INFO_URL_SC @"activitySc"
#define JSON_KEY_REPORT_ACTIVITY_INFO_ICON @"icon"
#define JSON_KEY_REPORT_ACTIVITY_INFO_DATE @"validUntil"

#define GUEST_CHILDREN @"masterService/api/guestChildren"
#define JSON_KEY_CHILDREN_QUOTA @"childrenQuota"
#define JSON_KEY_WITH_ACCESS @"withAccess"
#define JSON_KEY_TOTAL_QUOTA @"totalQuota"
#define JSON_KEY_QUOTA_LEFT @"quotaLeft"

#define AUTH_FIND_GUESTS @"masterService/api/searchMasterGuests"
#define JSON_KEY_GUESTS @"guests"
#define JSON_KEY_MASTERS @"masters"
#define JSON_KEY_CHILDREN_BY_GUARDIAN @"chilrenByGuardian"

#define GET_NOTICES @"reportService/api/notices"
#define JSON_KEY_NOTICES @"notices"
#define JSON_KEY_NOTICES_TITLE @"title"
#define JSON_KEY_NOTICES_TITLE_TC @"titleTc"
#define JSON_KEY_NOTICES_TITLE_SC @"titleSc"
#define JSON_KEY_NOTICES_NOTICE @"notice"
#define JSON_KEY_NOTICES_NOTICE_TC @"noticeTc"
#define JSON_KEY_NOTICES_NOTICE_SC @"noticeSc"
#define JSON_KEY_NOTICES_ICON @"icon"
#define JSON_KEY_NOTICES_VALID_UNTIL @"validUntil"

//这个是授权列表里面,添加一个新的guest用的
#define SEARCH_GUEST @"masterService/api/searchGuest"
//这个是gcm用的,就是推送用的
#define UPDATE_REGISTRATION_ID @"/accSetting/api/updateDeviceId"
//注册时第一个节目 当填完username后 textfield脱离焦点 发出请求检测这个username是否被用过,如果用过测返回错误
#define ACC_NAME_CHECK @"regService/api/accNameCheck"
//注册完第一个界面后 弹出dialog提示是否要进行绑定 如果绑定则进入第二个界面, 就来到这个界面进行孩子信息的注册
#define CHILD_CHECKING @"masterService/api/childChecking"
//第二个注册界面注册完后, 将会弹出一个dialog显示这个孩子, 然后点击这个孩子就会检测这个孩子是否已经被绑定过
#define CHILD_GUA_REL @"masterService/api/regGuaChildRel"

//检测这个device是否被用过
#define CHECK_BEACON @"masterService/api/checkBeacon"

//绑定孩子与device
#define DEVICE_TO_CHILD @"masterService/api/persistBeaconChildRel"

//反馈
#define FEED_BACK @"reportService/api/feedbacks"

//没被用过呢貌似- -
#define CHECK_IF_CHILD_HAS_BEACON @"masterService/api/hasBeaconOrNot"

//孩子专属界面里面 解绑device
#define UNBIND_CHILD_BEACON @"masterService/api/unbindChildBeacon"

//提交需要授权的孩子id 和解除授权的孩子id
#define GRANT_GUESTS @"masterService/api/grantGuestAccess"

//这个也没用过了哦
#define LOGIN_INFO @"reportService/api/loginInfo"

//更新密码
#define UPDATE_PASSWORD @"accSetting/api/updatePassword"

//重设密码 也就是忘记密码那里
#define RESET_PASSWORD @"regService/api/resetPassword"

//暂时没用到
#define GET_MASTER_CHILDREN @"masterService/api/masterChildren"

//改变昵称
#define CHANGE_NICKNAME @"accSetting/api/changeNickname"

//得到qrcode
#define REQUIRE_OR_GET_QR_CODE @"masterService/api/childMacAddressAvailable"

#define SERVER_RETURN_true @"true"
#define SERVER_RETURN_TRUE @"TRUE"
#define SERVER_RETURN_false @"false"
#define SERVER_RETURN_fALSE @"fALSE"
#define SERVER_RETURN_USED @"USED"
#define SERVER_RETURN_N @"N"
#define SERVER_RETURN_Y @"Y"
#define SERVER_RETURN_T @"T"
#define SERVER_RETURN_F @"F"
#define SERVER_RETURN_E @"E"
#define SERVER_RETURN_WG @"WG"
#define SERVER_RETURN_NC @"NC"













/*
 * http request key
 */
//LoginViewController
#define LOGIN_TO_CHECK_KEY_j_username @"j_username"
#define LOGIN_TO_CHECK_KEY_j_password @"j_password"
#define LOGIN_TO_CHECK_KEY_appVersion @"appVersion"

//RegViewController
#define REG_PARENTS_KEY_ACCNAME @"accName"
#define REG_PARENTS_KEY_NAME @"name"
#define REG_PARENTS_KEY_PASSWORD @"password"
#define REG_PARENTS_KEY_EMAIL @"email"
#define REG_PARENTS_KEY_PHONENUM @"phoneNum"

//ChildInformationMatchingViewController
#define ChildInformationMatchingViewController_KEY_childName @"childName"
#define ChildInformationMatchingViewController_KEY_dateOfBirth @"dateOfBirth"
#define ChildInformationMatchingViewController_KEY_kId @"kId"

//RootViewController
#define RootViewController_KEY_childId @"childId"
#define RootViewController_KEY_macAddress @"macAddress"


/*
 * json key
 */

//LoginViewController
#define LoginViewController_json_key_guardian @"guardian"
#define LoginViewController_json_key_registrationId @"registrationId"

//KindergartenListViewController
#define KindergartenListViewController_json_key_size @"size"
#define KindergartenListViewController_json_key_allLocationAreasInfo @"allLocationAreasInfo"
#define KindergartenListViewController_json_key_areaId @"areaId"
#define KindergartenListViewController_json_key_name @"name"
#define KindergartenListViewController_json_key_nameTc @"nameTc"
#define KindergartenListViewController_json_key_nameSc @"nameSc"
#define KindergartenListViewController_json_key_icon @"icon"


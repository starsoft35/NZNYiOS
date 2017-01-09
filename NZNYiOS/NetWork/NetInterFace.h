//
//  NetInterFace.h
//  nzny
//
//  Created by 男左女右 on 16/10/9.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#ifndef NetInterFace_h
#define NetInterFace_h



// 主机地址
#define cHostUrl (@"http://api.212bg.com")
//#define cHostUrl (@"http://192.168.1.103/nzny/index.php/")

// 推流、拉流主机地址
#define cPushAndPlayHostUrl (@"http://video.nznychina.com")


// 下载地址
#define cDownLoadUrl (@"http://api.212bg.com/Uploads/ios.ipa")


#pragma 0、登录、注册
// 0.登录、注册
// 0.1-登录地址
#define cLoginUrl (@"api/Account/Login")

// 0.2-注册地址
#define cRegisterUrl (@"api/Account/Register")
//#define cRegisterUrl (@"Api/Account/index")

// 0.3-完善信息
#define cFurRegisterUrl (@"api/User/FurRegister")

// 0.4-修改密码
#define cChangePSWUrl (@"api/Account/ChangePassword")

// 0.5-忘记密码：重置密码
#define cResetPSWUrl (@"api/Account/ReSetPassword")

// 0.6-微信-登录
#define cWXLoginUrl (@"api/Account/WeixinLogin")

// 0.6.1-微信授权域
#define cWXScope (@"snsapi_userinfo")
// 0.6.2-微信授权回调的状态
#define cWXState (@"nznyIOS_huidiaozhuanyong")
// 0.6.3-微信-获取access_token 地址
#define cWXGetAccessTokenUrl (@"https://api.weixin.qq.com/sns/oauth2/access_token")



#pragma 1、视频
// 1.1-热门视频
#define cHotVideoListUrl (@"api/Video/HotVideoList")
// 1.1.1-联系他
#define cContactUrl (@"api/Relationship/contact")

// 1.2-关注视频
#define cFollowsVideoListUrl (@"api/Video/MyFollowsVideoList")

// 1.3-视频视图详情
#define cVideoViewDetailUrl (@"api/Video/ViewDetail")


#pragma 2、直播
// 2.1-预告
#define cLiveTrailerListUrl (@"api/Live/TrailerList")
// 2.2-直播
#define cLiveOnAirListUrl (@"api/Live/OnAirList")

// 2.3-观众进入直播间
#define cEnterLiveRoomUrl (@"api/Live/EnterLiveRoom")
// 2.4-观众离开直播间
#define cLeaveLiveRoomUrl (@"api/Live/LeaveLiveRoom")

// 2.5-直播详情
#define cLiveDetaillUrl (@"api/Live/LiveDetaill")
// 2.6-直播间观众
#define cLiveRoomPeopleUrl (@"api/Live/LiveRoomPeople")


// 4、我的-一级界面
#define cMyBaseInfoUrl (@"api/User/MyBaseInfo")

// 4、1-个人信息
#define cPrivateInfoUrl (@"api/User/PrivateInfo")
// 4、1-1、修改头像
#define cModifyPortraitUrl (@"api/User/ModifyPortrait")
// 4、1-2、修改姓名
#define cModifyRealNameUrl (@"api/User/ModifyRealName")
// 4、1-3、修改性别
#define cModifyGenderUrl (@"api/User/ModifyGender")
// 4、1-4、修改年龄
#define cModifyAgeUrl (@"api/User/ModifyAge")
// 4、1-4.1、获取年龄
// 4、1-5、修改学历
#define cModifyEducationUrl (@"api/User/ModifyEducation")
// 4、1-6、修改婚姻状况
#define cModifyMarriageUrl (@"api/User/ModifyMarriage")
// 4、1-7、修改所在地
#define cModifyAreaUrl (@"api/User/ModifyArea")
// 4、1-8、修改爱情宣言
#define cModifyDeclarationUrl (@"api/User/ModifyDeclaration")

// 4、1-我的视频列表
#define cMineVideoListUrl (@"api/Video/List")

// 4、1-1、用户视频添加
#define cMineVideoAddUrl (@"api/Video/Add")

// 4、1-2、修改 用户视频默认使用值
#define cMineVideoSetDefault (@"api/Video/SetDefault")

// 4、1-3、删除 用户视频
#define cMineVideoDeleteUrl (@"api/Video/Delete")


// 4、2-我的直播列表
// 4、2-1-我的直播预告：列表
#define cMyLiveTrailerListUrl (@"api/Live/MyTrailerList")
// 4、2-1-1-我的直播预告：获取推流、拉流权限
#define cPushAndPlayPermissionUrl (@"Authorize/Access")
// 4、2-1-2-我的直播预告：获取推流地址
#define cMyLiveGetPushUrl (@"Live/GetPushUrl")
// 4、2-1-3-我的直播预告：开始直播
#define cStartLiveUrl (@"api/Live/StartLive")
// 4、2-1-3-我的直播预告：结束直播
#define cEndLiveUrl (@"api/Live/EndLive")
// 4、2-2-我的直播记录
#define cMyLiveRecirdListUrl (@"api/Live/MyLiveList")
// 4、2-3-直播报名
#define cMyLiveApplyUrl (@"api/Live/Apply")

// 4、3-我的粉丝列表
#define cFansList (@"api/Relationship/FansList")

// 4、4-我的关注列表
#define cMyFollowsListUrl (@"api/Relationship/FollowsList")

// 4、5-我的余额、赞、诚信认证、礼物、标签、好友
// 4、5.1、账户余额
#define cMyUserMoneyUrl (@"api/Pay/UserMoney")
// 4、5.1.1-花费明细
#define cMyPayListUrl (@"api/Pay/PayList")
// 4、5.2、我的赞
// 4、5.2.0-用户累积的赞、可兑换的赞
#define cUserLikeCountUrl (@"api/Like/UserLikeCount")
// 4、5.2.1-谁赞过我
#define cMyReceiveLikeListUrl (@"api/Like/ReceiveLikeList")
// 4、5.2.2-我赞过谁
#define cMySendLikeListUrl (@"api/Like/SendLikeList")
// 4/5.2.3-兑换赞
#define cLikeExChangeMoneyUrl (@"api/Like/LikeExChangeMoney")
// 4、5.3、诚信认证-背景认证-获取登录用户的证件列表以及上传证件数量
#define cCertificateListUrl (@"api/Certificates/List")
// 4、5.3.1-诚信认证-手机号认证
#define cVerifyPhoneUrl (@"api/User/VerifyMobile")
// 4、5.3.2.1-上传图片
#define cUploadImgUrl (@"api/Public/Uploads")
#define cUploadImgUrliOS (@"api/Public/AppUploads")
#define cUploadImgUrl1 (@"api/Public/AppUploads1")
// 4、5.3.2.2-诚信认证-背景认证-上传用户证件
#define cCertificateEditUrl (@"api/Certificates/Edit")


// 4、5.4、我的礼物
// 4、5.4.1-我收到的
#define cMyReceiveLikeListUrl (@"api/Like/ReceiveLikeList")
// 4、5.4.2-我送出的
#define cMySendLikeListUrl (@"api/Like/SendLikeList")

// 4、5.5、我的标签
#define cMyAllTagsListUrl (@"api/UserTags/MyAllList")
// 4、5.5.1、星座标签列表
#define cXingZuoTagListUrl (@"api/Tags/api/Tags/XingZuoTagList")
// 4、5.5.2、房车标签列表
#define cFangCheTagListUrl (@"api/Tags/api/Tags/FangCheTagList")
// 4、5.5.3、身高标签列表
#define cShenGaoTagListUrl (@"api/Tags/api/Tags/ShenGaoTagList")
// 4、5.5.4、职业标签列表
#define cZhiYeTagListUrl (@"api/Tags/api/Tags/ZhiYeTagList")
// 4、5.5.5、爱好标签列表
#define cAiHaoTagListUrl (@"api/Tags/api/Tags/AiHaoTagList")
// 4、5.6、添加、修改标签
#define cTagAddUrl (@"api/UserTags/Add")

// 4、5.6、我的好友：列表
#define cMyFriendsListUrl (@"api/Relationship/FriendsList")

// 4、5.6.1、删除好友
#define cDeleteFriendUrl (@"api/Relationship/DelFriend")


#pragma 5、navigationBar
// 5、消息列表
// 5.1-搜索好友
#define cSearchPeopleUrl (@"api/Relationship/SearchList")

// 5.1.1-他人详情页
#define cOppUserInfoUrl (@"api/User/OppUserInfo")

// 5.1.1.1-申请好友
#define cApplyFriendUrl (@"api/Relationship/ApplyFriend")

// 5.1.1.2.1-加关注
#define cAddFollowUrl (@"api/Relationship/AddFollow")
// 5.1.1.2.2-取消关注
#define cDelFollowUrl (@"api/Relationship/DelFollow")

// 5.1.1.3.0-账户余额
#define cUserMoneyUrl (@"api/Pay/UserMoney")
// 5.1.1.3-点赞
#define cAddUserLikeUrl (@"api/Like/AddUserLike")

// 5.1.1.4-送礼
#define cAddFlowersUrl (@"api/Gift/AddFlowers")

// 5.2-附近的人
#define cNearbyUserListUrl (@"api/User/NearbyUserList")
// 5.2.1-上传地理位置信息
#define cCoordinatesUrl (@"api/User/Coordinates")

// 5.3-获取用户信息
#define cGetUserInfoUrl (@"api/User/GetUserInfo")





#pragma 6、SDK
// 6.1-短信验证码SDK
#define cSMSAppKey (@"17c4cf63cb20a")
#define cSMSAppSecret (@"5091926f2cc85e5cc0048f4dae326345")

// 6.2-微信SDK：API
#define cWXAppID (@"wx8520e815a9ceb340")
#define cWXAppSecret (@"")

// 6.3-融云SDK：
// 开发环境：RongAppKey
//#define cRongAppKey (@"0vnjpoadnp2qz")
// 生产环境：RongAppKey
#define cRongAppKey (@"e5t4ouvptowra")
#define cRongSecret (@"yShXVwLoYRIo")
// 6.3.1-网络请求：获取用户在融云的token
#define cRongTokenUrl (@"api/User/RongToken")

// 6.3-阿里播放器SDK：key、secret
#define cALiPlayAppKeyId (@"LTAI7WeyxMD0beii")
#define cALiPlaySecret (@"bmMgG3bgGvcSAdxkyhp1TTcYMTzBJg")


#endif /* NetInterFace_h */

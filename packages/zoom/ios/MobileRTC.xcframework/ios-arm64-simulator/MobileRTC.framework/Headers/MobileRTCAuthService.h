/**
 * @file MobileRTCAuthService.h
 * @brief Authentication service for authorizing and managing Zoom SDK authentication.
 */

#import <Foundation/Foundation.h>
#import <MobileRTC/MobileRTCConstants.h>
#import <MobileRTC/MobileRTCNotificationServiceHelper.h>


@protocol MobileRTCAuthDelegate;
@class MobileRTCAccountInfo;
@class MobileRTCAlternativeHost;

/**
 * @class MobileRTCAuthService
 * @brief The method provides support for authorizing MobileRTC.
 * @warning Users should authorize MobileRTC before using it to avoid invalid functions in MobileRTC.
 */
@interface MobileRTCAuthService : NSObject
/**
 * @brief The property to receive authentication/login events. 
 */
@property (weak, nonatomic) id<MobileRTCAuthDelegate> _Nullable delegate;

/**
 * @brief Jwt auth token.
 * @warning Keep the value as a secret. DO NOT publish it. If jwtToken is nil or empty,We will user your appKey and appSecret to Auth, We recommend using JWT Token,  and generate JWT Token on your web backend.
 */
@property (nullable, retain, nonatomic) NSString *jwtToken;

/**
 * @brief Public app key used for SDK authentication. Alternative to JWT token.
 */
@property (nullable, retain, nonatomic) NSString *publicAppKey;

/**
 * @brief Authenticate SDK.
 * @warning If you want to auth with jwt token, please fill the jwtToken property. For public app type, fill the publicAppKey property instead. If both jwtToken and publicAppKey are provided, jwtToken will be used preferentially.
 * @warning If both jwtToken and publicAppKey are nil or empty, user will get error:MobileRTCAuthError_KeyOrSecretEmpty via onMobileRTCAuthReturn defined in MobileRTCAuthDelegate.
 */
- (void)sdkAuth;

/**
 * @brief Queries whether mobileRTC is logged-in or not.
 * @return YES indicates logged-in. Otherwise not.
 * @warning The method is optional, ignore it if you do not log in with working email or SSO.
 */
- (BOOL)isLoggedIn;

/**
 * @brief Gets the user type.
 * @return One of the user types listed in MobileRTCUserType.
 * @warning The method is optional. The default user type is MobileRTCUserType_APIUser. User who logs in MobileRTC with working email is MobileRTCUserType_ZoomUser; User who logs in MobileRTC with SSO is MobileRTCUserType_SSOUser.
 */
- (MobileRTCUserType)getUserType;

/**
 * @brief Generates the SSO login URL for a specific SSO vanity URL.
 * @param vanityUrl The prefix of vanity URL.
 * @return If the function succeeds, it returns the URL that can launch the app.
 */
- (nullable NSString *)generateSSOLoginWebURL:(nonnull NSString*)vanityUrl;

/**
 * @brief Logs in ZOOM with SSO URI Protocol.
 * @param uriProtocol The parameter to be used for SSO account login.
 * @return If the function succeeds, it returns MobileRTCLoginFailReason_Success. Otherwise, it returns an error.
 */
- (MobileRTCLoginFailReason)ssoLoginWithWebUriProtocol:(nonnull NSString*)uriProtocol;

/**
 * @brief Logs out MobileRTC.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning The method is optional, ignore it if you do not login MobileRTC.
 */
- (BOOL)logoutRTC;

/**
 * @brief Gets the profile information of the logged-in user.
 * @return The profile information of the logged-in user. 
 * @warning You can only get the instance successfully of logged-in user.
 */
- (nullable MobileRTCAccountInfo*)getAccountInfo;

/**
 * @brief Enables or disables auto register notification service. This is disabled by default.
 * @param enable YES to enable, NO to disable.
 */
- (void)enableAutoRegisterNotificationServiceForLogin:(BOOL)enable;

/**
 * @brief Registers the notification service.
 * @param accessToken Initialize parameter of notification service.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)registerNotificationService:(nullable NSString*)accessToken;

/**
 * @brief Unregisters the notification service.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)unregisterNotificationService;

/**
 * @brief Gets the notification service controller interface.
 * @return If the function succeeds, it returns a MobileRTCNotificationServiceHelper object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCNotificationServiceHelper*_Nullable)getNotificationServiceHelper;

@end

/**
 * @protocol MobileRTCAuthDelegate
 * @brief An authentication service will issue the following values when the authorization state changes.
 */
@protocol MobileRTCAuthDelegate <NSObject>
@required
/** 
 * @brief Callback event when MobileRTC authorization status changes.
 * @param returnValue Notifies the user that the authorization status changes.
 */
- (void)onMobileRTCAuthReturn:(MobileRTCAuthError)returnValue;

@optional
/**
 * @brief Callback event when the token expires.
 */
- (void)onMobileRTCAuthExpired;

/**
 * @brief Callback event when MobileRTC login state changes.
 * @param resultValue Notifies the user when the login state has changed.
 * @warning If the callback is implemented, the Zoom UI alert tips are no longer displayed.
 */
- (void)onMobileRTCLoginResult:(MobileRTCLoginFailReason)resultValue;

/**
 * @brief Callback event when MobileRTC logout completes.
 * @param returnValue Notifies that the user has logged-out successfully.
 */
- (void)onMobileRTCLogoutReturn:(NSInteger)returnValue;

/**
 * @brief Notification service status changed callback.
 * @param status The value of transfer meeting service.
 * @param error Connection Notification service fail error code.
 */
- (void)onNotificationServiceStatus:(MobileRTCNotificationServiceStatus)status error:(MobileRTCNotificationServiceError)error;

@end

/**
 * @class MobileRTCAccountInfo
 * @brief It is used to store the profile information of logged-in user.
 */
@interface MobileRTCAccountInfo : NSObject
/**
 * @brief Gets the working email address.
 * @return The working email address.
 */
- (nullable NSString*)getEmailAddress;

/**
 * @brief Gets the username of a logged in account. [Login User Only].
 * @return Username of the logged in account.
 */
- (nullable NSString*)getUserName;

/**
 * @brief Gets the PMI Vanity URL from user profile information. 
 * @return PMI Vanity URL.
 */
- (nullable NSString *)getPMIVanityURL;

/**
 * @brief Determines if Audio Type (Telephone Only) is supported while scheduling a meeting.
 * @return YES if supported. Otherwise, NO.
 */
- (BOOL)isTelephoneOnlySupported;

/**
 * @brief Determines if Audio Type (Telephone And VoIP) is supported while scheduling a meeting.
 * @return YES if supported. Otherwise, NO.
 */
- (BOOL)isTelephoneAndVoipSupported;

/**
 * @brief Determines if Audio Type (3rdParty Audio) is supported while scheduling a meeting.
 * @return YES if supported. Otherwise, NO.
 */
- (BOOL)is3rdPartyAudioSupported;

/**
 * @brief Gets the 3rd Party Audio Info from user profile.
 * @return The 3rd Party Audio Info.
 */
- (nullable NSString *)get3rdPartyAudioInfo;

/**
 * @brief Gets the default Audio Type from user profile.
 * @return The default Audio Type.
 */
- (MobileRTCMeetingItemAudioType)getDefaultAudioInfo;

/**
 * @brief Determines if only signed-in users can join the meeting while scheduling a meeting.
 * @return YES if only signed-in users are allowed to join the meeting. Otherwise, NO.
 */
- (BOOL)onlyAllowSignedInUserJoinMeeting;

/**
 * @brief Gets the alternative host list from user profile information.
 * @return An array with MobileRTCAlternativeHost information.
 */
- (nullable NSArray <MobileRTCAlternativeHost *> *)getCanScheduleForUsersList;

/**
 * @brief Determines if local recording is supported while scheduling a meeting.
 * @return YES if supported. Otherwise, NO.
 */
- (BOOL)isLocalRecordingSupported;

/**
 * @brief Determines if cloud recording is supported while scheduling a meeting.
 * @return YES if supported. Otherwise, NO.
 */
- (BOOL)isCloudRecordingSupported;

/**
 * @brief Gets the default Meeting Auto Recording Types from user profile.
 * @return The default Meeting Auto Recording Type.
 */
- (MobileRTCMeetingItemRecordType)getDefaultAutoRecordType;

/**
 * @brief Determines if only users in specified domain can join the meeting while scheduling a meeting.
 * @return YES if only users in specified domain can join the meeting. Otherwise, NO.
 */
- (BOOL)isSpecifiedDomainCanJoinFeatureOn;

/**
 * @brief Gets the specified domain from user profile.
 * @return The data in domain array is NSString type.
 */
- (nullable NSArray <NSString *> *)getDefaultCanJoinUserSpecifiedDomains;

@end

/**
 * @class MobileRTCAlternativeHost
 * @brief It is used to store the information of the alternative host.
 */
@interface MobileRTCAlternativeHost : NSObject
@property (nonatomic, retain, readonly) NSString * _Nullable email;
@property (nonatomic, retain, readonly) NSString * _Nullable firstName;
@property (nonatomic, retain, readonly) NSString * _Nullable lastName;
@property (nonatomic, assign, readonly) unsigned long long PMINumber;

- (id _Nonnull)initWithEmailAddress:(NSString * _Nonnull)emailAddress firstname:(NSString * _Nonnull)firstName lastName:(NSString * _Nonnull)lastName PMI:(unsigned long long)PMINumber;
@end

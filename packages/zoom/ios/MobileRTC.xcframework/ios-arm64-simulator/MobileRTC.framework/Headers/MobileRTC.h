/**
 * @file MobileRTC.h
 * @brief Main framework header providing core Zoom meeting SDK functionality and all necessary imports.
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MobileRTC/MobileRTCConstants.h>
#import <MobileRTC/MobileRTCMeetingUserInfo.h>
#import <MobileRTC/MobileRTCRoomDevice.h>
#import <MobileRTC/MobileRTCAuthService.h>
#import <MobileRTC/MobileRTCMeetingService.h>
#import <MobileRTC/MobileRTCAutoFramingParameter.h>
#import <MobileRTC/MobileRTCMeetingService+AppShare.h>
#import <MobileRTC/MobileRTCMeetingService+InMeeting.h>
#import <MobileRTC/MobileRTCMeetingService+Customize.h>
#import <MobileRTC/MobileRTCMeetingService+Audio.h>
#import <MobileRTC/MobileRTCMeetingService+Video.h>
#import <MobileRTC/MobileRTCMeetingService+User.h>
#import <MobileRTC/MobileRTCMeetingService+Chat.h>
#import <MobileRTC/MobileRTCMeetingService+Avatar.h>
#import <MobileRTC/MobileRTCMeetingService+Webinar.h>
#import <MobileRTC/MobileRTCMeetingService+QA.h>
#import <MobileRTC/MobileRTCMeetingService+VirtualBackground.h>
#import <MobileRTC/MobileRTCMeetingService+Interpretation.h>
#import <MobileRTC/MobileRTCMeetingService+BO.h>
#import <MobileRTC/MobileRTCMeetingService+Reaction.h>
#import <MobileRTC/MobileRTCMeetingService+LiveTranscription.h>
#import <MobileRTC/MobileRTCMeetingService+Docs.h>
#import <MobileRTC/MobileRTCMeetingService+RawArchiving.h>
#import <MobileRTC/MobileRTCMeetingService+Phone.h>
#import <MobileRTC/MobileRTCMeetingService+SmartSummary.h>
#import <MobileRTC/MobileRTCMeetingService+AICompanion.h>
#import <MobileRTC/MobileRTCMeetingService+Whiteboard.h>
#import <MobileRTC/MobileRTCMeetingService+Polling.h>
#import <MobileRTC/MobileRTCMeetingService+Encryption.h>
#import <MobileRTC/MobileRTCMeetingSettings.h>
#import <MobileRTC/MobileRTCMeetingSettings+Custom3DAvatar.h>
#import <MobileRTC/MobileRTCCustom3DAvatarElementSettingContext.h>
#import <MobileRTC/MobileRTCInviteHelper.h>
#import <MobileRTC/MobileRTCMeetingChat.h>
#import <MobileRTC/MobileRTCMeetingDelegate.h>
#import <MobileRTC/MobileRTCVideoView.h>
#import <MobileRTC/MobileRTCMeetingActionItem.h>
#import <MobileRTC/MobileRTCAnnotationService.h>
#import <MobileRTC/MobileRTCRemoteControlService.h>
#import <MobileRTC/MobileRTCCameraControlService.h>
#import <MobileRTC/MobileRTCWaitingRoomService.h>
#import <MobileRTC/MobileRTCRenderer.h>
#import <MobileRTC/MobileRTCAudioRawDataHelper.h>
#import <MobileRTC/MobileRTCVideoSourceHelper.h>
#import <MobileRTC/MobileRTCShareSourceHelper.h>
#import <MobileRTC/MobileRTCAudioSourceHelper.h>
#import <MobileRTC/MobileRTCSMSService.h>
#import <MobileRTC/MobileRTCDirectShareService.h>
#import <MobileRTC/MobileRTCReminderHelper.h>
#import <MobileRTC/MobileRTCJoinMeetingInfoHandler.h>

/**
 * @class MobileRTCSDKInitContext
 * @brief The configuration object used to initialize the Zoom SDK.
 */
@interface MobileRTCSDKInitContext : NSObject
/**
 * @brief [Required] domain The domain is used to start/join a ZOOM meeting.
 */
@property (nonatomic, copy)   NSString                      * _Nullable domain;
/**
 * @brief [Optional] enableLog Set MobileRTC log enable or not. The path of Log: Sandbox/AppData/tmp/.
 */
@property (nonatomic, assign) BOOL                          enableLog;
/**
 * @brief [Optional] bundleResPath Set the path of MobileRTC resource bundle.
 */
@property (nonatomic, copy) NSString                        * _Nullable bundleResPath;
/**
 * @brief [Optional] Locale fo Customer.
 */
@property (nonatomic, assign) MobileRTC_ZoomLocale          locale;
/**
 * @brief [Optional] The video rawdata memory mode. Default is MobileRTCRawDataMemoryModeStack, only for rawdataUI.
 */
@property (nonatomic, assign) MobileRTCRawDataMemoryMode    videoRawdataMemoryMode;
/**
 * @brief [Optional] The share rawdata memory mode. Default is MobileRTCRawDataMemoryModeStack, only for rawdataUI.
 */
@property (nonatomic, assign) MobileRTCRawDataMemoryMode    shareRawdataMemoryMode;
/**
 * @brief [Optional] The audio rawdata memory mode. Default is MobileRTCRawDataMemoryModeStack, only for rawdataUI.
 */
@property (nonatomic, assign) MobileRTCRawDataMemoryMode    audioRawdataMemoryMode;
/**
 * @brief [Optional] If you use screen share, you need create group id in your apple developer account, and setup here.
 */
@property (nonatomic, copy) NSString                        * _Nullable appGroupId;
/**
 * @brief [Optional] If you use direct screen share, you need create replaykit bundle identifier in your apple developer account, and setup here.
 */
@property (nonatomic, copy) NSString                        * _Nullable replaykitBundleIdentifier;

/**
 * @brief SDK wrapper type (reserved for internal use).
 */
@property (nonatomic, assign) NSInteger                     wrapperType;

/**
 * @brief Enable Custom In-Meeting UI in meeting.
 */
@property (assign, nonatomic) BOOL enableCustomizeMeetingUI;

@end

/**
 * @class MobileRTC
 * @brief Initialize the class to acquire all the services.
 * @warning Access to the class and all the other components of the MobileRTC by merging <MobileRTC/MobileRTC.h> into source code.
 * @warning The user can only obtain SDK configuration by initializing the class.
 */
@interface MobileRTC : NSObject
/**
 * @brief MobileRTC domain, read-only.
 */
@property (copy, nonatomic, readonly) NSString * _Nullable mobileRTCDomain;

/**
 * @brief The path of MobileRTC Resources Bundle, read-only. 
 */
@property (copy, nonatomic, readonly) NSString * _Nullable mobileRTCResPath;

/**
 * @brief The name of APP Localizable file for MobileRTC, read-only.
 */
@property (copy, nonatomic, readonly) NSString * _Nullable mobileRTCCustomLocalizableName;

/**
 * @brief Gets the MobileRTC client.
 * @warning The sharedSDK will be instantiated only once over the lifespan of the application. Configure the client with the specified key and secret.
 * @return A preconfigured MobileRTC client.
 */
+ (MobileRTC * _Nonnull)sharedRTC;

/**
 * @brief Initializes MobileRTC.
 * @warning The instance will be instantiated only once over the lifespan of the application.
 * @param context Initialize the parameter configuration of the SDK, please See [MobileRTCSDKInitContext].
 */
- (BOOL)initialize:(MobileRTCSDKInitContext * _Nonnull)context;

/**
 * @brief Switches the MobileRTC domain.
 * @param newDomain The new domain.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning After switch domain, need to auth again.
 */
- (BOOL)switchDomain:(NSString * _Nonnull)newDomain force:(BOOL)force;

/**
 * @brief Sets the name of Localizable file for MobileRTC.
 * @warning This method is optional, MobileRTC will read Custom Localizable file from App's main bundle first.
 * @param localizableName The name of APP Localizable file for MobileRTC.
 */
- (void)setMobileRTCCustomLocalizableName:(NSString * _Nullable)localizableName;

/**
 * @brief Gets the root navigation controller of MobileRTC client.
 * @return The root navigation controller.
 * @deprecated This method is deprecated. Use mobileRTCPresentationScene instead.
 */
- (UINavigationController * _Nullable)mobileRTCRootController DEPRECATED_MSG_ATTRIBUTE("This method is deprecated. Use mobileRTCPresentationScene instead.");

/**
 * @brief Sets the MobileRTC client root navigation controller.
 * @param navController The root navigation controller for pushing MobileRTC meeting UI.
 * @deprecated This method is deprecated. Use setMobileRTCPresentationScene instead.
 */
- (void)setMobileRTCRootController:(UINavigationController * _Nullable)navController DEPRECATED_MSG_ATTRIBUTE("This method is deprecated. Use setMobileRTCPresentationScene instead.");

/**
 * @brief Get the presentation scene of MobileRTC client.
 * @return If the function succeeds, it returns the presentation scene of MobileRTC client. Otherwise, this function fails and returns nil.
 */
- (UIScene *_Nullable)mobileRTCPresentationScene;

/**
 * @brief Sets the UIScene context used by the SDK.
 * In multi-scene environments, an application may create multiple `UIScene` instances. This method allows you to provide the SDK with the specific scene it should use for presenting UI, handling lifecycle events, or associating with the application's environment.
 * @param scene The `UIScene` instance to be used by the SDK.
 * @warning Passing an invalid or inactive scene may cause the SDK's UI to fail to present or behave unexpectedly.
 */
- (void)setMobileRTCPresentationScene:(UIScene * _Nonnull)scene;

/**
 * @brief Gets the MobileRTC version.  
 * @return The version of MobileRTC.
 */
- (NSString * _Nullable)mobileRTCVersion;

/**
 * @brief Queries if the MobileRTC is authorized successfully or not. 
 * @return YES indicates authorized successfully. Otherwise not.
 */
- (BOOL)isRTCAuthorized;

/**
 * @brief Queries if custom meeting UI is supported by MobileRTC. 
 * @return YES indicates support. Otherwise not.
 */
- (BOOL)isSupportedCustomizeMeetingUI;

/**
 * @brief Queries if custom meeting UI is enabled by MobileRTC.
 * @return YES indicates enabled. Otherwise not.
 */
- (BOOL)isEnabledCustomizeMeetingUI;

/**
 * @brief Gets the default authentication service.  
 * @warning The MobileRTC can not be called unless the authentication service is called successfully. 
 * @return If the function succeeds, it returns a MobileRTCAuthService object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCAuthService * _Nullable)getAuthService;

/**
 * @brief Gets the default meeting service.  
 * @return If the function succeeds, it returns a MobileRTCMeetingService object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingService * _Nullable)getMeetingService;

/**
 * @brief Gets the MobileRTC default meeting settings. 
 * @return If the function succeeds, it returns a MobileRTCMeetingSettings object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingSettings * _Nullable)getMeetingSettings;

/**
 * @brief Gets the MobileRTC default annotation service.   
 * @return If the function succeeds, it returns a MobileRTCAnnotationService object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCAnnotationService * _Nullable)getAnnotationService;

/**
 * @brief Gets the default MobileRTC remote control service.   
 * @return If the function succeeds, it returns a MobileRTCRemoteControlService object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCRemoteControlService * _Nullable)getRemoteControlService;

/**
 * @brief Gets the default MobileRTC camera control service.
 * @return If the function succeeds, it returns a MobileRTCCameraControlService object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCCameraControlService * _Nullable)getCameraControlService:(NSInteger)userId;

/**
 * @brief Revoke camera control privilege.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)revokeCameraControlPrivilege;

/**
 * @brief Gets the default MobileRTC waiting room service.
 * @return If the function succeeds, it returns a MobileRTCWaitingRoomService object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCWaitingRoomService * _Nullable)getWaitingRoomService;

/**
 * @brief Gets the default MobileRTC sms service.
 * @return If the function succeeds, it returns a MobileRTCSMSService object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCSMSService * _Nullable)getSMSService;

/**
 * @brief Gets the default MobileRTC direct share service.
 * @return If the function succeeds, it returns a MobileRTCDirectShareService object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCDirectShareService * _Nullable)getDirectShareService;

/**
 * @brief Gets the default MobileRTC reminder helper.
 * @return If the function succeeds, it returns a MobileRTCReminderHelper object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCReminderHelper * _Nullable)getReminderHelper;

/**
 * @brief Gets the video source helper.@see MobileRTCVideoSourceHelper.
 * @return If the function succeeds, it returns a MobileRTCVideoSourceHelper object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCVideoSourceHelper * _Nullable)getVideoSourceHelper;

/**
 * @brief Gets the share source helper.@see MobileRTCShareSourceHelper.
 * @return If the function succeeds, it returns a MobileRTCShareSourceHelper object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCShareSourceHelper * _Nullable)getShareSourceHelper;

/**
 * @brief Gets the languages supported by MobileRTC.   
 * @warning The languages supported by MobileRTC are English, German, Spanish, Japanese, French, Simplified Chinese, Traditional Chinese.
 * @return An array of languages supported by MobileRTC.
 */
- (NSArray <NSString *> * _Nonnull)supportedLanguages;

/**
 * @brief Sets the MobileRTC language.
 * @warning Choose one of the languages supported by MobileRTC.  
 * @param lang The specified language.  
 */
- (void)setLanguage:(NSString * _Nullable)lang;

/**
 * @brief Notifies common layer that application will resign active. Call the systematical method and then call the appWillResignActive via applicationWillResignActive.
 * @warning It is necessary to call the method in AppDelegate "- (void)applicationWillResignActive:(UIApplication *)application".  
 */
- (void)appWillResignActive;

/**
 * @brief Notifies common layer that application did become active. Call the appDidBecomeActive via applicationDidBecomeActive.
 * @warning It is necessary to call the method in AppDelegate "- (void)applicationDidBecomeActive:(UIApplication *)application". 
 */
- (void)appDidBecomeActive;

/**
 * @brief Notifies common layer that application did enter background. Call the appDidEnterBackground via applicationDidEnterBackground.
 * @warning It is necessary to call the method in AppDelegate "- (void)applicationDidEnterBackground:(UIApplication *)application".
 */
- (void)appDidEnterBackground;

/**
 * @brief Notifies common layer that application will terminate. Call the appWillTerminate via applicationWillTerminate.
 * @warning It is necessary to call the method in AppDelegate "- (void)applicationWillTerminate:(UIApplication *)application".
 */
- (void)appWillTerminate;

/**
 * @brief Cleanup the SDK.
 * @warning User will clean up the SDK when no longer need the SDK instance, only can call this method after initialized.
 */
- (void)cleanup;

/**
 * @brief Notifies MobileRTC when the root UIViewController's traitCollection will change.
 * @param newCollection The first parameter of willTransitionToTraitCollection:withTransitionCoordinator which is UIContentContainer method.
 * @param coordinator The second parameter of willTransitionToTraitCollection:withTransitionCoordinator which is UIContentContainer method.
 * @warning Not work in Custom In-Meeting UI.
 * @warning Call this method when the window.rootViewController recevived willTransitionToTraitCollection:withTransitionCoordinator.
 */
- (void)willTransitionToTraitCollection:(UITraitCollection *_Nullable)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>_Nullable)coordinator;

/**
 * @brief Notifies MobileRTC when the root UIViewController's view size will change.
 * @param size The first parameter of viewWillTransitionToSize:withTransitionCoordinator.
 * @param coordinator the second parameter of viewWillTransitionToSize:withTransitionCoordinator.
 * @warning Not work in Custom In-Meeting UI.
 * @warning Call this method when the window.rootViewController recevived viewWillTransitionToSize:withTransitionCoordinator.
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>_Nullable)coordinator;

/**
 * @brief Gets whether you have permission to use raw data.
 * @return YES means you have permission to use raw data.
 * @warning It is necessary to call the method after auth success.
 */
- (BOOL)hasRawDataLicense;

@end

/**
 * @file MobileRTCReminderHelper.h
 * @brief Helper for managing meeting reminders and notifications.
 * The AI Companion brand has been retired. AI-powered features are now more deeply integrated throughout Zoom Workplace. Existing APIs and SDKs that reference AI Companion will continue to function as before to ensure backward compatibility.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MobileRTCReminderContent;
@class MobileRTCReminderHandler;

/**
 * @protocol MobileRTCReminderDelegate
 * @brief A protocol for reminder callback events.
 */
@protocol MobileRTCReminderDelegate <NSObject>
@optional

/**
 * @brief Callback event when the reminder dialog is shown.
 * @param content The detail content in the reminder dialog.
 * @param handler The helper to handle the reminder dialog.
 */
- (void)onReminderNotify:(MobileRTCReminderContent * _Nullable)content handle:(MobileRTCReminderHandler * _Nullable)handler;

@end

/**
 * @class MobileRTCReminderContent
 * @brief A class that contains reminder dialog content.
 */
@interface MobileRTCReminderContent : NSObject

/**
 * @brief The type of the reminder.
 */
@property (nonatomic, assign) MobileRTCReminderType type;

/**
 * @brief The title of the reminder dialog.
 */
@property (nonatomic, copy, nullable) NSString *title;

/**
 * @brief The detail content of the reminder dialog.
 */
@property (nonatomic, copy, nullable) NSString *content;

/**
 * @brief Indicates whether to block the user from joining or staying in the meeting.
 */
@property (nonatomic, assign) BOOL isBlock;

/**
 * @brief Gets the type of the action which user should take after receiving this reminder content.
 */
@property (nonatomic, assign) MobileRTCReminderActionType actionType;

/**
 * @brief Gets a list of reminder types.
 * @return The list of reminder types.
 */
- (NSArray<NSNumber*>*_Nonnull)getMultiReminderTypes;

@end

/**
 * @class MobileRTCReminderHandler
 * @brief A class that handles the reminder dialog.
 */
@interface MobileRTCReminderHandler : NSObject

/**
 * @brief Accepts the reminder.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)accept;

/**
 * @brief Declines the reminder.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)declined;

/**
 * @brief Ignores the reminder.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)ignore;

/**
 * @brief Sets not to show the disclaimer in subsequent meetings.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)setHideFeatureDisclaimers;

/**
 * @brief Determines if explicit consent is needed for AI custom disclaimer. Only valid for \link MobileRTCReminderType_CustomAICompanionDisclaimer \endlink.
 * @return YES if explicit consent is required. Before agreeing to AIC disclaimer, the user's video and audio will be blocked. NO means explicit consent is not required and video and audio will not be blocked.
 */
- (BOOL)isNeedExplicitConsent4AICustomDisclaimer;

@end


/**
 * @class MobileRTCDisclaimerBannerConfig
 * @brief Configuration for the simplified disclaimer banner.
 */
@interface MobileRTCDisclaimerBannerConfig: NSObject

/**
 * @brief The center of the simplified disclaimer banner.
 */
@property(nonatomic, assign) CGPoint center;

/**
 * @brief The background of the simplified disclaimer banner.
 */
@property(nonatomic, strong) UIColor * _Nullable backgroundColor;

@end

/**
 * @class MobileRTCReminderHelper
 * @brief A helper for managing meeting reminders and notifications.
 */
@interface MobileRTCReminderHelper : NSObject

/**
 * @brief The callback to receive reminder events.
 */
@property (weak, nonatomic) id<MobileRTCReminderDelegate> _Nullable reminderDelegate;

/**
 * @brief Provides the simplified disclaimer banner UI configuration for CustomUI.
 * @param config The disclaimer banner UI configuration.
 */
- (void)setDisclaimerBannerUIConfig:(MobileRTCDisclaimerBannerConfig *_Nonnull)config;

@end



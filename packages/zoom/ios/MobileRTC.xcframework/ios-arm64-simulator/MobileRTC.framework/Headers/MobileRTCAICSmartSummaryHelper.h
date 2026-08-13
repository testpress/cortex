/**
 * @file MobileRTCAICSmartSummaryHelper.h
 * @brief AI Companion smart summary helper for meeting summaries.
 * The AI Companion brand has been retired. AI-powered features are now more deeply integrated throughout Zoom Workplace. Existing APIs and SDKs that reference AI Companion will continue to function as before to ensure backward compatibility.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @class MobileRTCStartSmartSummaryHandler
 * @brief Handler to start smart summary feature or handle start requests.
 */
@interface MobileRTCStartSmartSummaryHandler : NSObject
/**
 * @brief Starts meeting summary.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)startSmartSummary;

/**
 * @brief Determines if this handler is for requesting to start the smart summary.
 * @return YES if this handler is for requesting to start smart summary. Otherwise, NO.
 */
- (BOOL)isForRequest;

@end

/**
 * @class MobileRTCStopSmartSummaryHandler
 * @brief Handler to stop the smart summary feature.
 */
@interface MobileRTCStopSmartSummaryHandler : NSObject

/**
 * @brief Stops meeting summary.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)stopSmartSummary;

@end

/**
 * @class MobileRTCApproveStartSmartSummaryHandler
 * @brief Handler to approve or decline requests to start smart summary.
 */
@interface MobileRTCApproveStartSmartSummaryHandler : NSObject
/**
 * @brief Gets the requester's user ID.
 * @return The requester's user ID. It may return 0 in cross-instance callback cases.
 */
- (NSUInteger)getSenderUserID;

/**
 * @brief Gets the requester's display name.
 * @return The requester's display name. Returns an empty string if unavailable.
 */
- (NSString *)getRequestUserName;

/**
 * @brief Approves the request.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)approve;

/**
 * @brief Declines the request.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)decline;

@end


/**
 * @protocol MobileRTCAICompanionSmartSummaryHelperDelegate
 * @brief Delegate protocol to receive Smart Summary feature status updates and requests.
 */
@protocol MobileRTCAICompanionSmartSummaryHelperDelegate <NSObject>
@optional
/**
 * @brief Callback event when the meeting does not support smart summary.
 */
- (void)onSmartSummaryStateNotSupported;

/**
 * @brief Callback event when the meeting supports smart summary but the smart summary feature is disabled.
 */
- (void)onSmartSummaryStateSupportedButDisabled;

/**
 * @brief Callback event when the meeting smart summary is not started.
 * @param handler The handler to start smart summary.
 */
- (void)onSmartSummaryStateEnabledButNotStarted:(MobileRTCStartSmartSummaryHandler *_Nullable)handler;

/**
 * @brief Callback event when the meeting smart summary is started.
 * @param handler The handler to stop smart summary.
 * @warning If the user can not stop smart summary, the handler will be nil.
 */
- (void)onSmartSummaryStateStarted:(MobileRTCStopSmartSummaryHandler *_Nullable)handler;

/**
 * @brief Callback event when starting the smart summary fails.
 * @param bTimeout YES if timeout. Otherwise, NO. May be declined by host or co-host.
 */
- (void)onFailedToStartSmartSummary:(BOOL)bTimeout;

/**
 * @brief Callback event when receiving a request to start smart summary.
 * @param handler The handler to handle the request.
 */
- (void)onSmartSummaryStartRequestReceived:(MobileRTCApproveStartSmartSummaryHandler *_Nullable)handler;

@end

/**
 * @class MobileRTCAICompanionSmartSummaryHelper.
 * @brief Smart Summary Helper in ZOOM meeting.
 */
@interface MobileRTCAICompanionSmartSummaryHelper : NSObject

@property(nonatomic, weak) id<MobileRTCAICompanionSmartSummaryHelperDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

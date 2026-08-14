/**
 * @file MobileRTCMeetingService+SmartSummary.h
 * @brief Meeting+SmartSummary service functionality and management.
 * The AI Companion brand has been retired. AI-powered features are now more deeply integrated throughout Zoom Workplace. Existing APIs and SDKs that reference AI Companion will continue to function as before to ensure backward compatibility.
 */

#import <MobileRTC/MobileRTC.h>

/**
 * @class MobileRTCSmartSummaryPrivilegeHandler
 * @brief Interface to handle start smart summary request.
 */
@interface MobileRTCSmartSummaryPrivilegeHandler : NSObject
/**
 * @brief Agrees to the start smart summary request.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @deprecated Use MobileRTCAICompanionSmartSummaryHelper instead.
 */
- (MobileRTCSDKError)accept DEPRECATED_MSG_ATTRIBUTE("Use MobileRTCAICompanionSmartSummaryHelper instead");

/**
 * @brief Declines the start smart summary request.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @deprecated Use MobileRTCAICompanionSmartSummaryHelper instead.
 */
- (MobileRTCSDKError)decline DEPRECATED_MSG_ATTRIBUTE("Use MobileRTCAICompanionSmartSummaryHelper instead");

/**
 * @brief Ignores the start smart summary request.
 * @deprecated Use MobileRTCAICompanionSmartSummaryHelper instead.
 */
- (void)ignore DEPRECATED_MSG_ATTRIBUTE("Use MobileRTCAICompanionSmartSummaryHelper instead");
@end

/**
 * @brief This class provides interfaces to manage and control the smart summary feature in meetings.
 */
@interface MobileRTCMeetingService (SmartSummary)

/**
 * @brief Determines if the current meeting supports smart summary feature.
 * @return YES if the current meeting supports the smart summary feature. Otherwise, NO.
 * @deprecated Use MobileRTCAICompanionSmartSummaryHelper instead.
 */
- (BOOL)isSmartSummarySupported DEPRECATED_MSG_ATTRIBUTE("Use MobileRTCAICompanionSmartSummaryHelper instead");

/**
 * @brief Determines if the smart summary feature is enabled in the meeting.
 * @return YES if smart summary feature is enabled. Otherwise, NO.
 * @deprecated Use MobileRTCAICompanionSmartSummaryHelper instead.
 */
- (BOOL)isSmartSummaryEnabled DEPRECATED_MSG_ATTRIBUTE("Use MobileRTCAICompanionSmartSummaryHelper instead");

/**
 * @brief Determines whether the current user can request the host to start the smart summary for the current meeting.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @deprecated Use MobileRTCAICompanionSmartSummaryHelper instead.
 */
- (MobileRTCSDKError)canRequestStartSmartSummary DEPRECATED_MSG_ATTRIBUTE("Use MobileRTCAICompanionSmartSummaryHelper instead");

/**
 * @brief Requests the host to start the smart summary for the current meeting.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @deprecated Use MobileRTCAICompanionSmartSummaryHelper instead.
 */
- (MobileRTCSDKError)requestStartSmartSummary DEPRECATED_MSG_ATTRIBUTE("Use MobileRTCAICompanionSmartSummaryHelper instead");

/**
 * @brief Determines whether the current user is able to start smart summary.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @deprecated Use MobileRTCAICompanionSmartSummaryHelper instead.
 */
- (MobileRTCSDKError)canStartSmartSummary DEPRECATED_MSG_ATTRIBUTE("Use MobileRTCAICompanionSmartSummaryHelper instead");

/**
 * @brief Starts smart summary.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @deprecated Use MobileRTCAICompanionSmartSummaryHelper instead.
 */
- (MobileRTCSDKError)startSmartSummary DEPRECATED_MSG_ATTRIBUTE("Use MobileRTCAICompanionSmartSummaryHelper instead");

/**
 * @brief Stops smart summary.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @deprecated Use MobileRTCAICompanionSmartSummaryHelper instead.
 */
- (MobileRTCSDKError)stopSmartSummary DEPRECATED_MSG_ATTRIBUTE("Use MobileRTCAICompanionSmartSummaryHelper instead");

/**
 * @brief Queries whether smart summary is started.
 * @return YES if smart summary is started. Otherwise, NO.
 * @deprecated Use MobileRTCAICompanionSmartSummaryHelper instead.
 */
- (BOOL)isSmartSummaryStarted DEPRECATED_MSG_ATTRIBUTE("Use MobileRTCAICompanionSmartSummaryHelper instead");

@end


/**
 * @file MobileRTCMeetingService+AICompanion.h
 * @brief Meeting+AICompanion service functionality and management.
 * The AI Companion brand has been retired. AI-powered features are now more deeply integrated throughout Zoom Workplace. Existing APIs and SDKs that reference AI Companion will continue to function as before to ensure backward compatibility.
 */

#import <MobileRTC/MobileRTC.h>
#import <MobileRTC/MobileRTCAICQueryHelper.h>
#import <MobileRTC/MobileRTCAICSmartSummaryHelper.h>
NS_ASSUME_NONNULL_BEGIN

/**
 * @class MobileRTCAICompanionTurnOnAgainHandler
 * @brief AI Companion  in meeting.
 */
@interface MobileRTCAICompanionTurnOnAgainHandler : NSObject
/**
 * @brief Gets the list of features that the attendee turned off.
 * @return The AI Companion feature list. See \link MobileRTCAICompanionType \endlink.
 */
- (NSArray *)getFeatureList;
/**
 * @brief Gets the feature list that the assets are deleted when the feature is turned off by attendee.
 * @return The AI Companion feature list. See \link MobileRTCAICompanionType \endlink.
 */
- (NSArray *)getAssetsDeletedFeatureList;
/**
 * @brief Turns on the auto AI Companion feature which was stopped by the attendee before the host or co-host joined the meeting.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)turnOnAgain;
/**
 * @brief Agrees to the auto AI Companion feature turn off status. Keeps the AI Companion feature off.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)agreeTurnOff;

@end

/**
 * @class MobileRTCAICompanionSwitchHandler
 * @brief The handler to handle a user request to turn the  AI Companion features on or off.
 */
@interface MobileRTCAICompanionSwitchHandler : NSObject
/**
 * @brief Gets the user ID who requests the host to turn the AI Companion features on or off.
 * @return The request user ID.
 */
-(NSUInteger)getRequestUserID;
/**
 * @brief Gets the display name of the user who requests the host to turn the AI Companion features on or off.
 * @return The request user display name. Returns an empty string if unavailable.
 */
- (NSString *)getRequestUserName;
/**
 * @brief Determines if the request is to turn the AI Companion features on or off.
 * @return YES if turn on the AI Companion features. Otherwise, NO to turn off.
 */
-(BOOL)isTurnOn;

/**
 * @brief Agrees to the request to turn the AI Companion features on or off.
 * @param deleteAssets YES to delete the meeting assets when turning off the AI Companion features. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)agree:(BOOL)deleteAssets;

/**
 * @brief Declines the request to turn the AI Companion features on or off.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)decline;

@end


/**
 * @brief AI Companion feature control class.
 */
@interface MobileRTCMeetingService (AICompanion)

/**
 * @brief Determines whether the meeting supports turning off the AI Companion features.
 * @return YES if the meeting can support turning off the AI Companion features. Otherwise, NO.
 */
- (BOOL)isTurnoffAllAICompanionsSupported;
/**
 * @brief Determines whether the current user can turn off the AI Companion features.
 * @return YES if the user can turn off the AI Companion features. Otherwise, NO.
 */
- (BOOL)canTurnOffAllAICompanions;
/**
 * @brief Turns off the AI Companion features.
 * @param deleteMeetingAssets YES to delete the meeting assets when turning off the AI Companion features. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @note All AI features including \link MobileRTCAICompanionType_QUERY \endlink, \link MobileRTCAICompanionType_SMART_SUMMARY \endlink, and \link MobileRTCAICompanionType_SMART_RECORDING \endlink can be turned off at once.
 */
- (MobileRTCSDKError)turnOffAllAICompanion:(BOOL)deleteMeetingAssets;
/**
 * @brief Determines whether the meeting supports turning on the AI Companion features.
 * @return YES if the meeting can support turning on the AI Companion features. Otherwise, NO.
 */
- (BOOL)isTurnOnAllAICompanionSupported;
/**
 * @brief Determines whether the current user can turn on the AI Companion features.
 * @return YES if the user can turn on the AI Companion features. Otherwise, NO.
 */
- (BOOL)canTurnOnAllAICompanion;
/**
 * @brief Turns on all the AI Companion features.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)turnOnAllAICompanion;
/**
 * @brief Determines whether the current user can ask the host to turn off all started AI Companion features.
 * @return YES if the user can request host to turn off the AI Companion features. Otherwise, NO.
 * @note If the current user joins the meeting before the host, they can check \link MobileRTCMeetingService::canTurnOffAllAICompanions \endlink to turn off the AI Companion features by himself or herself.
 * @note All AI features including \link MobileRTCAICompanionType_QUERY \endlink, \link MobileRTCAICompanionType_SMART_SUMMARY \endlink, and \link MobileRTCAICompanionType_SMART_RECORDING \endlink can be turned off at once.
 */
- (BOOL)canRequestTurnoffAllAICompanion;
/**
 * @brief Asks host to turn off all started AI Companion features.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @note All AI features including \link MobileRTCAICompanionType_QUERY \endlink, \link MobileRTCAICompanionType_SMART_SUMMARY \endlink, and \link MobileRTCAICompanionType_SMART_RECORDING \endlink can be turned off at once.
 */
- (MobileRTCSDKError)requestTurnoffAllAICompanion;
/**
 * @brief Determines whether the current user can ask the host to turn on all AI Companion features if they are enabled for the current meeting.
 * @return YES if the user can ask the host to turn on the AI Companion features. Otherwise, NO.
 * @note Only \link MobileRTCAICompanionType_QUERY \endlink and \link MobileRTCAICompanionType_SMART_SUMMARY \endlink can be turned on at once.
 */
- (BOOL)canRequestTurnOnAllAICompanion;
/**
 * @brief Asks host to turn on all AI Companion features if they are enabled for the current meeting.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @note Only \link MobileRTCAICompanionType_QUERY \endlink and \link MobileRTCAICompanionType_SMART_SUMMARY \endlink can be turned on at once.
 */
- (MobileRTCSDKError)requestTurnOnAllAICompanion;

/**
 * @brief Gets the AI Companion Query Helper.
 * @return If the function succeeds, it returns a MobileRTCAICompanionQueryHelper object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCAICompanionQueryHelper *)getQueryHelper;


/**
 * @brief Gets the smart summary helper.
 * @return If the function succeeds, it returns a MobileRTCAICompanionSmartSummaryHelper object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCAICompanionSmartSummaryHelper *)getSmartSummaryHelper;

@end

NS_ASSUME_NONNULL_END

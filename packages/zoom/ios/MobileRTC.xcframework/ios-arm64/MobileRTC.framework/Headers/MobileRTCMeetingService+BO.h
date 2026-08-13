/**
 * @file MobileRTCMeetingService+BO.h
 * @brief Meeting+BO service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>
#import <MobileRTC/MobileRTCBORole.h>

/**
 * @brief Creates Breakout Room meetings-related objects and fetches Breakout Room-related status information.
 */
@interface MobileRTCMeetingService (BO)
/**
 * @brief Gets the object for creating Breakout Room meetings defined in [MobileRTCBOCreator].
 * @return If the function succeeds, it returns a MobileRTCBOCreator object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCBOCreator * _Nullable)getCreatorHelper;

/**
 * @brief Gets the object for administrator management of Breakout Room meetings defined in [MobileRTCBOAdmin].
 * @return If the function succeeds, it returns a MobileRTCBOAdmin object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCBOAdmin * _Nullable)getAdminHelper;

/**
 * @brief Gets the object for help assistant of Breakout Room meetings defined in [MobileRTCBOAssistant].
 * @return If the function succeeds, it returns a MobileRTCBOAssistant object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCBOAssistant * _Nullable)getAssistantHelper;

/**
 * @brief Gets the object for attendee functionality of Breakout Room meetings defined in [MobileRTCBOAttendee].
 * @return If the function succeeds, it returns a MobileRTCBOAttendee object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCBOAttendee * _Nullable)getAttedeeHelper;

/**
 * @brief Gets the object for Breakout Room meeting ID information defined in [MobileRTCBOData].
 * @return If the function succeeds, it returns a MobileRTCBOData object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCBOData * _Nullable)getDataHelper;

/**
 * @brief Determines if the Breakout Room meeting has begun.
 * @return YES if the Breakout Room meeting has begun. Otherwise, NO.
 */
- (BOOL)isBOMeetingStarted;

/**
 * @brief Determines if the Breakout Room feature is enabled in the meeting.
 * @return YES if the Breakout Room feature is enabled. Otherwise, NO.
 */
- (BOOL)isBOMeetingEnabled;

/**
 * @brief Determines if currently in Breakout Room during the meeting.
 * @return YES if currently in Breakout Room. Otherwise, NO.
 */
- (BOOL)isInBOMeeting;

/**
 * @brief Queries if the host is broadcasting voice to BO.
 * @return YES if the host is broadcasting. Otherwise, NO.
 */
- (BOOL)isBroadcastingVoiceToBO;

/**
 * @brief Gets the current Breakout status.
 * @return The enum for Breakout status. See [MobileRTCBOStatus].
 */
- (MobileRTCBOStatus)getBOStatus;

/**
 * @brief Gets the name of the BO you are going to.
 * @return The join BO name which you are going to.
 * @note When you enter a BO or are switched to another BO by the host, you may need the BO name to display on the transfer UI.
 */
- (NSString * _Nullable)getJoiningBOName;

@end



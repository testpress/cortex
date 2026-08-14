/**
 * @file MobileRTCJoinMeetingInfoHandler.h
 * @brief Handler for providing required information to join a meeting.
 */

#import <Foundation/Foundation.h>
#import <MobileRTC/MobileRTCConstants.h>

/**
 * @class MobileRTCJoinMeetingInfoHandler
 * @brief Interface for handling user input when joining a meeting requires additional information.
 */
@interface MobileRTCJoinMeetingInfoHandler : NSObject

/**
 * @brief Gets the type of information required to join the meeting.
 */
@property (nonatomic, assign, readonly) MobileRTCJoinMeetingInfo info;

/**
 * @brief Inputs the display name and meeting password to continue joining the meeting.
 * @param displayName The display name to show in the meeting.
 * @param password The meeting password.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)inputDisplayName:(NSString *_Nullable)displayName password:(NSString *_Nullable)password;

/**
 * @brief Confirms the user's display name and audio and video settings before joining the meeting.
 * @param screenName The user's display name. Can be null or empty if the display name has already been set.
 * @param videoOn YES if video is on in meeting. NO otherwise.
 * @param audioOn YES if audio is on in meeting. NO otherwise.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @note Only for custom UI.
 */
- (MobileRTCSDKError)confirmPreview:(NSString *_Nullable)screenName videoOn:(BOOL)videoOn audioOn:(BOOL)audioOn;

/**
 * @brief Cancels the attempt to join the meeting.
 */
- (void)cancel;

@end

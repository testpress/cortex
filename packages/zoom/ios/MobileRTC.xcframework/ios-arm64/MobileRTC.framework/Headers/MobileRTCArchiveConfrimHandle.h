/**
 * @file MobileRTCArchiveConfrimHandle.h
 * @brief Archive confirmation handler for meeting recordings.
 */

#import <Foundation/Foundation.h>
#import <MobileRTC/MobileRTCConstants.h>

/**
 * @class MobileRTCArchiveConfrimHandle
 * @brief An interface for users to handle confirmation whether to start archive after joining the meeting.
 */
@interface MobileRTCArchiveConfrimHandle : NSObject

/**
 * @brief Joins the meeting.
 * @param startArchive YES to start the archive when joining the meeting, NO to not start the archive when joining the meeting.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)joinWithArchive:(BOOL)startArchive;

/**
 * @brief Gets the content that notifies the user to confirm starting archive when joining the meeting.
 * @return The content that notifies the user to confirm starting archive when joining the meeting.
 */
- (NSString * _Nullable)getArchiveConfirmContent;
@end

/**
 * @class MobileRTCRecoverMeetingHandle
 * @brief An interface for host users to handle whether to recover the meeting when starting a deleted or expired meeting.
 */
@interface MobileRTCRecoverMeetingHandle : NSObject

/**
 * @brief Joins the meeting.
 * @param toRecover YES to recover the meeting and start the meeting, NO to not recover the meeting and leave the start meeting process.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)recoverMeeting:(BOOL)toRecover;

/**
 * @brief Gets the content that notifies the host user to recover the meeting.
 * @return The content that notifies the host user to recover the meeting.
 */
- (NSString * _Nullable)getRecoverMeetingContent;
@end

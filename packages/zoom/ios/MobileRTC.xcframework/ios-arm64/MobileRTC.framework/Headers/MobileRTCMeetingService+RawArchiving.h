/**
 * @file MobileRTCMeetingService+RawArchiving.h
 * @brief Meeting+RawArchiving service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

/**
 * @brief Interface for managing raw archiving privilege in Zoom SDK.
 */
@interface MobileRTCMeetingService (RawArchiving)

/**
 * @brief Starts raw archiving and gets raw data receive privilege.
 * @return YES if starting raw archiving succeeds. Otherwise, NO.
 */
- (BOOL)startRawArchiving;

/**
 * @brief Stops raw archiving and revokes raw data receive privilege.
 * @return YES if stopping raw archiving succeeds. Otherwise, NO.
 */
- (BOOL)stopRawArchiving;

@end


/**
 * @file MobileRTCInMeetingDeviceInfo.h
 * @brief Device information and capabilities during meetings.
 */

#import <Foundation/Foundation.h>
/**
 * @class MobileRTCInMeetingDeviceInfo
 * @brief A class that contains meeting device information.
 */
@interface MobileRTCInMeetingDeviceInfo : NSObject

/**
 * @brief The index.
 * @deprecated Use \link meetingId \endlink instead.
 */
@property(nonatomic, assign, readonly) NSInteger index DEPRECATED_MSG_ATTRIBUTE("Please use meetingId instead");

/**
 * @brief The device name.
 */
@property(nonatomic, copy, readonly) NSString * _Nullable deviceName;

/**
 * @brief The meeting topic.
 */
@property(nonatomic, copy, readonly) NSString * _Nullable meetingTopic;

/**
 * @brief The meeting number.
 */
@property(nonatomic, assign, readonly) NSUInteger meetingNumber;

/**
 * @brief The meeting ID.
 */
@property(nonatomic, copy, readonly) NSString * _Nullable meetingId;

/**
 * @brief Indicates whether this meeting supports joining in companion mode.
 */
@property(nonatomic, assign) BOOL isSupportCompanionMode;

@end

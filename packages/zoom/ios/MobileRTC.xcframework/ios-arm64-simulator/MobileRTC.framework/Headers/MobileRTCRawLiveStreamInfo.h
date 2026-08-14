/**
 * @file MobileRTCRawLiveStreamInfo.h
 * @brief Raw live streaming information and configuration.
 */

#import <Foundation/Foundation.h>

/**
 * @class MobileRTCRawLiveStreamInfo
 * @brief A class that contains raw live stream information, such as the broadcast name and URL.
 */
@interface MobileRTCRawLiveStreamInfo : NSObject

/**
 * @brief The user ID.
 */
@property(nonatomic, assign, readonly) NSUInteger userId;

/**
 * @brief The broadcast URL (hosted by you or the URL to your Zoom App Marketplace page).
 */
@property(nonatomic, copy, readonly) NSString * _Nullable broadcastUrl;

/**
 * @brief The broadcast name.
 */
@property(nonatomic, copy, readonly) NSString * _Nullable broadcastName;

@end


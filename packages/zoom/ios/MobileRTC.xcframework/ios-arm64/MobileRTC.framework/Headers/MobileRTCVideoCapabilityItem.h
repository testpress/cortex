/**
 * @file MobileRTCVideoCapabilityItem.h
 * @brief Video capability information and device specifications.
 */

#import <Foundation/Foundation.h>

/**
 * @class MobileRTCVideoCapabilityItem
 * @brief A class that contains video capability information.
 */
@interface MobileRTCVideoCapabilityItem : NSObject

/**
 * @brief The video frame width.
 */
@property (nonatomic, assign) int width;

/**
 * @brief The video frame height.
 */
@property (nonatomic, assign) int height;

/**
 * @brief The video frame rate.
 */
@property (nonatomic, assign) int videoFrame;

@end

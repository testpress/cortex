/**
 * @file MobileRTCShareSender.h
 * @brief Screen sharing sender functionality.
 */

#import <Foundation/Foundation.h>
#include <MobileRTC/MobileRTCConstants.h>

/**
 * @class MobileRTCShareSender
 * @brief Sends share raw data in a meeting.
 */
@interface MobileRTCShareSender : NSObject

/**
 * @brief Sends share raw data in a meeting.
 * @param frameBuffer The buffer of the data to send.
 * @param width The width of the data to send.
 * @param height The height of the data to send.
 * @param dataLength The length of the data to send.
 * @param format The format of the data to send.
 */
- (void)sendShareFrameBuffer:(char *)frameBuffer width:(NSUInteger)width height:(NSUInteger)height frameLength:(NSUInteger)dataLength format:(MobileRTCFrameDataFormat)format;

@end

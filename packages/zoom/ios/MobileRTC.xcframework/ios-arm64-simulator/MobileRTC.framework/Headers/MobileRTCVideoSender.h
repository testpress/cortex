/**
 * @file MobileRTCVideoSender.h
 * @brief Video sender functionality for custom video input.
 */

#import <Foundation/Foundation.h>
#import <MobileRTC/MobileRTCConstants.h>

/**
 * @class MobileRTCVideoSender
 * @brief A class that sends video raw data.
 */
@interface MobileRTCVideoSender : NSObject

/**
 * @brief Sends video raw data.
 * @param frameBuffer The YUV420I buffer for each frame of the video.
 * @param width The width of the raw data for each frame of the video.
 * @param height The height of the raw data for each frame of the video.
 * @param dataLength The data length of the raw data for each frame of the video.
 * @param rotation The rotation of the raw data for each frame of the video.
 */
- (void)sendVideoFrame:(char *)frameBuffer width:(NSUInteger)width height:(NSUInteger)height dataLength:(NSUInteger)dataLength rotation:(MobileRTCVideoRawDataRotation)rotation;
@end


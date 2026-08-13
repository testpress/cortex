/**
 * @file MobileRTCAudioSender.h
 * @brief Audio sender functionality for custom audio input.
 */

#import <Foundation/Foundation.h>

/**
 * @class MobileRTCAudioSender
 * @brief Sends external raw audio data to the Zoom meeting.
 */
@interface MobileRTCAudioSender : NSObject

/**
 * @brief Sends audio raw data. Channel number must be mono, and sampling bits must be 16.
 * @param data The address of audio data.
 * @param length The length of audio data (it must be an even number).
 * @param rate The sample rate of audio data (8000/11025/32000/44100/48000/50000/50400/96000/192000/2822400).
 * @return If the function succeeds, it will return MobileRTCRawDataError_Success. Otherwise return an error.
 */
- (MobileRTCRawDataError)send:(char*)data dataLength:(unsigned int)length sampleRate:(int)rate;

@end


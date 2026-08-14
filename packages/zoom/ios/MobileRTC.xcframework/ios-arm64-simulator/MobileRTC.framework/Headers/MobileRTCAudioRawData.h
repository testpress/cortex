/**
 * @file MobileRTCAudioRawData.h
 * @brief Raw audio data handling for custom audio processing.
 */

#import <Foundation/Foundation.h>

/**
 * @class MobileRTCAudioRawData
 * @brief Represents audio raw data received from the SDK.
 */
@interface MobileRTCAudioRawData : NSObject

/**
 * @brief A pointer to the audio buffer data.
 */
@property (nonatomic, assign) char * _Nullable buffer;

/**
 * @brief The length of the audio buffer data.
 */
@property (nonatomic, assign) NSInteger bufferLen;

/**
 * @brief The audio sampling rate.
 */
@property (nonatomic, assign) NSInteger sampleRate;

/**
 * @brief The number of audio channels.
 */
@property (nonatomic, assign) NSInteger channelNum;

/**
 * @brief The timestamp of the audio data.
 */
@property(nonatomic, strong, nullable)  NSDate *timeStamp;

/**
 * @brief Determines if the reference count can be increased.
 * @return YES if the reference count can be increased. Otherwise, NO.
 */
- (BOOL)canAddRef;

/**
 * @brief Increases the reference count by 1.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)addRef;

/**
 * @brief Decreases the reference count by 1.
 * @return If the function succeeds, it returns the reference count of this object.
 */
- (NSInteger)releaseRef;

@end


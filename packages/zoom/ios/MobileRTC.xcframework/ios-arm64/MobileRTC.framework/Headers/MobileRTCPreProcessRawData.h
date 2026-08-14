/**
 * @file MobileRTCPreProcessRawData.h
 * @brief Raw data preprocessing utilities.
 */

#import <Foundation/Foundation.h>

/**
 * @class MobileRTCPreProcessRawData
 * @brief A class that contains YUV video frame data.
 */
@interface MobileRTCPreProcessRawData : NSObject

/**
 * @brief The size of the video data.
 */
@property (nonatomic, assign) CGSize size;

/**
 * @brief The Y stride.
 */
@property (nonatomic, assign) int yStride;

/**
 * @brief The U stride.
 */
@property (nonatomic, assign) int uStride;

/**
 * @brief The V stride.
 */
@property (nonatomic, assign) int vStride;

/**
 * @brief Gets the Y buffer.
 * @param lineNum The line number.
 * @return If the function succeeds, it returns the Y buffer.
 */
- (char *)getYBuffer:(int)lineNum;

/**
 * @brief Gets the U buffer.
 * @param lineNum The line number.
 * @return If the function succeeds, it returns the U buffer.
 */
- (char *)getUBuffer:(int)lineNum;

/**
 * @brief Gets the V buffer.
 * @param lineNum The line number.
 * @return If the function succeeds, it returns the V buffer.
 */
- (char *)getVBuffer:(int)lineNum;

/**
 * @brief The raw data format of the video data.
 */
@property (nonatomic, assign) MobileRTCFrameDataFormat format;

/**
 * @brief The video data rotation.
 */
@property (nonatomic, assign) MobileRTCVideoRawDataRotation rotation;

@end


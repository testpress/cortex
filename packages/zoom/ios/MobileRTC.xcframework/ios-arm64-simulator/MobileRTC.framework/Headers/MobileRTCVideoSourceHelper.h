/**
 * @file MobileRTCVideoSourceHelper.h
 * @brief Helper for managing video sources and capture.
 */

#import <Foundation/Foundation.h>

/**
 * @class MobileRTCVideoSourceHelper
 * @brief A helper for managing video sources and capture.
 */
@interface MobileRTCVideoSourceHelper : NSObject

/**
 * @brief Preprocesses video's YUV420 data before rendering receive.
 * @param delegate The delegate. See MobileRTCPreProcessorDelegate.
 * @return If the function succeeds, it will return MobileRTCRawDataError_Success. Otherwise return an error.
 * @warning Set nil to stop preprocessor.
 */
-(MobileRTCRawDataError)setPreProcessor:(id<MobileRTCPreProcessorDelegate>) delegate;

/**
 * @brief Sends your own video raw data.
 * @param delegate The delegate. See MobileRTCVideoSourceDelegate.
 * @param format The video source frame data format.
 * @return If the function succeeds, it will return MobileRTCRawDataError_Success. Otherwise return an error.
 * @warning Set nil to switch to internal video source.
 */
-(MobileRTCRawDataError)setExternalVideoSource:(id<MobileRTCVideoSourceDelegate>)delegate videoDataFormat:(MobileRTCFrameDataFormat)format;

@end

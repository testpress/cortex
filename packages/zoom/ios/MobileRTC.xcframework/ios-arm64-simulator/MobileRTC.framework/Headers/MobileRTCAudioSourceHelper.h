/**
 * @file MobileRTCAudioSourceHelper.h
 * @brief Helper utilities for audiosource functionality.
 */

#import <Foundation/Foundation.h>


/**
 * @class MobileRTCAudioSourceHelper
 * @brief Configure external audio source as virtual microphone input.
 */
@interface MobileRTCAudioSourceHelper : NSObject

/**
 * @brief Sets the delegate of virtual audio source.
 * @param audioSourceDelegate The delegate to receive callback.
 * @return If the function succeeds, it will return MobileRTCRawDataError_Success. Otherwise return an error.
 */
- (MobileRTCRawDataError)setExternalAudioSource:(id <MobileRTCAudioSourceDelegate> _Nullable)audioSourceDelegate;

@end

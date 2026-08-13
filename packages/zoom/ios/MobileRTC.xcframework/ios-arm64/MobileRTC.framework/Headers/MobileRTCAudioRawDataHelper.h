/**
 * @file MobileRTCAudioRawDataHelper.h
 * @brief Helper utilities for audio raw data processing and management.
 */

#import <Foundation/Foundation.h>

/**
 * @class MobileRTCAudioRawDataHelper
 * @brief A helper to subscribe or unsubscribe audio raw data.
 */
@interface MobileRTCAudioRawDataHelper : NSObject

/**
 * @brief Initializes MobileRTCAudioRawDataHelper.
 * @param delegate The delegate to receive the callback.
 * @return The MobileRTCAudioRawDataHelper object.
 */
- (instancetype _Nonnull)initWithDelegate:(id<MobileRTCAudioRawDataDelegate>_Nonnull) delegate;

/**
 * @brief Starts audio raw data.
 * @return If the function succeeds, it will return MobileRTCRawDataError_Success. Otherwise return an error.
 */
-(MobileRTCRawDataError)subscribe;

/**
 * @brief Stops audio raw data.
 * @return If the function succeeds, it will return MobileRTCRawDataError_Success. Otherwise return an error.
 */
- (MobileRTCRawDataError)unSubscribe;

@end

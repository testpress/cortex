/**
 * @file MobileRTCShareSourceHelper.h
 * @brief Helper for managing screen sharing sources.
 */

#import <Foundation/Foundation.h>


/**
 * @class MobileRTCShareSourceHelper
 * @brief A helper that manages external source for share video and share audio in a meeting.
 */
@interface MobileRTCShareSourceHelper : NSObject

/**
 * @brief Starts sharing external source.
 * @param shareDelegate The external source object pointer. See MobileRTCShareSourceDelegate.
 * @param audioDelegate The external audio source object pointer. See MobileRTCShareAudioSourceDelegate.
 * @return If the function succeeds, it will return MobileRTCRawDataError_Success. Otherwise return an error.
 * @warning If audioDelegate is non-null, it indicates sharing user-defined audio at the same time.
 */
- (MobileRTCRawDataError)setExternalShareSource:(id<MobileRTCShareSourceDelegate> _Nullable)shareDelegate andAudioSource:(id <MobileRTCShareAudioSourceDelegate> _Nullable)audioDelegate;

@end


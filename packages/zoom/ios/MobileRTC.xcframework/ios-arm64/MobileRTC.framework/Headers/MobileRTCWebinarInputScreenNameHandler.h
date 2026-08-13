/**
 * @file MobileRTCWebinarInputScreenNameHandler.h
 * @brief Handler for webinar screen name input.
 */

/**
 * @class MobileRTCWebinarInputScreenNameHandler
 * @brief A handler for entering screen name when joining a webinar.
 */
@interface MobileRTCWebinarInputScreenNameHandler : NSObject

/**
 * @brief Inputs screen name to join the webinar.
 * @param name The display name for the webinar.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)inputName:(NSString *_Nonnull)name;

/**
 * @brief Cancels joining the webinar.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)cancel;

@end


/**
 * @file MobileRTCReturnToMainSessionHandler.h
 * @brief Handler for returning to main session from breakout rooms.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @class MobileRTCReturnToMainSessionHandler
 * @brief A handler for returning to main session from breakout meeting.
 */
@interface MobileRTCReturnToMainSessionHandler : NSObject

/**
 * @brief Returns to main session for the main session invitation.
 * @return YES if return succeeds. Otherwise, NO.
 */
- (BOOL)returnToMainSession;

/**
 * @brief Ignores the main session invitation.
 */
- (void)ignore;

@end

NS_ASSUME_NONNULL_END

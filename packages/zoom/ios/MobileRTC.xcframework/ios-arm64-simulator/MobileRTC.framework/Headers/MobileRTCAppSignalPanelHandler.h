/**
 * @file MobileRTCAppSignalPanelHandler.h
 * @brief App Signal Panel Handler.
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @class MobileRTCAppSignalPanelHandler
 * @brief Handler for app signal panel in meeting.
 */
@interface MobileRTCAppSignalPanelHandler : NSObject
/**
 * @brief Determines if the panel can be shown.
 * @return YES if the panel can be shown. Otherwise, NO.
 */
- (BOOL)canShowPanel;

/**
 * @brief Shows the app signal panel.
 * @param containerView The view container to locate the application signal panel.
 * @param originXY The original point to display app signal panel.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)showAppSignalInView:(UIView *)containerView originPoint:(CGPoint)originXY;

/**
 * @brief Hides the app signal panel.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)hidePanel;

@end

NS_ASSUME_NONNULL_END

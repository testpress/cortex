/**
 * @file MobileRTCVideoView.h
 * @brief Video view component for displaying and managing video content in meetings.
 */

#import <UIKit/UIKit.h>

/**
 * @brief Enumeration of the video aspect ratio.
 */
typedef enum {
    /** Display the captured data without any cropping or scaling. */
    MobileRTCVideoAspect_Original       = 0,
    /** Stretch both horizontally and vertically to fill the display (may cause distortion). */
    MobileRTCVideoAspect_Full_Filled    = 1,
    /** Add black bars to maintain aspect ratio (e.g., 16:9 content on a 4:3 display or vice versa). */
    MobileRTCVideoAspect_LetterBox  = 2,
    /** Crop the sides or top/bottom to fill the screen (e.g., cut sides for 16:9 on 4:3, or top/bottom for 4:3 on 16:9). */
    MobileRTCVideoAspect_PanAndScan = 3,
}MobileRTCVideoAspect;

/**
 * @class MobileRTCVideoView
 * @brief A view designed for rendering attendee video.
 */
@interface MobileRTCVideoView : UIView

/**
 * @brief Gets the rendering user's ID.
 * @return The user ID that is rendering.
 */
- (NSInteger)getUserID;

/**
 * @brief Renders attendee video.
 * @param userID The user's video to display.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)showAttendeeVideoWithUserID:(NSUInteger)userID;

/**
 * @brief Stops rendering.
 */
- (void)stopAttendeeVideo;

/**
 * @brief Sets the video aspect according to customer requirements.
 * @param aspect The video aspect.
 */
- (void)setVideoAspect:(MobileRTCVideoAspect)aspect;

@end

/**
 * @class MobileRTCPreviewVideoView
 * @brief A view designed for previewing self video.
 * @warning App needs to respond to onSinkMeetingPreviewStopped. SDK handles start and stop preview.
 */
@interface MobileRTCPreviewVideoView : MobileRTCVideoView
@end

/**
 * @class MobileRTCActiveVideoView
 * @brief A view designed for rendering active video.
 */
@interface MobileRTCActiveVideoView : MobileRTCVideoView
@end

/**
 * @class MobileRTCActiveShareView
 * @brief A view designed for rendering share content.
 */
@interface MobileRTCActiveShareView : MobileRTCVideoView

/**
 * @brief Renders share content.
 * @param shareSourceID The user's shared content to display.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)showActiveShareWithShareSourceID:(NSUInteger)shareSourceID;

/**
 * @brief Stops rendering share content.
 */
- (void)stopActiveShare;

/**
 * @brief Changes the share content scale.
 * @param shareSourceID The user's shared content scale to change.
 */
- (void)changeShareScaleWithShareSourceID:(NSUInteger)shareSourceID;

/**
 * @brief Gets the share source ID.
 * @return If the function succeeds, it returns the share source ID.
 */
- (NSUInteger)getShareSourceID;

@end

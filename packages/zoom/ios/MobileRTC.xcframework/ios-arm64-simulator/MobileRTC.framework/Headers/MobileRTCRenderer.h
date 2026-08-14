/**
 * @file MobileRTCRenderer.h
 * @brief Video rendering functionality and display management.
 */

#import <Foundation/Foundation.h>
#import <MobileRTC/MobileRTCMeetingDelegate.h>

/**
 * @class MobileRTCRenderer
 * @brief A class for rendering video raw data.
 */
@interface MobileRTCRenderer : NSObject

/**
 * @brief The user ID.
 */
@property (nonatomic, assign, readonly) NSUInteger userId;

/**
 * @brief The video type.
 */
@property (nonatomic, assign, readonly) MobileRTCVideoType videoType;

/**
 * @brief The video resolution.
 */
@property (nonatomic, assign, readonly) MobileRTCVideoResolution resolution;

/**
 * @brief Initializes MobileRTCRenderer.
 * @param delegate The delegate that receives callbacks.
 * @return The MobileRTCRenderer object.
 */
- (instancetype _Nonnull)initWithDelegate:(id<MobileRTCVideoRawDataDelegate>_Nonnull) delegate;

/**
 * @brief Sets the video resolution.
 * @param resolution The video resolution.
 * @return If the function succeeds, it will return MobileRTCRawDataError_Success. Otherwise return an error.
 */
- (MobileRTCRawDataError)setRawDataResolution:(MobileRTCVideoResolution)resolution;

/**
 * @brief Subscribes to raw video data.
 * @param userId The user ID.
 * @param type The video type.
 * @return If the function succeeds, it will return MobileRTCRawDataError_Success. Otherwise return an error.
 * @note Before entering the meeting, subscribe to your preview video data with userId = 0.
 * @note If you are already in the meeting, subscribe to your own video data using the real userId or userId = 0.
 */
- (MobileRTCRawDataError)subscribe:(NSUInteger)userId videoType:(MobileRTCVideoType)type;

/**
 * @brief Unsubscribes from raw video data.
 * @return If the function succeeds, it will return MobileRTCRawDataError_Success. Otherwise return an error.
 */
- (MobileRTCRawDataError)unSubscribe;

@end


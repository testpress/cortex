/**
 * @file MobileRTCVideoPixelBufferExtraInfo.h
 * @brief Per-frame extra metadata container delivered to your raw video
 *        data delegate alongside an NV12 @c CVPixelBuffer.
 */

#import <Foundation/Foundation.h>
#import "MobileRTCConstants.h"
#import "MobileRTCFaceROIInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * @class MobileRTCVideoPixelBufferExtraInfo
 * @brief Container for per-frame metadata accompanying an NV12
 *        @c CVPixelBufferRef delivered via
 *        @c -onMobileRTCRender:framePixelBuffer:extraInfo:.
 *
 * Aggregating future per-frame fields here keeps the delegate selector
 * stable as new metadata is added. This object and the contained
 * @c MobileRTCFaceROIInfo own their own data (the face ROI is captured
 * when the callback fires), so they may be safely retained and used
 * asynchronously after the callback returns. The @c CVPixelBuffer,
 * however, must be retained separately via @c CVPixelBufferRetain - it
 * is not owned by this container.
 *
 * @note The original @c -onMobileRTCRender:framePixelBuffer:rotation:
 *       selector remains supported for source compatibility but is
 *       marked deprecated. New code should adopt the @c extraInfo:
 *       variant to receive face ROI and any future metadata fields.
 *       If your delegate implements both selectors, both will be called
 *       for every frame; typically you should implement only one.
 */
@interface MobileRTCVideoPixelBufferExtraInfo : NSObject

/**
 * @brief Frame rotation as reported by the sender. Matches the value
 *        previously delivered via the legacy selector's @c rotation:
 *        parameter.
 */
@property (readonly, nonatomic) MobileRTCVideoRawDataRotation rotation;

/**
 * @brief Per-frame face ROI metadata reported by the sender.
 *
 * Always non-null; inspect @c -getFaceCount to determine whether any
 * face was reported. Captures the face rectangles when the callback
 * fires and may be retained independently of the host
 * @c MobileRTCVideoPixelBufferExtraInfo for use after the callback
 * returns.
 *
 * @note Face ROI is only supported on video streams.
 */
@property (readonly, strong, nonnull) MobileRTCFaceROIInfo *faceROIInfo;

@end

NS_ASSUME_NONNULL_END

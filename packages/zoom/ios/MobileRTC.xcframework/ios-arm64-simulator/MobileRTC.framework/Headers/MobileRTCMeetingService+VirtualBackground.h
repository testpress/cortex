/**
 * @file MobileRTCMeetingService+VirtualBackground.h
 * @brief Meeting+VirtualBackground service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

/**
 * @class MobileRTCVirtualBGImageInfo
 * @brief Image item property.
 */
@interface MobileRTCVirtualBGImageInfo : NSObject
/**
 * @brief The virtual background image type.
 */
@property(nonatomic, assign) MobileRTCVBType vbType;

/**
 * @brief YES if the current image item is being used. Otherwise, NO.
 */
@property(nonatomic, assign) BOOL isSelect;

/**
 * @brief The image path of the image item. nil for none image item.
 */
@property(nonatomic, retain) NSString* _Nullable imagePath;

/**
 * @brief YES if the current image item is allowed to be deleted. Otherwise, NO.
 */
@property(nonatomic, assign) BOOL isAllowDelete;

@end

/**
 * @brief Meeting service for virtual background.
 */
@interface MobileRTCMeetingService (VirtualBackground)
/**
 * @brief The preview for inspect the virtual background effect.
 */
@property (retain, nonatomic) UIView * _Nullable previewView;

/**
 * @brief Starts preview to inspect the virtual background effect.
 * @param frame The frame for the preview.
 * @return YES if preview is ready. Otherwise, NO.
 */
- (BOOL)startPreviewWithFrame:(CGRect)frame;

/**
 * @brief Stops previewing the virtual background.
 */
- (void)stopPreview;

/**
 * @brief Determines if the virtual background feature is supported by the meeting.
 * @return YES if the meeting supports the virtual background feature. Otherwise, NO.
 */
- (BOOL)isSupportVirtualBG;

/**
 * @brief Determines if the smart virtual background feature can be supported by the machine.
 * @return YES if the machine can support using the smart virtual background feature. Otherwise, NO.
 * @warning Device should be iPhone 8/8 Plus/X or above or be iPad Pro 9.7 above. OS should be iOS 11 or above.
 */
- (BOOL)isDeviceSupportSmartVirtualBG;

/**
 * @brief Determines if smart virtual background is supported.
 * @return YES if supported. Otherwise, NO.
 * @deprecated Use \link isDeviceSupportSmartVirtualBG \endlink instead.
 */
- (BOOL)isSupportSmartVirtualBG DEPRECATED_MSG_ATTRIBUTE("Use isDeviceSupportSmartVirtualBG instead");


#pragma mark smart virtual background
/**
 * @brief Gets the virtual background list.
 * @return If the function succeeds, it returns an NSArray of virtual background image info objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCVirtualBGImageInfo *>* _Nullable)getBGImageList;

/**
 * @brief Determines if the adding new virtual background item feature is supported by the meeting.
 * @return YES if the meeting supports adding new virtual background item feature. Otherwise, NO.
 */
- (BOOL)isAllowToAddNewVBItem;

/**
 * @brief Adds and uses the image for virtual background.
 * @param image The image to add.
 * @return Add and use virtual background result.
 */
- (MobileRTCMeetError)addBGImage:(UIImage *_Nullable)image;

/**
 * @brief Removes image item from image list. Will use the previous one for virtual background.
 * @param bgImageInfo The background image info to remove.
 * @return Remove result.
 */
- (MobileRTCMeetError)removeBGImage:(MobileRTCVirtualBGImageInfo *_Nullable)bgImageInfo;

/**
 * @brief Uses the specified image item for virtual background.
 * @param bgImage The background image info to use.
 * @return The result of use image item.
 */
- (MobileRTCMeetError)useBGImage:(MobileRTCVirtualBGImageInfo *_Nullable)bgImage;

/**
 * @brief Disables the virtual background, same as using a none image item.
 * @return The result of disable virtual background.
 * @deprecated Use \link useBGImage: \endlink instead.
 */
- (MobileRTCMeetError)useNoneImage DEPRECATED_MSG_ATTRIBUTE("Use useBGImage: instead");

#pragma mark green virtual background
/**
 * @brief Determines if using green virtual background.
 * @return YES if using green virtual background. Otherwise, NO.
 */
- (BOOL)isUsingGreenVB;

/**
 * @brief Enables or disables green virtual background mode.
 * @param enable YES to enable. Otherwise, NO to disable.
 * @return Result of enable green virtual background.
 * @warning Only iPad supports Virtual background GreenScreen. iPhone does not support the feature.
 * @warning Need to call "startPreviewWithFrame:" to get the preview View, and show it in your UI hierarchy. Then select the point in the preview view. We will use the color of your selected point (point of the preview) to calculate the background.
 */
- (MobileRTCMeetError)enableGreenVB:(BOOL)enable;

/**
 * @brief Selects the point that is regarded as background.
 * @param point The point in the preview view.
 * @return Result of set background point action.
 * @warning Only iPad supports Virtual background GreenScreen. iPhone does not support the feature.
 */
- (MobileRTCMeetError)selectGreenVBPoint:(CGPoint)point;

@end


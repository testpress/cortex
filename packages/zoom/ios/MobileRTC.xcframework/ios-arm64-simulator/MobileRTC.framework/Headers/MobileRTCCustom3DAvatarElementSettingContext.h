/**
 * @file MobileRTCCustom3DAvatarElementSettingContext.h
 * @brief Custom 3D avatar element setting context interface.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileRTC/MobileRTCConstants.h>

NS_ASSUME_NONNULL_BEGIN
@class MobileRTCCustom3DAvatarElementImageInfo;
/**
 * @protocol MobileRTCCustom3DAvatarElementSettingContextDelegate
 * @brief Delegate protocol for custom 3D avatar element setting context events.
 */
@protocol MobileRTCCustom3DAvatarElementSettingContextDelegate <NSObject>

@optional

/**
 * @brief Notification of whether or not the custom 3d avatar element image model data has been downloaded successfully.
 * @param success YES means the custom 3d avatar element image model data has been downloaded successfully.
 * @param imageInfo The custom 3D avatar element image info object.
 */
- (void)onCustom3DAvatarElementImageModelDataDownloaded:(BOOL)success imageInfo:(MobileRTCCustom3DAvatarElementImageInfo *)imageInfo;

@end


/**
 * @class MobileRTCCustom3DAvatarElementImageInfo
 * @brief Custom 3D avatar element image information.
 */
@interface MobileRTCCustom3DAvatarElementImageInfo : NSObject

/**
 * @brief Get the type of current element image.
 */
@property (nonatomic, assign) MobileRTCCustom3DAvatarElementImageType elementImageType;

/**
 * @brief Determine if the current item is being used.
 */
@property (nonatomic, assign) BOOL isSelected;

/**
 * @brief Get the file path of the current image.
 */
@property (nonatomic, copy) NSString * _Nullable imageFilePath;

/**
 * @brief Get the name of the current image.
 */
@property (nonatomic, copy) NSString * _Nullable imageName;

@end

/**
 * @class MobileRTCCustom3DAvatarElementColorInfo
 * @brief Custom 3D avatar element color information.
 */
@interface MobileRTCCustom3DAvatarElementColorInfo : NSObject

/**
 * @brief Get the type of current element color.
 */
@property (nonatomic, assign) MobileRTCCustom3DAvatarElementColorType elementColorType;

/**
 * @brief Get the color of current element color.
 */
@property (nonatomic, strong) UIColor * _Nullable color;

/**
 * @brief Determine if the current item is being used.
 */
@property (nonatomic, assign) BOOL isSelected;

/**
 * @brief Get the name of the current color.
 */
@property (nonatomic, copy) NSString * _Nullable colorName;

@end

/**
 * @class MobileRTCCustom3DAvatarElementSettingContext
 * @brief Context interface for configuring custom 3D avatar elements during avatar creation or editing.
 *
 * These interfaces are provided after calling
 * startCreateCustom3DAvatarWithPreviewView or startEditCustom3DAvatarWithPreviewView, and is used to configure
 * the visual elements of a custom 3D avatar, such as:
 * - Selecting a specific avatar element image (model)
 * - Downloading and checking readiness of element model data
 * - Applying a color to the selected avatar element
 *
 * The context represents an active avatar creation or editing session.
 * All settings applied through this interface affect the
 * currently creating or editing custom 3D avatar.
 *
 * @note
 * - These interfaces are only valid during the custom 3D avatar creation or editing process.
 * - Call setDelegate first before using any other method.
 * - The returned image/color lists are managed by the SDK; do not delete them.
 * - Model data must be downloaded and ready before applying an image.
 * - These interfaces are only valid for the custom UI mode.
 */
@interface MobileRTCCustom3DAvatarElementSettingContext : NSObject

/**
 * @brief Custom 3D avatar element setting callback handler.
 * @param delegate The delegate object that receives custom 3D avatar element setting events.
 * @note Call the function before using any other interface of the same class.
 */
- (void)setDelegate:(id<MobileRTCCustom3DAvatarElementSettingContextDelegate> _Nullable)delegate;

/**
 * @brief Get the list of available custom 3D avatar element images.
 * @return If there are images in the list, the return value is an array of MobileRTCCustom3DAvatarElementImageInfo. Otherwise returns nil.
 */
- (NSArray<MobileRTCCustom3DAvatarElementImageInfo*> * _Nullable)getCustom3DAvatarElementImageList;

/**
 * @brief Apply a custom 3D avatar element image to the avatar being created or edited.
 * @param imageInfo The custom 3D avatar element image info object to apply.
 * @return If the function succeeds, the return value is MobileRTCSDKError_Success. Otherwise failed.
 * @note The model data for the image must be ready before calling this method. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)setCustom3DAvatarElementImage:(MobileRTCCustom3DAvatarElementImageInfo* _Nullable)imageInfo;

/**
 * @brief Checks whether the model data for a specific custom 3D avatar element image has been fully downloaded and is ready for use.
 * Before an avatar element image can be applied, its model data must be fully downloaded and ready.
 * @param imageInfo The custom 3D avatar element image info object.
 * @return YES means the model data is ready; otherwise NO.
 */
- (BOOL)isCustom3DAvatarElementImageModelDataReady:(MobileRTCCustom3DAvatarElementImageInfo* _Nullable)imageInfo;

/**
 * @brief Download the model data required for a specific custom 3D avatar element image.
 * This should be called if isCustom3DAvatarElementImageModelDataReady returns NO for the specified image.
 * @param imageInfo The custom 3D avatar element image info object.
 * @return If the function succeeds, the return value is MobileRTCSDKError_Success. Otherwise failed.
 * @note This should be called before using the image if its model data is not yet ready.
 */
- (MobileRTCSDKError)downloadCustom3dAvatarElementImageModelData:(MobileRTCCustom3DAvatarElementImageInfo* _Nullable)imageInfo;

/**
 * @brief Get the list of custom 3D avatar element colors.
 * @return If there are colors in the list, the return value is an array of MobileRTCCustom3DAvatarElementColorInfo. Otherwise returns nil.
 */
- (NSArray<MobileRTCCustom3DAvatarElementColorInfo*> * _Nullable)getCustom3DAvatarElementColorList;

/**
 * @brief Apply a color to the avatar being created or edited.
 * @param colorInfo The custom 3D avatar element color info object to apply.
 * @return If the function succeeds, the return value is MobileRTCSDKError_Success. Otherwise failed.
 */
- (MobileRTCSDKError)setCustom3DAvatarElementColor:(MobileRTCCustom3DAvatarElementColorInfo* _Nullable)colorInfo;


@end

NS_ASSUME_NONNULL_END


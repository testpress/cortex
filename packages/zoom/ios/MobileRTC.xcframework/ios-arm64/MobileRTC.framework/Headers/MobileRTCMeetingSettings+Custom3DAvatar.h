/**
 * @file MobileRTCMeetingSettings+Custom3DAvatar.h
 * @brief Custom 3D avatar settings interface.
 */

#import <MobileRTC/MobileRTCMeetingSettings.h>
#import <MobileRTC/MobileRTCCustom3DAvatarElementSettingContext.h>
#import <MobileRTC/MobileRTCMeetingService+Avatar.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @brief Category for custom 3D avatar settings.
 */
@interface MobileRTCMeetingSettings (Custom3DAvatar)

/**
 * @brief Determine if the custom 3D avatar feature is enabled.
 * @return YES means the custom 3D avatar feature is enabled.
 */
- (BOOL)isCustom3DAvatarEnabled;

/**
 * @brief Get the list of available custom 3D avatar images.
 * Each image represents a custom 3D avatar that can be selected, edited, duplicated, or deleted.
 * @return If there are images in the list, the return value is an array of MobileRTC3DAvatarImageInfo. Otherwise returns nil.
 * @note This interface is only valid for the custom UI mode.
 */
- (NSArray<MobileRTC3DAvatarImageInfo*> * _Nullable)getCustom3DAvatarImageList;

/**
 * @brief Check whether the model data for a specific custom 3D avatar image is ready.
 * The avatar image can only be used after its model data has been fully downloaded and prepared.
 * @param imageInfo The custom 3D avatar image info object.
 * @return YES means the model data for the specified image has been downloaded and is ready; otherwise NO.
 * @note This interface is only valid for the custom UI mode.
 */
- (BOOL)isCustom3DAvatarImageModelDataReady:(MobileRTC3DAvatarImageInfo* _Nullable)imageInfo;

/**
 * @brief Download the model data required for a specific custom 3D avatar image.
 * Call this method if isCustom3DAvatarImageModelDataReady returns NO for the specified custom 3d avatar image.
 * @param imageInfo The custom 3D avatar image info object.
 * @return If the function succeeds, the return value is MobileRTCSDKError_Success. Otherwise failed.
 * @note This should be called before calling setCustom3DAvatarImage if its model data is not yet ready.
 * This interface is only valid for the custom UI mode.
 */
- (MobileRTCSDKError)downloadCustom3DAvatarImageModelData:(MobileRTC3DAvatarImageInfo* _Nullable)imageInfo;

/**
 * @brief Apply a custom 3D avatar image as the active avatar.
 * @param imageInfo The custom 3D avatar image info object to apply.
 * @return If the function succeeds, the return value is MobileRTCSDKError_Success. Otherwise failed.
 * @note The model data for the avatar image must be fully downloaded and ready before calling this method. Otherwise, this function returns an error.
 * This interface is only valid for the custom UI mode.
 */
- (MobileRTCSDKError)setCustom3DAvatarImage:(MobileRTC3DAvatarImageInfo* _Nullable)imageInfo;

/**
 * @brief Checks whether the model data for default custom 3D avatar elements image have been fully downloaded and are ready for use.
 * This method is typically used before starting the custom 3D avatar creation process to ensure default elements data is available.
 * @return YES means the model data for default custom 3D avatar elements image have been downloaded and are ready; otherwise NO.
 * @note This interface is only valid for the custom UI mode.
 */
- (BOOL)isCustom3DAvatarDefaultImageModelDataReady;

/**
 * @brief Download the model data required for a default custom 3D avatar image.
 * Call this method if isCustom3DAvatarDefaultImageModelDataReady returns NO for the default custom 3d avatar image.
 * @return If the function succeeds, the return value is MobileRTCSDKError_Success. Otherwise failed.
 * @note This should be called before calling startCreateCustom3DAvatarWithPreviewView if the default image model data is not yet ready.
 * This interface is only valid for the custom UI mode.
 */
- (MobileRTCSDKError)downloadCustom3DAvatarDefaultImageModelData;

/**
 * @brief Start creating a new custom 3D avatar.
 * This method initializes a custom 3D avatar creation session
 * and returns a MobileRTCCustom3DAvatarElementSettingContext instance for configuring avatar elements (image, model data, color, etc.).
 * @param previewView The UIView to display the preview.
 * @return If the function succeeds, the return value is the pointer to MobileRTCCustom3DAvatarElementSettingContext. Otherwise returns nil.
 * @note The model data for all elements image must be ready before calling this method. Otherwise returns nil.
 * If the function succeeds, before calling finishCreateCustom3DAvatar,
 * calling 3D-avatar-related API will result in an error. The maximum number of custom 3D avatars is 25; exceeding this limit will result in an error.
 * This interface is only valid for the custom UI mode.
 */
- (MobileRTCCustom3DAvatarElementSettingContext* _Nullable)startCreateCustom3DAvatarWithPreviewView:(UIView* _Nullable)previewView;

/**
 * @brief Finish creating a custom 3D avatar.
 * This method ends the custom 3D avatar creation session that was started by startCreateCustom3DAvatarWithPreviewView.
 * @param save
 * - YES: Apply the selected avatar elements and save the newly created custom 3D avatar.
 * - NO: Discard all changes and cancel the creation.
 * @return If the function succeeds, the return value is MobileRTCSDKError_Success. Otherwise failed.
 * @note This interface is only valid for the custom UI mode.
 */
- (MobileRTCSDKError)finishCreateCustom3DAvatar:(BOOL)save;

/**
 * @brief Start editing an existing custom 3D avatar.
 * This method starts an editing session for the specified custom 3D avatar
 * and returns a MobileRTCCustom3DAvatarElementSettingContext instance for modifying avatar elements such as images and colors.
 * @param previewView The UIView to display the preview.
 * @param imageInfo The custom 3D avatar image info object to edit.
 * @return If the function succeeds, the return value is the pointer to MobileRTCCustom3DAvatarElementSettingContext. Otherwise returns nil.
 * @note
 * - The model data for the avatar image must be fully downloaded and ready before calling this method.
 * - After this method succeeds and before calling finishEditCustom3DAvatar, invoking other 3D avatar-related APIs will result in an error.
 * - This interface is only valid for the custom UI mode.
 */
- (MobileRTCCustom3DAvatarElementSettingContext* _Nullable)startEditCustom3DAvatarWithPreviewView:(UIView* _Nullable)previewView imageInfo:(MobileRTC3DAvatarImageInfo* _Nullable)imageInfo;

/**
 * @brief Finish editing a custom 3D avatar.
 * This method ends the custom 3D avatar editing session that was started by startEditCustom3DAvatarWithPreviewView.
 * @param save
 * - YES: Apply the selected avatar elements and save the edited custom 3D avatar.
 * - NO: Discard all changes and cancel the editing.
 * @return If the function succeeds, the return value is MobileRTCSDKError_Success. Otherwise failed.
 * @note This interface is only valid for the custom UI mode.
 */
- (MobileRTCSDKError)finishEditCustom3DAvatar:(BOOL)save;

/**
 * @brief Duplicate a custom 3D avatar.
 * @param imageInfo The custom 3D avatar image info object to duplicate.
 * @return If the function succeeds, the return value is MobileRTCSDKError_Success. Otherwise failed.
 * @note The maximum number of custom 3D avatars is 25; exceeding this limit will result in an error.
 * This interface is only valid for the custom UI mode.
 */
- (MobileRTCSDKError)duplicateCustom3DAvatarImage:(MobileRTC3DAvatarImageInfo* _Nullable)imageInfo;

/**
 * @brief Delete a custom 3D avatar.
 * @param imageInfo The custom 3D avatar image info object to delete.
 * @return If the function succeeds, the return value is MobileRTCSDKError_Success. Otherwise failed.
 * @note This interface is only valid for the custom UI mode.
 */
- (MobileRTCSDKError)deleteCustom3DAvatarImage:(MobileRTC3DAvatarImageInfo* _Nullable)imageInfo;


@end

NS_ASSUME_NONNULL_END


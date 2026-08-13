/**
 * @file MobileRTCWaitingRoomService.h
 * @brief Waiting room management and participant handling.
 */

#import <Foundation/Foundation.h>

/**
 * @brief Enumeration of waiting room layout type. For more information, please visit <https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0059359>.
 */
typedef NS_ENUM(NSUInteger, MobileRTCWaitingRoomLayoutType) {
    /** Default layout. */
    MobileRTCWaitingRoomLayoutType_Default = 0,
    /** Layout displaying a logo. */
    MobileRTCWaitingRoomLayoutType_Logo,
    /** Layout displaying a video. */
    MobileRTCWaitingRoomLayoutType_Video,
};

/**
 * @brief Enumeration for the status of custom waiting room data.
 */
typedef NS_ENUM(NSUInteger, MobileRTCCustomWaitingRoomDataStatus) {
    /** Initial state, before any download has started. */
    MobileRTCCustomWaitingRoomDataStatus_Init,
    /** Custom waiting room data is currently being downloaded. */
    MobileRTCCustomWaitingRoomDataStatus_Downloading,
    /** Custom waiting room data has been successfully downloaded. */
    MobileRTCCustomWaitingRoomDataStatus_Download_OK,
    /** Failed to download custom waiting room data. */
    MobileRTCCustomWaitingRoomDataStatus_Download_Fail,
};

/**
 * @class MobileRTCCustomWaitingRoomData
 * @brief The WaitingRoom Customize Data Info.
 */
@interface MobileRTCCustomWaitingRoomData : NSObject
@property (nonatomic, retain) NSString * _Nullable title;

@property (nonatomic, retain) NSString * _Nullable descriptionString;

@property (nonatomic, retain) NSString * _Nullable logoPath;

@property (nonatomic, retain) NSString * _Nullable imagePath;

@property (nonatomic, retain) NSString * _Nullable videoPath;

@property (nonatomic, assign) MobileRTCWaitingRoomLayoutType type;

@property (nonatomic, assign) MobileRTCCustomWaitingRoomDataStatus status;

@end

/**
 * @protocol MobileRTCWaitingRoomServiceDelegate
 * @brief Meeting host enabled the waiting room feature, then the delegate will receive this notification  #only for custom UI#.
 */
@protocol MobileRTCWaitingRoomServiceDelegate <NSObject>

@optional

/**
 * @brief Callback event when the meeting host enabled the waiting room feature. Notifies the host that someone entered the waiting room.
 * @param userId The user ID.
 * @note Only for custom UI.
 */
- (void)onWaitingRoomUserJoin:(NSUInteger)userId;

/**
 * @brief Callback event when the meeting host enabled the waiting room feature. Notifies the host that someone left from the waiting room.
 * @param userId The user ID.
 * @note Only for custom UI.
 */
- (void)onWaitingRoomUserLeft:(NSUInteger)userId;

/**
 * @brief Callback event during the waiting room. Triggered when the host changes audio status.
 * @param audioCanTurnOn YES if audio can be turned on. Otherwise, NO.
 */
- (void)onWaitingRoomPresetAudioStatusChanged:(BOOL)audioCanTurnOn;

/**
 * @brief Callback event during the waiting room. Triggered when the host changes video status.
 * @param videoCanTurnOn YES if video can be turned on. Otherwise, NO.
 */
- (void)onWaitingRoomPresetVideoStatusChanged:(BOOL)videoCanTurnOn;

/**
 * @brief Callback event during the waiting room. Triggered when requestCustomWaitingRoomData is called.
 * @param data The WaitingRoom Customize Data Info.
 */
- (void)onCustomWaitingRoomDataUpdated:(MobileRTCCustomWaitingRoomData *_Nullable)data;

/**
 * @brief Callback event when the waiting room user name changed.
 * @param userID The user ID whose user name has changed.
 * @param userName The new name of the user.
 */
- (void)onWaitingRoomUserNameChanged:(NSInteger)userID userName:(nonnull NSString *)userName;

@end

/**
 * @class MobileRTCWaitingRoomService
 * @brief Interface for managing the waiting room during a meeting.
 */
@interface MobileRTCWaitingRoomService : NSObject

/**
 * @brief Waiting Room service delegate.
 */
@property (weak, nonatomic) id<MobileRTCWaitingRoomServiceDelegate> _Nullable delegate;

/**
 * @brief Determines if this meeting supports Waiting Room feature.
 * @return YES if supports waiting room. Otherwise, NO.
 */
-(BOOL)isSupportWaitingRoom;

/**
 * @brief Determines if this meeting has Waiting Room feature enabled.
 * @return YES if enabled. Otherwise, NO.
 */
-(BOOL)isWaitingRoomOnEntryFlagOn;

/**
 * @brief Queries if enableWaitingRoomOnEntry feature is locked.
 * @return YES if enabled. Otherwise, NO.
 */
-(BOOL)isWaitingRoomOnEntryLocked;

/**
 * @brief Enables or disables waiting room feature of this meeting.
 * @param bEnable YES to enable. Otherwise, NO to disable.
 * @return The result of this operation.
 */
- (MobileRTCMeetError)enableWaitingRoomOnEntry:(BOOL)bEnable;

/**
 * @brief Gets the waiting room user ID list.
 * @return Waiting room user list.
 */
- (nullable NSArray <NSNumber *> *)waitingRoomList;

/**
 * @brief Gets the user detail information in the waiting room.
 * @param userId The user ID.
 * @return The waiting room user information.
 */
- (nullable MobileRTCMeetingUserInfo*)waitingRoomUserInfoByID:(NSUInteger)userId;

/**
 * @brief Admits the user to go to the meeting from the waiting room.
 * @param userId The user ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning Only meeting host or co-host can run the function.
 */
- (MobileRTCSDKError)admitToMeeting:(NSUInteger)userId;

/**
 * @brief Permits all of the users currently in the waiting room to join the meeting.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)admitAllToMeeting;
/**
 * @brief Puts the user to the waiting room from the meeting.
 * @param userId The user ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning Only meeting host or co-host can run the function.
 */
- (MobileRTCSDKError)putInWaitingRoom:(NSUInteger)userId;

/**
 * @brief Determines if the attendee is enabled to turn on audio when joining the meeting.
 * @return YES if enabled to turn on. Otherwise, NO.
 */
- (BOOL)isAudioEnabledInWaitingRoom;

/**
 * @brief Determines if the attendee is enabled to turn on video when joining the meeting.
 * @return YES if enabled to turn on. Otherwise, NO.
 */
- (BOOL)isVideoEnabledInWaitingRoom;

/**
 * @brief Pre-sets audio mute or unmute status in the waiting room.
 * @param muteAudio YES to pre-set audio mute. Otherwise, NO to pre-set unmute.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning Only works in waiting room.
 */
- (MobileRTCSDKError)presetAudioInWaitingRoom:(BOOL)muteAudio;

/**
 * @brief Gets the audio pre-set mute or unmute status in the waiting room.
 * @return YES if pre-set unmute. Otherwise, NO if pre-set mute.
 * @warning Only works in waiting room.
 */
- (BOOL)isPresetAudioUnmuteInWaitingRoom;

/**
 * @brief Pre-sets video mute or unmute status in the waiting room.
 * @param muteVideo YES to pre-set video mute. Otherwise, NO to pre-set unmute.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning Only works in waiting room.
 */
- (MobileRTCSDKError)presetVideoInWaitingRoom:(BOOL)muteVideo;

/**
 * @brief Gets the video pre-set mute or unmute status in the waiting room.
 * @return YES if pre-set unmute. Otherwise, NO if pre-set mute.
 * @warning Only works in waiting room.
 */
- (BOOL)isPresetVideoUnmuteInWaitingRoom;

/**
 * @brief Gets the WaitingRoom CustomizeData information in the waiting room.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)requestCustomWaitingRoomData;

/**
 * @brief Determines if host or co-host is enabled to rename user in the waiting room.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)canRenameUser;

/**
 * @brief Changes the user's screen name in the waiting room.
 * @param userID The user ID who is put into waiting room by host or co-host.
 * @param userName The new user name.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)renameUser:(NSInteger)userID newUserName:(nonnull NSString * )userName;

/**
 * @brief Determines if host or co-host is enabled to expel user in the waiting room.
 * @return YES if can expel user. Otherwise, NO.
 */
- (BOOL)canExpelUser;

/**
 * @brief Removes the specified user from the waiting room.
 * @param userID The user ID who is put into waiting room by host or co-host.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)expelUser:(NSInteger)userID;

@end

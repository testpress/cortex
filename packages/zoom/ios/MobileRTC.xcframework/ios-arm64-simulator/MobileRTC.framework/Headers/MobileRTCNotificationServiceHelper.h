/**
 * @file MobileRTCNotificationServiceHelper.h
 * @brief Helper for handling SDK notifications and alerts.
 */

#import <Foundation/Foundation.h>
#import <MobileRTC/MobileRTCConstants.h>
#import <MobileRTC/MobileRTCInMeetingDeviceInfo.h>
#import <MobileRTC/MobileRTCPresenceHelper.h>

/**
 * @brief Enumeration of meeting transfer modes.
 */
typedef NS_ENUM(NSInteger, MobileRTCTransferMeetingMode) {
    /** For initialization. */
    MobileRTCTransferMeetingMode_None = 0,
    /** Try to transfer meeting to current device. */
    MobileRTCTransferMeetingMode_Transfer,
    /** Try to join meeting with companion mode.If the meeting is successfully joined, both video and audio will be unavailable. */
    MobileRTCTransferMeetingMode_Companoin, 
};


/**
 * @class MobileRTCTransferMeetingHandler
 * @brief Provides information and operation interface for the result of meeting transfer.
 */
@interface MobileRTCTransferMeetingHandler : NSObject

/**
 * @brief Gets the mode of transfer meeting.
 * @return The mode of the transfer meeting.
 */
@property(nonatomic, assign, readonly) MobileRTCTransferMeetingMode mode;
/**
 * @brief Determines if transfer meeting or join meeting in companion mode succeeds.
 * @return YES if transfer meeting or join meeting in companion mode succeeds. Otherwise, NO.
 */
@property(nonatomic, assign, readonly) BOOL isSuccess;
/**
 * @brief Leaves companion mode and rejoins the meeting in normal mode.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error. 
 */
- (MobileRTCSDKError)leaveCompanionToJoinMeeting;

@end

/**
 * @protocol MobileRTCNotificationServiceHelperDelegate
 * @brief MobileRTCNotificationServiceHelperDelegate.
 */
@protocol MobileRTCNotificationServiceHelperDelegate <NSObject>
@optional

/**
 * @brief Callback event that the device for users to attend the meeting has changed.
 * @warning If the user uses -[MobileRTCAuthService registerNotificationService:] interface to connect to the service,they can't get in this callback webinar meeting list.
 * @param deviceList A list of meeting info with active meetings.
 */
- (void)onMeetingDeviceListChanged:(NSArray<MobileRTCInMeetingDeviceInfo*>*_Nullable)deviceList;

/**
 * @brief Transfer meeting status changed callback.
 * @param bSuccess The result of transfer meeting.
 * @deprecated Please use onTransferMeetinghandler instead.
 */
- (void)onTransferMeetingStatus:(BOOL)bSuccess DEPRECATED_MSG_ATTRIBUTE("Please use onTransferMeetinghandler instead");
/**
 * @brief Transfer meeting status changed callback.
 * @param handler The result of transfer meeting.
 */
- (void)onTransferMeetingResult:(MobileRTCTransferMeetingHandler *_Nullable)handler;

@end

/**
 * @class MobileRTCNotificationServiceHelper
 * @brief Helper for managing meeting transfer and presence features.
 */
@interface MobileRTCNotificationServiceHelper : NSObject
/**
 * @brief Sets the delegate of access token service.
 */
@property (assign, nonatomic) id<MobileRTCNotificationServiceHelperDelegate> _Nullable delegate;

/**
 * @brief Determines whether the transfer meeting feature is enabled.
 * @return YES if transfer meeting feature is enabled. Otherwise, NO.
 */
- (BOOL)isTransferMeetingEnabled;

/**
 * @brief Determines whether the presence feature is enabled.
 * @return YES if presence feature is enabled. Otherwise, NO.
 */
- (BOOL)isPresenceFeatureEnabled;
/**
 * @brief Transfers meeting to current device.
 * @param index Specifies the index, see [MobileRTCInMeetingDeviceInfo].
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @deprecated Please use -[MobileRTCNotificationServiceHelper transferMeeting:mode:] instead.
 */
- (MobileRTCSDKError)transferMeeting:(NSInteger)index  DEPRECATED_MSG_ATTRIBUTE("Please use -[MobileRTCNotificationServiceHelper transferMeeting:mode:] instead");

/**
 * @brief Transfers meeting to current device.
 * @param meetingId Specifies the meeting ID, see [MobileRTCInMeetingDeviceInfo].
 * @param mode The transfer meeting mode.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)transferMeeting:(NSString * _Nullable)meetingId mode:(MobileRTCTransferMeetingMode)mode;

/**
 * @brief Gets the presence interface helper.
 * @return If the function succeeds, it returns a MobileRTCPresenceHelper object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCPresenceHelper *_Nullable)getPresenceHelper;

@end


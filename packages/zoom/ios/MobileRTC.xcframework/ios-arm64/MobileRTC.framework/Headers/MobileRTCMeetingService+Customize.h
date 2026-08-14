/**
 * @
 * @brief Meeting+Customize service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>
#import <MobileRTC/MobileRTCRoomDevice.h>
#import <MobileRTC/MobileRTCCallCountryCode.h>

/**
 * @brief Provide interfaces for outgoing calls and Call Room Device.
 */
@interface MobileRTCMeetingService (Customize)
/**
 * @brief Sets to customize the meeting title which will be displayed in the meeting bar.
 * @param title The topic or title of the meeting.
 * @warning User should call the method before starting or joining the meeting if he wants to reset the title or topic of the meeting.
 */
- (void)customizeMeetingTitle:(NSString * _Nullable)title;

/**
 * @brief Determines if host or co-host can change the meeting topic.
 * @return YES if it can change the meeting topic. Otherwise, NO.
 */
- (BOOL)canSetMeetingTopic;

/**
 * @brief Sets to customize the meeting topic which will be displayed in the meeting info view.
 * @param meetingTopic The topic of the meeting.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning Only meeting original host can call the function.
 * @warning Only in-meeting can call the function.
 */
- (MobileRTCSDKError)setMeetingTopics:(NSString *_Nonnull)meetingTopic;
/**
 * @brief Sets to customize the meeting topic which will be displayed in the meeting info view.
 * @param meetingTopic The topic of the meeting.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting original host can call the function.
 * @warning Only in-meeting can call the function.
 * @deprecated Use \link setMeetingTopics: \endlink instead.
 */
- (BOOL)setMeetingTopic:(NSString *_Nonnull)meetingTopic DEPRECATED_MSG_ATTRIBUTE("Use setMeetingTopics  instead");

/**
 * @brief Queries if it is able to call Room device (H.323).
 * @return YES if able. Otherwise, NO.
 */
- (BOOL)isCallRoomDeviceSupported;

/**
 * @brief Queries if it is in process to call room device.
 * @return YES if calling room device is in process. Otherwise, NO.
 */
- (BOOL)isCallingRoomDevice;

/**
 * @brief Cancels calling room device.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)cancelCallRoomDevice;

/**
 * @brief Gets an array of IP addresses of room device which is used for calling.
 * @return The array of IP Address; if there is no existed IP Address, it will return nil.
 */
- (nullable NSArray <NSString *> *)getIPAddressList;

/**
 * @brief Gets the password of the meeting running on H.323 device.
 * @return The meeting password.
 */
- (nullable NSString*)getH323MeetingPassword;

/**
 * @brief Gets room devices that can be called.
 * @return If the function succeeds, it returns an NSArray of MobileRTCRoomDevice objects. Otherwise, this function fails and returns nil.
 */
- (nullable NSArray <MobileRTCRoomDevice *> *)getRoomDeviceList;

/**
 * @brief Gets the pairing code when the room device calls in.
 * @param code The pairing code which enables the device to connect to the meeting.
 * @param meetingNumber The meeting number.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning App can invite Room System while App is in Meeting or in pre-Meeting.
 */
- (BOOL)sendPairingCode:(nonnull NSString*)code WithMeetingNumber:(unsigned long long)meetingNumber;

/**
 * @brief The user calls out to invite the room device.
 * @param device The room device.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)callRoomDevice:(nonnull MobileRTCRoomDevice*)device;

/**
 * @brief Gets the participant ID.
 * @return The participant ID.
 */
- (NSUInteger)getParticipantID;

/**
 * @brief Allows the developer to customize the URL of creating or editing the polling.
 * @param pollingURL The customized URL.
 * @param bCreate YES to change the URL of creating a polling. Otherwise, NO to change the URL of editing a polling.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)setCustomizedPollingUrl:(nullable NSString *)pollingURL bCreate:(BOOL)bCreate;

@end

/**
 * @file MobileRTCMeetingService.h
 * @brief Core meeting service providing meeting management, control, and configuration functionality.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileRTC/MobileRTCConstants.h>
#import <MobileRTC/MobileRTCMeetingDelegate.h>

/**
 * @class MobileRTCMeetingStartParam
 * @brief Provides settings for starting a meeting, such as enabling screen sharing, microphone, and camera.
 */
@interface MobileRTCMeetingStartParam : NSObject
/**
 * @brief YES to start meeting with screen sharing immediately enabled. Otherwise, NO.
 */
@property (nonatomic, assign, readwrite) BOOL  isAppShare;

/**
 * @brief YES to start meeting with microphone disabled. Otherwise, NO.
 */
@property (nonatomic, assign, readwrite) BOOL  noAudio;

/**
 * @brief YES to start meeting with camera disabled. Otherwise, NO.
 */
@property (nonatomic, assign, readwrite) BOOL  noVideo;

/**
 * @brief Developer-specified string to track end user.
 * @note Provided in webhook event, not used internally by SDK.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * customerKey;

/**
 * @brief Special ID for the personal link name in organization URL, like "yourcompany" in yourcompany.zoom.us.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * vanityID;

/**
 * @brief Meeting number, in format like 123456789.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * meetingNumber;

/**
 * @brief <Optional> Is my voice in the mixed audio raw data?
 */
@property (nonatomic, assign, readwrite) BOOL isMyVoiceInMix;

/**
 * @brief The invitation ID for automatic meeting invitation.
 */
@property(nullable, nonatomic, copy) NSString *inviteContactID;

/**
 * @brief <Optional> Is audio raw data stereo? The default is mono.
 */
@property (nonatomic, assign, readwrite) BOOL isAudioRawDataStereo;

/**
 * @brief <Optional>  The sampling rate of the acquired raw audio data, The default is MobileRTCAudioRawdataSamplingRate_32K.
 */
@property (nonatomic, assign, readwrite) MobileRTCAudioRawdataSamplingRate audioRawSampleRate;

/**
 * @brief <Optional>  The colorspace of video rawdata. The default is VideoRawdataColorspace_BT601_L.
 */
@property (nonatomic, assign, readwrite) MobileRTCVideoRawdataColorspace videoRawdataColorspace;


@end

/**
 * @class MobileRTCMeetingStartParam4LoginlUser
 * @brief Provides settings for a logged-in user to start a meeting.
 */
@interface MobileRTCMeetingStartParam4LoginlUser : MobileRTCMeetingStartParam
@end

/**
 * @class MobileRTCMeetingStartParam4WithoutLoginUser
 * @brief Provides parameters for a non-logged-in user (an anonymous user) to start a meeting.
 * @warning The ZAK cannot be null.
 */
@interface MobileRTCMeetingStartParam4WithoutLoginUser : MobileRTCMeetingStartParam
/**
 * @brief User type.
 */
@property (nonatomic, assign, readwrite) MobileRTCUserType userType;

/**
 * @brief The user's display name in the meeting.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * userName;

/**
 * @brief The user's Zoom Access Key (ZAK) token.
 * @warning The ZAK cannot be null.
 */
@property (nonnull, nonatomic, copy, readwrite) NSString * zak;

@end

/**
 * @class MobileRTCMeetingJoinParam
 * @brief Provides settings for joining a meeting, such as start meeting with microphone or camera disabled.
 */
@interface MobileRTCMeetingJoinParam : NSObject
/**
 * @brief YES to start meeting with microphone disabled. Otherwise, NO.
 */
@property (nonatomic, assign, readwrite) BOOL  noAudio;

/**
 * @brief YES to start meeting with camera disabled. Otherwise, NO.
 */
@property (nonatomic, assign, readwrite) BOOL  noVideo;

/**
 * @brief Developer-specified string to track end user.
 * @note Provided in webhook event, not used internally by SDK.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * customerKey;
/**
 * @brief Special ID for the personal link name in the organization URL, like "yourcompany" in yourcompany.zoom.us.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * vanityID;
/**
 * @brief Meeting number, in format like 123456789.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * meetingNumber;
/**
 * @brief User name.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * userName;
/**
 * @brief Password.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * password;
/**
 * @brief WebinarToken.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * webinarToken;

/**
 * @brief The user's Zoom Access Key (ZAK) token.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * zak;

/**
 * @brief On behalf token.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * onBehalfToken;

/**
 * @brief Token that provides privileges when a user joins a meeting, for example, local recording permissions, streaming to raw, or archiving to raw.
 */
@property(nullable, nonatomic, copy, readwrite) NSString *appPrivilegeToken;

/**
 * @brief Token to join a meeting.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * join_token;

/**
 * @brief <Optional> Is my voice in the mixed audio raw data?
 */
@property (nonatomic, assign, readwrite) BOOL isMyVoiceInMix;

/**
 * @brief <Optional> Is audio raw data stereo? The default is mono.
 */
@property (nonatomic, assign, readwrite) BOOL isAudioRawDataStereo;

/**
 * @brief <Optional>  The sampling rate of the acquired raw audio data, The default is MobileRTCAudioRawdataSamplingRate_32K.
 */
@property (nonatomic, assign, readwrite) MobileRTCAudioRawdataSamplingRate audioRawSampleRate;

/**
 * @brief <Optional>  The colorspace of video rawdata. The default is VideoRawdataColorspace_BT601_L.
 */
@property (nonatomic, assign, readwrite) MobileRTCVideoRawdataColorspace videoRawdataColorspace;

@end

/**
 * @class MobileRTCWebinarRegistLegalNoticeContent
 * @brief Interface that provides settings for legal notice content for Webinar registration.
 */
@interface MobileRTCWebinarRegistLegalNoticeContent : NSObject
/**
 * @brief Formatted HTML content string.
 * @note Formatting parameters in order are account owner URL, terms URL, and privacy policy URL.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * formattedHtmlContent;

/**
 * @brief Account owner URL in formatted HTML content.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * accountOwnerUrl;

/**
 * @brief Terms URL in formatted HTML content.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * termsUrl;

/**
 * @brief Privacy policy URL in formatted HTML content.
 */
@property (nullable, nonatomic, copy, readwrite) NSString * privacyPolicyUrl;

@end

/**
 * @class MobileRTCMeetingParameter
 * @brief Provides settings for meetings.
 */
@interface MobileRTCMeetingParameter : NSObject
/**
 * @brief Meeting type.
 */
@property (nonatomic, assign) MobileRTCMeetingType meetingType;

/**
 * @brief View only or not. YES indicates to view only.
 */
@property (nonatomic, assign) BOOL isViewOnly;

/**
 * @brief Auto local recording enabled or not. YES indicates to enable auto local recording.
 */
@property (nonatomic, assign) BOOL isAutoRecordingLocal;

/**
 * @brief Auto cloud recording enabled or not. YES indicates to enable auto cloud recording.
 */
@property (nonatomic, assign) BOOL isAutoRecordingCloud;

/**
 * @brief Meeting number.
 */
@property (nonatomic, assign) unsigned long long meetingNumber;

/**
 * @brief Meeting topic.
 */
@property (nonatomic, copy) NSString * _Nullable meetingTopic;

/**
 * @brief Meeting host.
 */
@property (nonatomic, copy) NSString * _Nullable meetingHost;

@end


/**
 * @class MobileRTCInputUserInfoHandler
 * @brief Interface for handling user input when joining a meeting.
 */
@interface MobileRTCInputUserInfoHandler : NSObject

/**
 * @brief Gets the default display name.
 */
@property(nonatomic, copy, readonly) NSString * _Nullable defaultDisplayName;

/**
 * @brief Checks whether the user can modify the default display name.
 */
@property(nonatomic, assign, readonly) BOOL canModifyDefaultDisplayName;

/**
 * @brief Checks whether the input email is a valid email format.
 * @param email The email must meet the email format requirements. The email input by the logged-in user must be the email.
 * @return YES if the email input is valid. Otherwise, NO.
 */
- (BOOL)isValidEmail:(NSString *_Nonnull)email;

/**
 * @brief Inputs user info.
 * @param name The display name to input.
 * @param email The email to input.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)inputUserInfo:(NSString *_Nonnull)name email:(NSString *_Nonnull)email;

/**
 * @brief Cancels joining the meeting.
 */
- (void)cancel;

@end

@protocol MobileRTCMeetingServiceDelegate;
/**
 * @class MobileRTCMeetingService
 * @brief Enables the client to start or join a meeting.
 * @warning The meeting service allows only one concurrent operation at a time. Only one API call is in progress at any given time.
 */
@interface MobileRTCMeetingService : NSObject
/**
 * @brief Callback to receive meeting events.
 */
@property (weak, nonatomic) id<MobileRTCMeetingServiceDelegate> _Nullable delegate;

/**
 * @brief Callback for custom UI meeting events. Custom UI features enable you to customize the user interface instead of using the default client view.
 */
@property (weak, nonatomic) id<MobileRTCCustomizedUIMeetingDelegate> _Nullable customizedUImeetingDelegate;

/**
 * @brief Starts a meeting with MobileRTCMeetingStartParam parameter.
 * @param param Create an instance with settings via MobileRTCMeetingStartParam.
 * @return The state of the meeting: started or failed.
 * @note For a non-logged-in user, create an instance via MobileRTCMeetingStartParam4WithoutLoginUser to pass the parameters. For a logged-in user, create an instance via MobileRTCMeetingStartParam4LoginlUser to pass the parameters.
 * @warning A meeting started with wrong parameters will return MobileRTCMeetError_InvalidArguments.
 */
- (MobileRTCMeetError)startMeetingWithStartParam:(nonnull MobileRTCMeetingStartParam*)param;

/**
 * @brief Joins a meeting with MobileRTCMeetingJoinParam parameter.
 * @param param Create an instance with settings via MobileRTCMeetingJoinParam.
 * @return The state of the meeting: started or failed.
 * @note If the app is in CallKit mode, set parameter:userName to empty. CallKit lets you integrate your calling services with other call-related apps on the system.
 */
- (MobileRTCMeetError)joinMeetingWithJoinParam:(nonnull MobileRTCMeetingJoinParam*)param;

/**
 * @brief Starts or joins a Zoom meeting with zoom web URL.
 * @param meetingUrl The Zoom web meeting URL.
 * @return The state of the meeting: started or failed.
 */
- (MobileRTCMeetError)handZoomWebUrl:(nonnull NSString*)meetingUrl;

/**
 * @brief Gets the current meeting state.
 * @return The current meeting state.
 */
- (MobileRTCMeetingState)getMeetingState;

/**
 * @brief Ends or leaves the current meeting.
 * @param cmd The command for leaving the current meeting. Only a host can end the meeting.
 */
- (void)leaveMeetingWithCmd:(LeaveMeetingCmd)cmd;

/**
 * @brief Returns the view of meeting UI, which enables customers to add their own view in the meeting UI.
 * @return The view of the current meeting.
 * @warning Only valid in non-custom UI (only valid in Zoom meeting UI).
 */
- (UIView * _Nullable)meetingView;

/**
 * @brief Sets the customized invitation domain.
 * @param invitationDomain The customized invitation domain. For example, https://example.com.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning This method can only be called after auth ready and before join or start meeting.
 */
- (BOOL)setCustomizedInvitationDomain:(NSString *_Nonnull)invitationDomain;

/**
 * @brief Determines if production studio mode is supported.
 * @return YES if supported. Otherwise, NO.
 */
- (BOOL)isSupportPSMode;

/**
 * @brief Determines if production studio mode is started.
 * @return YES if production studio mode is started. Otherwise, NO.
 */
- (BOOL)isPSModeStarted;

/**
 * @brief Gets the production studio user's user ID.
 * @return The production studio user's user ID.
 */
- (NSUInteger)getPSUserID;

@end

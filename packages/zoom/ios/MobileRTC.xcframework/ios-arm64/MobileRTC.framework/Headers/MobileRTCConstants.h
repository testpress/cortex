/**
 * @file MobileRTCConstants.h
 * @brief Defines all constants, enumerations, and data types used throughout the Zoom SDK.
 * The AI Companion brand has been retired. AI-powered features are now more deeply integrated throughout Zoom Workplace. Existing APIs and SDKs that reference AI Companion will continue to function as before to ensure backward compatibility.
 */

/**
 * @brief Enumeration of the SDK error.
 */
typedef NS_ENUM(NSUInteger, MobileRTCSDKError) {
    /** Success. */
    MobileRTCSDKError_Success = 0,
    /** This feature is currently invalid. */
    MobileRTCSDKError_NoImpl,
    /** Incorrect usage of the feature. */
    MobileRTCSDKError_WrongUsage,
    /** Wrong parameter. */
    MobileRTCSDKError_InvalidParameter,
    /** Loading module failed. */
    MobileRTCSDKError_ModuleLoadFailed,
    /** No memory is allocated. */
    MobileRTCSDKError_MemoryFailed,
    /** Service is failed. */
    MobileRTCSDKError_ServiceFailed,
    /** SDK is not initialize. */
    MobileRTCSDKError_Uninitialize,
    /** Not authorized before the usage. */
    MobileRTCSDKError_Unauthentication,
    /** There is no recording in process. */
    MobileRTCSDKError_NoRecordingInprocess,
    /** Transcoder module is not found. */
    MobileRTCSDKError_TranscoderNoFound,
    /** The video service is not ready. */
    MobileRTCSDKError_VideoNotReady,
    /** No permission. */
    MobileRTCSDKError_NoPermission,
    /** Unknown error. */
    MobileRTCSDKError_Unknown,
    /** The other instance of the sdk is in process. */
    MobileRTCSDKError_OtherSdkInstanceRunning,
    /** Sdk internal error. */
    MobileRTCSDKError_InternalError,
    /** No audio device found. */
    MobileRTCSDKError_NoAudiodeviceIsFound,
    /** No video device found. */
    MobileRTCSDKError_NoVideoDeviceIsFound,
    /** Api calls too frequently. */
    MobileRTCSDKError_TooFrequentCall,
    /** User can't be assigned with new privilege. */
    MobileRTCSDKError_FailAssignUserPrivilege,
    /** The current meeting doesn't support the feature. */
    MobileRTCSDKError_MeetingDontSupportFeature,
    /** The current user is not the presenter. */
    MobileRTCSDKError_MeetingNotShareSender,
    /** There is no sharing. */
    MobileRTCSDKError_MeetingYouHaveNoShare,
    /** Incorrect viewtype parameters. */
    MobileRTCSDKError_MeetingViewtypeParameterIsWrong,
    /** Annotation is disabled. */
    MobileRTCSDKError_MeetingAnnotationIsOff,
    /** Current os doesn't support the setting. */
    MobileRTCSDKError_SettingOsDontSupport,
    /** Unsupport email login. */
    MobileRTCSDKError_EmailLoginIsDisabled,
    /** The current device doesn't support the feature. */
    MobileRTCSDKError_HardwareNotMeetForVb,
    /** Need user confirm record disclaimer. */
    MobileRTCSDKError_NeedUserConfirmRecordDisclaimer,
    /** No share data. */
    MobileRTCSDKError_NoShareData,
    /** ShareCannotSubscribeMyself. */
    MobileRTCSDKError_ShareCannotSubscribeMyself,
    /** Not in meeting. */
    MobileRTCSDKError_NotInMeeting,
    /** Meeting call out fail. */
    MobileRTCSDKError_MeetingCallOutFailed,
    /** Not support multi stream video user. */
    MobileRTCSDKError_NotSupportMultiStreamVideoUser,
    /** The  Remote Control is off in this meeting.*/
    MobileRTCSDKError_MeetingRemoteControlIsOff,
    /** File transfer  error. */
    MobileRTCSDKError_FileTransferError,
    /** Breakout room list is empty; create at least one room before setting BO option. */
    MobileRTCSDKError_Breakout_Room_Not_Created,
};

/**
 * @brief Enumeration of SDK authentication results.
 */
typedef NS_ENUM(NSUInteger, MobileRTCAuthError) {
    /** Authentication is successful. */
    MobileRTCAuthError_Success,
    /** The key or secret to authenticate is empty. */
    MobileRTCAuthError_KeyOrSecretEmpty,
    /** Key or secret is wrong. */
    MobileRTCAuthError_KeyOrSecretWrong,
    /** Client account does not support. */
    MobileRTCAuthError_AccountNotSupport,
    /** Client account does not enable SDK. */
    MobileRTCAuthError_AccountNotEnableSDK,
    /** Unknown error. */
    MobileRTCAuthError_Unknown,
    /** Service is busy. */
    MobileRTCAuthError_ServiceBusy,
    /** Initial status. */
    MobileRTCAuthError_None,
    /** Auth timeout. */
    MobileRTCAuthError_OverTime,
    /** Network issues. */
    MobileRTCAuthError_NetworkIssue,
    /** Client incompatible. */
    MobileRTCAuthError_ClientIncompatible,
    /** The jwt token to authenticate is wrong. */
    MobileRTCAuthError_TokenWrong,
    /** The authentication rate limit is exceeded. */
    MobileRTCAuthError_LimitExceededException,
};

/**
 * @brief Enumeration of the login failure reasons.
 */
typedef NS_ENUM(NSUInteger, MobileRTCLoginFailReason) {
    /** Login is successful. */
    MobileRTCLoginFailReason_Success,
    /** Login failed: email login is disabled for the account. */
    MobileRTCLoginFailReason_EmailLoginDisable,
    /** Login failed: the user does not exist. */
    MobileRTCLoginFailReason_UserNotExist,
    /** Login failed: the password is incorrect. */
    MobileRTCLoginFailReason_WrongPassword,
    /** Login failed: the account is locked. */
    MobileRTCLoginFailReason_AccountLocked,
    /** Login failed: the SDK needs to be updated to the new version. */
    MobileRTCLoginFailReason_SDKNeedUpdate,
    /** Login failed: too many failed login attempts. */
    MobileRTCLoginFailReason_TooManyFailedAttempts,
    /** Login failed: the entered SMS code is incorrect. */
    MobileRTCLoginFailReason_SMSCodeError,
    /** Login failed: the SMS code has expired. */
    MobileRTCLoginFailReason_SMSCodeExpired,
    /** Login failed: the phone number format is invalid. */
    MobileRTCLoginFailReason_PhoneNumberFormatInValid,
    /** Login failed: the login token is invalid or expired. */
    MobileRTCLoginFailReason_LoginTokenInvalid,
    /** Login failed: the user disagreed with the login disclaimer. */
    MobileRTCLoginFailReason_UserDisagreeLoginDisclaimer,
    /** Login failed: multi-factor authentication (MFA) is required. */
    MobileRTCLoginFailReason_MFARequired,
    /** Login failed: requires the user to provide their birthday. */
    MobileRTCLoginFailReason_NeedBirthdayAsk,
    /** Login failed due to other unspecified reasons. */
    MobileRTCLoginFailReason_OtherIssue = 100,
    /** Login failed: Invalid arguements error. */
    MobileRTCLoginFailReason_InvalidArguments,
    /** Login failed: SDK not authorized error. */
    MobileRTCLoginFailReason_SDKNotAuthorized,
    /** Login failed: now is in auto login process. */
    MobileRTCLoginFailReason_InAutoLoginProcess,
    /** Login failed: now is already logged in. */
    MobileRTCLoginFailReason_AlreayLoggedin,
};

/**
 * @brief Enumeration of errors to start/join meeting.
 */
typedef NS_ENUM(NSUInteger, MobileRTCMeetError) {
    /** Start/Join meeting successfully. */
    MobileRTCMeetError_Success                          = 0,
    /** The connection with the backend service has errors. */
    MobileRTCMeetError_ConnectionError                  = 1,
    /** Failed to reconnect the meeting. */
    MobileRTCMeetError_ReconnectError                   = 2,
    /** MMR issue, please check MMR configuration. */
    MobileRTCMeetError_MMRError                         = 3,
    /** The meeting password is incorrect. */
    MobileRTCMeetError_PasswordError                    = 4,
    /** Failed to create video and audio data connection with MMR. */
    MobileRTCMeetError_SessionError                     = 5,
    /** Meeting is over. */
    MobileRTCMeetError_MeetingOver                      = 6,
    /** Meeting is not started. */
    MobileRTCMeetError_MeetingNotStart                  = 7,
    /** The meeting does not exist. */
    MobileRTCMeetError_MeetingNotExist                  = 8,
    /** The amount of attendees reaches the upper limit, For users that can' t join the meeting.they can go to watch live stream with the interface \link MobileRTCMeetingServiceDelegate::onMeetingFullToWatchLiveStream: \endlink ,if the host has started. */
    MobileRTCMeetError_MeetingUserFull                  = 9,
    /** The MobileRTC version is incompatible. */
    MobileRTCMeetError_MeetingClientIncompatible        = 10,
    /** No MMR is valid. */
    MobileRTCMeetError_NoMMR                            = 11,
    /** The meeting is locked by the host. */
    MobileRTCMeetError_MeetingLocked                    = 12,
    /** The meeting is restricted. */
    MobileRTCMeetError_MeetingRestricted                = 13,
    /** The meeting is restricted to join before host. */
    MobileRTCMeetError_MeetingRestrictedJBH             = 14,
    /** Failed to request the web server. */
    MobileRTCMeetError_CannotEmitWebRequest             = 15,
    /** Failed to start meeting with expired token. */
    MobileRTCMeetError_CannotStartTokenExpire           = 16,
    /** The user's video does not work. */
    MobileRTCMeetError_VideoError                       = 17,
    /** The user's audio cannot auto-start. */
    MobileRTCMeetError_AudioAutoStartError              = 18,
    /** The amount of webinar attendees reaches the upper limit. */
    MobileRTCMeetError_RegisterWebinarFull              = 19,
    /** User needs to register a webinar account if he wants to start a webinar. */
    MobileRTCMeetError_RegisterWebinarHostRegister      = 20,
    /** User needs to register an account if he wants to join the webinar by the link. */
    MobileRTCMeetError_RegisterWebinarPanelistRegister  = 21,
    /** The host has denied your webinar registration. */
    MobileRTCMeetError_RegisterWebinarDeniedEmail       = 22,
    /** Sign in with the specified account to join webinar. */
    MobileRTCMeetError_RegisterWebinarEnforceLogin      = 23,
    /** The certificate of ZC has been changed. */
    MobileRTCMeetError_ZCCertificateChanged             = 24,
    /** The vanity URL does not exist. */
    MobileRTCMeetError_VanityNotExist                   = 27,
    /** The email address has already been registered in the current webinar. */
    MobileRTCMeetError_JoinWebinarWithSameEmail         = 28,
    /** Failed to write configure file. */
    MobileRTCMeetError_WriteConfigFile                  = 50,
    /** Meeting is removed by the host. */
    MobileRTCMeetError_RemovedByHost                    = 61,
    /** Forbidden to join meeting. */
    MobileRTCMeetError_HostDisallowOutsideUserJoin      = 62,
    /** To join a meeting hosted by an external Zoom account, your SDK app has to be published on Zoom Marketplace. */
    /** You can refer to Section 6.1 of Zoom's API License Terms of Use. */
    MobileRTCMeetError_UnableToJoinExternalMeeting      = 63,
    /** Join failed because this Meeting SDK key is blocked by the host’s account admin. */
    MobileRTCMeetError_BlockedByAccountAdmin            = 64,
    /** Need sign in using the same account as the meeting organizer. */
    MobileRTCMeetError_NeedSignInForPrivateMeeting      = 82,
    /** The join meeting param vanityID is duplicated, and needs to be confirmed. */
    MobileRTCMeetError_FailNeedConfirmPlink      = 88,
    /** The join meeting param vanityID does not exist in the current account. */
    MobileRTCMeetError_FailNeedInputPlink      = 89,
    /** Invalid arguments. */
    MobileRTCMeetError_InvalidArguments                 = MobileRTCMeetError_WriteConfigFile + 100,
    /** Invalid user Type. */
    MobileRTCMeetError_InvalidUserType,
    /** The user joins already another ongoing meeting. */
    MobileRTCMeetError_InAnotherMeeting,
    /** The request too frequence. */
    MobileRTCMeetError_TooFrequenceCall,
    /** Wrong usage of the api. */
    MobileRTCMeetError_WrongUsage,
    /** Failed of the api call. */
    MobileRTCMeetError_Failed,
    /** The virtual background error base. */
    MobileRTCMeetError_VBBase                           = 200,
    /** Set image for virtual background error = MobileRTCMeetError_VBBase. */
    MobileRTCMeetError_VBSetError                       = MobileRTCMeetError_VBBase,
    /** Virtual background image reach to max capacity. */
    MobileRTCMeetError_VBMaximumNum,
    /** Virtual background save the image error. */
    MobileRTCMeetError_VBSaveImage,
    /** Virtual background save the image error. */
    MobileRTCMeetError_VBRemoveNone,
    /** Virtual background not support. */
    MobileRTCMeetError_VBNoSupport,
    /** Virtual background GreenScreen not support, only iPad support green screen. */
    MobileRTCMeetError_VBGreenScreenNoSupport,
    /** App privilege token error. */
    MobileRTCMeetError_AppPrivilegeTokenError          = 500,
    /** Authorized user not in meeting. */
    MobileRTCMeetError_AuthorizedUserNotInMeeting      = 501,
    /** On-behalf token error: conflict with login credentials. */
    MobileRTCMeetError_OnBehalfTokenConflictLoginError = 502,
    /** User level privilege token not have host zak/obf. */
    MobileRTCMeetError_UserLevelTokenNotHaveHostZakObf = 503,
    /** App can not anonymous join meeting. */
    MobileRTCMeetError_AppCanNotAnonymousJoinMeeting   = 504,
    /** On-behalf token invalid. */
    MobileRTCMeetError_OnBehalfTokenInvalid                = 505,
    /** On-behalf token meeting number not match. */
    MobileRTCMeetError_OnBehalfTokenNotMatchMeeting         = 506,
    /** Unknown error. */
    MobileRTCMeetError_Unknown = 0xffff,
};

/**
 * @brief Enumeration of the meeting status.
 */
typedef NS_ENUM(NSUInteger, MobileRTCMeetingState) {
    /** No meeting is running. */
    MobileRTCMeetingState_Idle,
    /** Connect to the meeting server status. */
    MobileRTCMeetingState_Connecting,
    /** Waiting for the host to start the meeting. */
    MobileRTCMeetingState_WaitingForHost,
    /** Meeting is ready, in meeting status. */
    MobileRTCMeetingState_InMeeting,
    /** Disconnect the meeting server, leave meeting status. */
    MobileRTCMeetingState_Disconnecting,
    /** Reconnecting meeting server status. */
    MobileRTCMeetingState_Reconnecting,
    /** Join/Start meeting failed. */
    MobileRTCMeetingState_Failed,
    /** Meeting ends. */
    MobileRTCMeetingState_Ended,
    /** Meeting is locked to prevent the further participants to join the meeting. */
    MobileRTCMeetingState_Locked,
    /** Meeting is open and participants can join the meeting. */
    MobileRTCMeetingState_Unlocked,
    /** Participants who join the meeting before the start are in the waiting room. */
    MobileRTCMeetingState_InWaitingRoom,
    /** Promote the attendees to panelist in webinar. */
    MobileRTCMeetingState_WebinarPromote,
    /** Demote the attendees from the panelist. */
    MobileRTCMeetingState_WebinarDePromote,
    /** Join the breakout room. */
    MobileRTCMeetingState_JoinBO,
    /** Leave the breakout room. */
    MobileRTCMeetingState_LeaveBO,
};

/**
 * @brief Enumeration of the sampling rate of acquired raw audio data.
 */
typedef NS_ENUM(NSUInteger, MobileRTCAudioRawdataSamplingRate) {
    /** The sampling rate of the acquired raw audio data is 32K. */
    MobileRTCAudioRawdataSamplingRate_32K,
    /** The sampling rate of the acquired raw audio data is 48K. */
    MobileRTCAudioRawdataSamplingRate_48K,
};


/**
 * @brief Enumeration of the colorspace of acquired raw video data.
 */
typedef NS_ENUM(NSUInteger, MobileRTCVideoRawdataColorspace) {
    /** For standard definition TV (SDTV)  Y[16,235], Cb/Cr[16,240]. */
    MobileRTCVideoRawdataColorspace_BT601_L,
    /** For standard definition TV (SDTV) full range version: [0,255]. */
    MobileRTCVideoRawdataColorspace_BT601_F,
    /** For high definition TV (HDTV) Y[16,235], Cb/Cr[16,240] */
    MobileRTCVideoRawdataColorspace_BT709_L,
    /** For high definition TV (HDTV) full range version: [0,255] */
    MobileRTCVideoRawdataColorspace_BT709_F
};

/**
 * @brief Enumeration of user types.
 */
typedef NS_ENUM(NSUInteger, MobileRTCUserType) {
    /** User logs in with Facebook account. */
    MobileRTCUserType_Facebook    = 0,
    /** User logs in with Google authentication. */
    MobileRTCUserType_GoogleOAuth = 2,
    /** API user. */
    MobileRTCUserType_APIUser     = 99,
    /** User logs in with working email. */
    MobileRTCUserType_ZoomUser    = 100,
    /** User logs in with SSO token. */
    MobileRTCUserType_SSOUser     = 101,
    /** Unknown user type. */
    MobileRTCUserType_Unknown     = 102,
};

/**
 * @brief Enumeration of the commands for leaving meeting.
 */
typedef NS_ENUM(NSUInteger, LeaveMeetingCmd) {
    /** Command of leaving meeting. */
    LeaveMeetingCmd_Leave,
    /** Command of ending Meeting. */
    LeaveMeetingCmd_End,
};

/**
 * @brief Enumeration of the waiting UI when JBH is disabled.
 */
typedef NS_ENUM(NSUInteger, JBHCmd) {
    /** Show JBH waiting command. */
    JBHCmd_Show,
    /** Hide JBH waiting command. */
    JBHCmd_Hide,
};

/**
 * @brief Enumeration of the phone call status.
 */
typedef NS_ENUM(NSUInteger, DialOutStatus) {
    /** Unknown outgoing call status. */
    DialOutStatus_Unknown  = 0,
    /** In process of calling out. */
    DialOutStatus_Calling,
    /** In process of ringing. */
    DialOutStatus_Ringing,
    /** The call is accepted. */
    DialOutStatus_Accepted,
    /** The telephone service is busy. */
    DialOutStatus_Busy,
    /** The telephone is out of service. */
    DialOutStatus_NotAvailable,
    /** The phone is hung up. */
    DialOutStatus_UserHangUp,
    /** Other reasons. */
    DialOutStatus_OtherFail,
    /** Call successful. */
    DialOutStatus_JoinSuccess,
    /** Outgoing call timeout. */
    DialOutStatus_TimeOut,
    /** Start to cancel outgoing call. */
    DialOutStatus_ZoomStartCancelCall,
    /** Cancel successfully. */
    DialOutStatus_ZoomCallCanceled,
    /** Failed to cancel. */
    DialOutStatus_ZoomCancelCallFail,
    /** The call is not answered. */
    DialOutStatus_NoAnswer,
    /** Disable the international call-out function before the host joins the meeting. */
    DialOutStatus_BlockNoHost,
    /** The call-out is blocked by the system due to high cost. */
    DialOutStatus_BlockHighRate,
    /** All the users invited by the call should press one (1) to join the meeting. If many invitees do not press the button and instead are timed out, the call invitation for this meeting is blocked. */
    DialOutStatus_BlockTooFrequent,
};

/**
 * @brief Enumeration of the H.323/SIP outgoing call status.
 */
typedef NS_ENUM(NSUInteger, H323CallOutStatus) {
    /** Call successful. */
    H323CallOutStatus_Success        = 0,
    /** In process of ringing. */
    H323CallOutStatus_Ring,
    /** Timeout. */
    H323CallOutStatus_Timeout,
    /** Busy. */
    H323CallOutStatus_Busy,
    /** Decline. */
    H323CallOutStatus_Decline,
    /** Failed. */
    H323CallOutStatus_Failed,
};

/**
 * @brief Enumeration of the H.323/SIP pairing status.
 */
typedef NS_ENUM(NSUInteger, MobileRTCH323ParingStatus) {
    /** Success. */
    MobileRTCH323ParingStatus_Success = 0,
    /** Meeting does not Exist. */
    MobileRTCH323ParingStatus_MeetingNotExisted,
    /** No permission. */
    MobileRTCH323ParingStatus_PermissionDenied,
    /** Paring Code is not existed. */
    MobileRTCH323ParingStatus_ParingcodeNotExisted,
    /** Error. */
    MobileRTCH323ParingStatus_Error,
};

/**
 * @brief Enumeration of meeting components.
 */
typedef NS_ENUM(NSUInteger, MobileRTCComponentType) {
    /** Default component type. */
    MobileRTCComponentType_Def    = 0,
    /** Chat.  DEPRECATED_MSG_ATTRIBUTE(deprecated("No longer used").*/
    MobileRTCComponentType_Chat DEPRECATED_ATTRIBUTE,
    /** File Transfer.  DEPRECATED_MSG_ATTRIBUTE(deprecated("No longer used").*/
    MobileRTCComponentType_FT DEPRECATED_ATTRIBUTE,
    /** Audio. */
    MobileRTCComponentType_AUDIO,
    /** Video. */
    MobileRTCComponentType_VIDEO,
    /** Share application. */
    MobileRTCComponentType_SHARE,
};

/**
 * @brief Enumeration of the video quality.
 */
typedef NS_ENUM(NSInteger, MobileRTCVideoQuality) {
    /** Unknown video quality status. */
    MobileRTCVideoQuality_Unknown       = 0,
    /** The video quality is poor. */
    MobileRTCVideoQuality_Bad           = 1,
    /** The video quality is normal. */
    MobileRTCVideoQuality_Normal        = 2,
    /** The video quality is good. */
    MobileRTCVideoQuality_Good          = 3,
};

/**
 * @brief Enumeration of the connection quality.
 */
typedef NS_ENUM(NSInteger, MobileRTCNetworkQuality) {
    /** Unknown connection status. */
    MobileRTCNetworkQuality_Unknown     = -1,
    /** The connection quality is very poor. */
    MobileRTCNetworkQuality_VeryBad     = 0,
    /** The connection quality is poor. */
    MobileRTCNetworkQuality_Bad         = 1,
    /** The connection quality is not good. */
    MobileRTCNetworkQuality_NotGood     = 2,
    /** The connection quality is normal. */
    MobileRTCNetworkQuality_Normal      = 3,
    /** The connection quality is good. */
    MobileRTCNetworkQuality_Good        = 4,
    /** The connection quality is excellent. */
    MobileRTCNetworkQuality_Excellent   = 5,
};

/**
 * @brief Enumeration of audio-related operational error states.
 */
typedef NS_ENUM(NSUInteger, MobileRTCAudioError) {
    /** Success. */
    MobileRTCAudioError_Success                                   = 0,
    /** The application for Audio Session Recording is Denied. */
    MobileRTCAudioError_AudioPermissionDenied                     = 1,
    /** Do not connect to audio session. */
    MobileRTCAudioError_AudioNotConnected                         = 2,
    /** User can not unmute his Audio. */
    MobileRTCAudioError_CannotUnmuteMyAudio                       = 3,
    /** Failed. */
    MobileRTCAudioError_Failed                                    = 4
};

/**
 * @brief Enumeration of the audio status.
 */
typedef NS_ENUM(NSUInteger, MobileRTC_AudioStatus) {
    /** For initialization. */
    MobileRTC_AudioStatus_None                                   = 0,
    /** The audio is muted. */
    MobileRTC_AudioStatus_Audio_Muted                            = 1,
    /** The audio is unmuted. */
    MobileRTC_AudioStatus_Audio_UnMuted                          = 2,
    /** The audio is muted by the host. */
    MobileRTC_AudioStatus_Audio_Muted_ByHost                     = 3,
    /** The audio is unmuted by the host. */
    MobileRTC_AudioStatus_Audio_UnMuted_ByHost                   = 4,
    /** Host mutes all participants. */
    MobileRTC_AudioStatus_Audio_MutedAll_ByHost                  = 5,
    /** Host unmutes all participants. */
    MobileRTC_AudioStatus_Audio_UnMutedAll_ByHost                = 6,
};

/**
 * @brief Enumeration of the status of a user's video.
 */
typedef NS_ENUM(NSUInteger, MobileRTC_VideoStatus) {
    /** Video is turned on. */
    MobileRTC_VideoStatus_Video_ON                            = 0,
    /** Video is turned off. */
    MobileRTC_VideoStatus_Video_OFF                           = 1,
    /** Video is muted by the host. */
    MobileRTC_VideoStatus_Video_Muted_ByHost                  = 2,
};

/**
 * @brief Enumeration of camera-related operational error states.
 */
typedef NS_ENUM(NSUInteger, MobileRTCCameraError) {
    /** Success. */
    MobileRTCCameraError_Success                                   = 0,
    /** The permission to enable the camera is denied. */
    MobileRTCCameraError_CameraPermissionDenied                    = 1,
    /** The camera can not connect to video session. */
    MobileRTCCameraError_VideoNotSending                           = 2,
};

/**
 * @brief Enumeration of the live stream status.
 */
typedef NS_ENUM(NSUInteger, MobileRTCLiveStreamStatus) {
    /** Start live stream successfully. */
    MobileRTCLiveStreamStatus_StartSuccessed               = 0,
    /** Start live stream failed. */
    MobileRTCLiveStreamStatus_StartFailedOrEnded           = 1,
    /** Start live stream timeout. */
    MobileRTCLiveStreamStatus_StartTimeout                 = 2,
    /** Stop live stream. */
    MobileRTCLiveStreamStatus_Stop                         = 3,
    /** Be connecting. */
    MobileRTCLiveStreamStatus_Connecting                   = 4,
};

/**
 * @brief Enumeration of the CLAIM HOST results in meeting.
 */
typedef NS_ENUM(NSUInteger, MobileRTCClaimHostError) {
    /** Claim host successfully. */
    MobileRTCClaimHostError_Successed                = 0,
    /** Host Key Errors. */
    MobileRTCClaimHostError_HostKeyError             = 1,
    /** Network Errors. */
    MobileRTCClaimHostError_NetWorkError             = 2,
};

/**
 * @brief Enumeration of the SENDING CHAT MESSAGE result in meeting.
 */
typedef NS_ENUM(NSUInteger, MobileRTCSendChatError) {
    /** Send chat message successfully. */
    MobileRTCSendChatError_Successed                = 0,
    /** Send chat message failed. */
    MobileRTCSendChatError_Failed                   = 1,
    /** No permission. */
    MobileRTCSendChatError_PermissionDenied         = 2,
};

/**
 * @brief Enumeration of meeting encryption types.
 */
typedef NS_ENUM(NSUInteger, MobileRTCMeetingEncryptionType) {
    /** For initialization. */
    MobileRTCMeetingEncryptionType_None,
    /** Enhanced. */
    MobileRTCMeetingEncryptionType_Enhanced,
    /** E2EE. */
    MobileRTCMeetingEncryptionType_E2EE
};
/**
 * @brief Enumeration of annotation-related operational error states.
 */
typedef NS_ENUM(NSUInteger, MobileRTCAnnotationError) {
    /** Succeeded. */
    MobileRTCAnnotationError_Successed                = 0,
    /** Failed. */
    MobileRTCAnnotationError_Failed                   = 1,
    /** No permission. */
    MobileRTCAnnotationError_PermissionDenied         = 2,
};

/**
 * @brief Enumeration of CMR-related result error states.
 */
typedef NS_ENUM(NSUInteger, MobileRTCCMRError) {
    /** Succeeded. */
    MobileRTCCMRError_Successed                = 0,
    /** Failed. */
    MobileRTCCMRError_Failed                   = 1,
    /** The storage is full. */
    MobileRTCCMRError_StorageFull              = 2,
};

/**
 * @brief Enumeration of the information needed to Join Meeting.
 */
typedef NS_ENUM(NSUInteger, MobileRTCJoinMeetingInfo) {
    /** Display name is needed. */
    MobileRTCJoinMeetingInfo_NeedName                = 0,
    /** Meeting password is needed. */
    MobileRTCJoinMeetingInfo_NeedPassword            = 1,
    /** Meeting password is wrong. */
    MobileRTCJoinMeetingInfo_WrongPassword           = 2,
    /** Screen name and meeting Password are needed. */
    MobileRTCJoinMeetingInfo_NeedNameAndPwd          = 3,
    /** Confirm preview of the meeting. */
    MobileRTCJoinMeetingInfo_ConfirmPreview          = 4,
};

/**
 * @brief Enumeration of the audio errors.
 */
typedef NS_ENUM(NSUInteger, MobileRTCMicrophoneError) {
    /** Microphone is muted while speaking. */
    MobileRTCMicrophoneError_MicMuted                = 0,
    /** Audio feedback is detected when join meeting. */
    MobileRTCMicrophoneError_FeedbackDetected        = 1,
    /** Microphone is unavailable. */
    MobileRTCMicrophoneError_MicUnavailable          = 2,
};

/**
 * @brief Enumeration of the meeting end reasons.
 */
typedef NS_ENUM(NSUInteger, MobileRTCMeetingEndReason) {
    /** User leaves meeting. */
    MobileRTCMeetingEndReason_None                      = 0,
    /** The user is removed from meeting by the host. */
    MobileRTCMeetingEndReason_RemovedByHost             = 1,
    /** Host ends the meeting. */
    MobileRTCMeetingEndReason_EndByHost                 = 2,
    /** Join the meeting before host (JBH) timeout. */
    MobileRTCMeetingEndReason_JBHTimeout                = 3,
    /** Meeting ends when the free service is over. */
    MobileRTCMeetingEndReason_FreeMeetingTimeout        = 4,
    /** Meeting is ended for there is no attendee joins it. */
    MobileRTCMeetingEndReason_NoAteendee                = 5,
    /** Host ends the meeting for he will start another meeting. */
    MobileRTCMeetingEndReason_HostEndForAnotherMeeting  = 6,
    /** Represents an undefined end meeting reason, typically used for new error codes introduced by the backend after client release. */
    MobileRTCMeetingEndReason_Undefined                 = 7,
    /** Authorized user left. */
    MobileRTCMeetingEndReason_DueToAuthorizedUserLeave  = 8,
};

/**
 * @brief Enumeration of remote control-related operational result in meeting.
 */
typedef NS_ENUM(NSUInteger, MobileRTCRemoteControlError) {
    /** Succeeded. */
    MobileRTCRemoteControlError_Successed                = 0,
    /** Stop. */
    MobileRTCRemoteControlError_Stop                     = 1,
    /** Failed. */
    MobileRTCRemoteControlError_Failed                   = 2,
    /** No Permission. */
    MobileRTCRemoteControlError_PermissionDenied         = 3,
};

/**
 * @brief Enumeration of the audio output description.
 */
typedef NS_ENUM(NSUInteger, MobileRTCAudioOutput) {
    /** Unknown. */
    MobileRTCAudioOutput_Unknown         = 0,
    /** Receiver. */
    MobileRTCAudioOutput_Receiver        = 1,
    /** Speaker. */
    MobileRTCAudioOutput_Speaker         = 2,
    /** Headphones. */
    MobileRTCAudioOutput_Headphones     = 3,
    /** Blue-tooth. */
    MobileRTCAudioOutput_Bluetooth      = 4,
};

/**
 * @brief Enumeration of the attendee chat permission in webinar.
 */
typedef NS_ENUM(NSUInteger, MobileRTCChatAllowAttendeeChat) {
    /** Chat is disabled. */
    MobileRTCChatAllowAttendeeChat_ChatWithNone              = 1,
    /** Chat with all. */
    MobileRTCChatAllowAttendeeChat_ChatWithAll               = 2,
    /** Chat with panelist. */
    MobileRTCChatAllowAttendeeChat_ChatWithPanelist          = 3,
};

/**
 * @brief Enumeration of promoting/demoting attendee and panelist errors in webinar.
 */
typedef NS_ENUM(NSUInteger, MobileRTCWebinarPromoteorDepromoteError) {
    /** Promote/demote successfully. */
    MobileRTCWebinarPromoteorDepromoteError_Success                                                  = 0,
    /** The amount of panelist in webinar reaches the upper limit. */
    MobileRTCWebinarPromoteorDepromoteError_Webinar_Panelist_Capacity_Exceed                         = 3035,
    /** The attendees in webinar are not found. */
    MobileRTCWebinarPromoteorDepromoteError_Not_Found_Webinar_Attendee                               = 3029,
};

/**
 * @brief Enumeration of audio types in meeting.
 */
typedef NS_ENUM(NSUInteger, MobileRTCMeetingItemAudioType) {
    /** Unknown. */
    MobileRTCMeetingItemAudioType_Unknown                    = 0,
    /** Telephone Only. */
    MobileRTCMeetingItemAudioType_TelephoneOnly              = 1,
    /** VoIP Only. */
    MobileRTCMeetingItemAudioType_VoipOnly                   = 2,
    /** Telephone And VoIP. */
    MobileRTCMeetingItemAudioType_TelephoneAndVoip           = 3,
    /** The 3rd Party Audio. */
    MobileRTCMeetingItemAudioType_3rdPartyAudio              = 4,
};

/**
 * @brief Enumeration of the meeting recording types in meeting.
 */
typedef NS_ENUM(NSUInteger, MobileRTCMeetingItemRecordType) {
    /** Automatic recording is disabled. */
    MobileRTCMeetingItemRecordType_AutoRecordDisabled               = 0,
    /** Local Recording. */
    MobileRTCMeetingItemRecordType_LocalRecord                      = 1,
    /** Cloud Recording. */
    MobileRTCMeetingItemRecordType_CloudRecord                      = 2,
    /** Unknown. */
    MobileRTCMeetingItemRecordType_Unknown                      = 3,
};

/**
 * @brief Enumeration of the meeting chat types in meeting.
 */
typedef NS_ENUM(NSUInteger, MobileRTCMeetingChatPriviledgeType) {
    /** Unknown type. */
    MobileRTCMeetingChatPriviledge_Unknown = 0,
    /** Allow attendee to chat with everyone. */
    MobileRTCMeetingChatPriviledge_Everyone_Publicly_And_Privately,
    /** Allow attendee to chat with host only. */
    MobileRTCMeetingChatPriviledge_Host_Only,
    /** Allow attendee to chat with no one. */
    MobileRTCMeetingChatPriviledge_No_One,
    /** Allow attendee to chat with host and public. */
    MobileRTCMeetingChatPriviledge_Everyone_Publicly,
};

/**
 * @brief Enumeration of webinar panelist types.
 */
typedef NS_ENUM(NSUInteger, MobileRTCPanelistChatPrivilegeType) {
    /** Default status, can't set this. */
    MobileRTCPanelistChatPrivilege_INVALID = 0,
    /** Can chat to all panelist. */
    MobileRTCPanelistChatPrivilege_PANELIST = 1,
    /** Can chat to all. */
    MobileRTCPanelistChatPrivilege_ALL = 2,
};

/**
 * @brief Enumeration of chat types.
 */
typedef NS_ENUM(NSUInteger, MobileRTCChatMessageType) {
    /** For initialize. */
    MobileRTCChatMessageType_To_None = 0,
    /** Chat message is send to all in normal meeting ,also means to all panelist and attendees when webinar meeting. */
    MobileRTCChatMessageType_To_All,
    /** Chat message is send to all panelists. */
    MobileRTCChatMessageType_To_All_Panelist,
    /** Chat message is send to individual attendee and cc panelists. */
    MobileRTCChatMessageType_To_Individual_Panelist,
    /** Chat message is send to individual user. */
    MobileRTCChatMessageType_To_Individual,
    /** Chat message is send to waiting room user. */
    MobileRTCChatMessageType_To_WaitingRoomUsers,
};

/**
 * @brief Enumeration of the chat message delete type.
 */
typedef NS_ENUM(NSUInteger, MobileRTCChatMessageDeleteType) {
    /** For initialization. */
    MobileRTCChatMessageDeleteType_By_None = 0,
    /** Message is deleted by the sender (self deletion). */
    MobileRTCChatMessageDeleteType_By_Self,
    /** Message is deleted by the meeting host. */
    MobileRTCChatMessageDeleteType_By_Host,
    /** Delete by dlp when the message goes against the host organization's compliance policies. */
    MobileRTCChatMessageDeleteType_By_DLP,
};

/**
 * @brief Enumeration of video types.
 */
typedef NS_ENUM(NSUInteger, MobileRTCVideoType) {
    /** Video Camera Data. */
    MobileRTCVideoType_VideoData  = 1,
    /** Share Data. */
    MobileRTCVideoType_ShareData,
};

/**
 * @brief Enumeration of the video resolution options.
 */
typedef NS_ENUM(NSUInteger, MobileRTCVideoResolution) {
    /** Video resolution 90 */
    MobileRTCVideoResolution_90 = 0,
    /** Video resolution 180 */
    MobileRTCVideoResolution_180,
    /** Video resolution 360 */
    MobileRTCVideoResolution_360,
    /** Video resolution 720 */
    MobileRTCVideoResolution_720,
};

/**
 * @brief Enumeration of the video frame data format.
 */
typedef NS_ENUM(NSUInteger, MobileRTCFrameDataFormat) {
    /** I420 format with limited (TV) range color space. */
    MobileRTCFrameDataFormat_I420            = 1,
    /** I420 format with full (PC) range color space. */
    MobileRTCFrameDataFormat_I420_Limit,
};

/**
 * @brief Enumeration of the directions of video.
 */
typedef NS_ENUM(NSInteger, MobileRTCVideoRawDataRotation) {
    /** Video direction 0 */
    MobileRTCVideoRawDataRotationNone      = 1,
    /** Video direction 90 */
    MobileRTCVideoRawDataRotation90,
    /** Video direction 180 */
    MobileRTCVideoRawDataRotation180,
    /** Video direction 270 */
    MobileRTCVideoRawDataRotation270,
};

/**
 * @brief Enumeration of the raw data.
 */
typedef NS_ENUM(NSUInteger,MobileRTCRawDataError)
{
    /** Success. */
    MobileRTCRawData_Success = 0,
    /** SDK is not initialize. */
    MobileRTCRawData_Uninitialized,
    /** Memory allocation for raw data failed. */
    MobileRTCRawData_Malloc_Failed,
    /** Incorrect usage of the feature. */
    MobileRTCRawData_Wrongusage,
    /** One or more parameters are invalid. */
    MobileRTCRawData_Invalid_Param,
    /** The user is not currently in the meeting. */
    MobileRTCRawData_Not_In_Meeting,
    /** No license. */
    MobileRTCRawData_No_License,
    /** Unknown error. */
    MobileRTCRawData_Unknown,
    /** Video module not ready. */
    MobileRTCRawData_Video_Module_Not_Ready,
    /** Video module error. */
    MobileRTCRawData_Video_Module_Error,
    /** Video device error. */
    MobileRTCRawData_Video_device_error,
    /** No video data available. */
    MobileRTCRawData_No_Video_Data,
    /** Share module not ready. */
    MobileRTCRawData_Share_Module_Not_Ready,
    /** Share module error. */
    MobileRTCRawData_Share_Module_Error,
    /** No shared data available. */
    MobileRTCRawData_No_Share_Data,
    /** Cannot subscribe myself share. */
    MobileRTCRawData_Share_Cannot_Subscribe_Myself,
    /** Audio module not ready. */
    MobileRTCRawData_Audio_Module_Not_Ready,
    /** Audio module error. */
    MobileRTCRawData_Audio_Module_Error,
    /** No audio data available. */
    MobileRTCRawData_No_Audio_Data,
    /** Data sent too frequently. */
    MobileRTCRawData_Send_Too_Frequently,
    /** Virtual device error. */
    MobileRTCRawData_Can_Not_Change_Virtual_Device,
    /** Not join audio. */
    MobileRTCRawData_Not_Join_Audio
};

/**
 * @brief Enumeration of memory modes for raw data handling.
 */
typedef NS_ENUM(NSUInteger, MobileRTCRawDataMemoryMode) {
    /** Use stack memory. */
    MobileRTCRawDataMemoryModeStack = 0,
    /** Use heap memory. */
    MobileRTCRawDataMemoryModeHeap
};

/**
 * @brief Enumeration of locale for customer.
 */
typedef NS_ENUM(NSUInteger, MobileRTC_ZoomLocale) {
    /** Default. */
    MobileRTC_ZoomLocale_Default = 0,
    /** CN. */
    MobileRTC_ZoomLocale_CN
};

/**
 * @brief Enumeration of the SMS verify result.
 */
typedef NS_ENUM(NSUInteger, MobileRTCSMSVerifyResult) {
    /** Success. */
    MobileRTCSMSVerifyResult_Succ = 0,
    /** The entered SMS code is incorrect. */
    MobileRTCSMSVerifyResult_RealNameAuthErrorIdentifyCode,
    /** The SMS code has expired. */
    MobileRTCSMSVerifyResult_RealNameAuthIdentifyCodeExpired,
    /** Bypass. */
    MobileRTCSMSVerifyResult_RealNameAuthBypassVerify,
    /** Unknown error. */
    MobileRTCSMSVerifyResult_RealNameAuthUnknownError,
};
/**
 * @brief Enumeration of the SMS retrieve result.
 */
typedef NS_ENUM(NSUInteger, MobileRTCSMSRetrieveResult) {
    /** Success. */
    MobileRTCSMSRetrieveResult_Succ = 0,
    /** Send SMS failed. */
    MobileRTCSMSRetrieveResult_SendSMSFailed,
    /** Request failed. */
    MobileRTCSMSRetrieveResult_RequestFailed,
    /** Invalid phone number. */
    MobileRTCSMSRetrieveResult_InvalidPhoneNum,
    /** Phone number already bounded. */
    MobileRTCSMSRetrieveResult_PhoneNumAlreadyBound,
    /** Send too frequently. */
    MobileRTCSMSRetrieveResult_PhoneNumSendTooFrequent,
    /** Success. */
    MobileRTCSMSRetrieveResult_BypassVerify,
};

/**
 * @brief Enumeration of the Minimize Meeting states in Zoom UI.
 */
typedef NS_ENUM(NSUInteger, MobileRTCMinimizeMeetingState) {
    /** Show miniimize meeting. */
    MobileRTCMinimizeMeeting_ShowMinimizeMeeting = 0,
    /** Back to full screen meeting. */
    MobileRTCMinimizeMeeting_BackFullScreenMeeting
};

/**
 * @brief Enumeration of reasons why a free meeting needs an upgrade.
 */
typedef NS_ENUM(NSUInteger, FreeMeetingNeedUpgradeType) {
    /** For initialization. */
    FreeMeetingNeedUpgradeType_NONE = 0,
    /** Upgrade required due to admin payment reminder. */
    FreeMeetingNeedUpgradeType_BY_ADMIN,
    /** Upgrade triggered by gift URL. */
    FreeMeetingNeedUpgradeType_BY_GIFTURL,
};

/**
 * @brief Enumeration of the Breakout Room (BO) status.
 */
typedef NS_ENUM(NSUInteger, MobileRTCBOStatus) {
    /** BO status is invalid. */
    MobileRTCBOStatus_Invalid = 0,
    /** Editing and assigning participants to Breakout Rooms. */
    MobileRTCBOStatus_Edit = 1,
    /** Breakout Rooms have started. */
    MobileRTCBOStatus_Started,
    /** Breakout Rooms are currently stopping. */
    MobileRTCBOStatus_Stopping,
    /** Breakout Rooms have ended. */
    MobileRTCBOStatus_Ended
};

/**
 * @brief Enumeration of the attendee request for help results.
 */
typedef NS_ENUM(NSUInteger, MobileRTCBOHelpReply) {
    /** Host receive the help request and there is no other one currently requesting for help. */
    MobileRTCBOHelpReply_Idle = 0,
    /** Host is handling other's request with the request dialog, no chance to show dialog for this request. */
    MobileRTCBOHelpReply_Busy,
    /** Host click "later" button or close the request dialog directly. */
    MobileRTCBOHelpReply_Ignore,
    /** Host already in your BO meeting. */
    MobileRTCBOHelpReply_alreadyInBO
};

/**
 * @brief Enumeration of the errors related to the Breakout Room (BO) controller operations.
 */
typedef NS_ENUM(NSUInteger, MobileRTCBOControllerError) {
    /** The pointer is null. */
    MobileRTCBOControllerError_NULL_POINTER = 0,
    /** Invalid action due to current BO status (e.g., already started or stopped). */
    MobileRTCBOControllerError_WRONG_CURRENT_STATUS,
    /** BO token is not ready yet. */
    MobileRTCBOControllerError_TOKEN_NOT_READY,
    /** Only the host has the privilege to create, start, or stop breakout rooms. */
    MobileRTCBOControllerError_NO_PRIVILEGE,
    /** Breakout room list is currently being uploaded. */
    MobileRTCBOControllerError_BO_LIST_IS_UPLOADING,
    /** Failed to upload the breakout room list to the conference attributes. */
    MobileRTCBOControllerError_UPLOAD_FAIL,
    /** No participants have been assigned to breakout rooms. */
    MobileRTCBOControllerError_NO_ONE_HAS_BEEN_ASSIGNED,
    /** Unknown error. */
    MobileRTCBOControllerError_UNKNOWN = 100
};

/**
 * @brief Enumeration of the pre-assign breakout room data download status.
 */
typedef NS_ENUM(NSUInteger, MobileRTCBOPreAssignBODataStatus) {
    /** Initial status, no request was sent. */
    MobileRTCBOPreAssignBODataStatus_None = 0,
    /** Download in progress. */
    MobileRTCBOPreAssignBODataStatus_Downloading,
    /** Download success. */
    MobileRTCBOPreAssignBODataStatus_Download_Ok,
    /** Download fail. */
    MobileRTCBOPreAssignBODataStatus_Download_Fail
};

/**
 * @brief Enumeration of the direct sharing status.
 */
typedef NS_ENUM(NSUInteger, MobileRTCDirectShareStatus) {
    /** Only for initialization. */
    MobileRTCDirectShareStatus_Unknown = 0,
    /** Waiting for enabling the direct sharing. */
    MobileRTCDirectShareStatus_Connecting,
    /** In direct sharing mode. */
    MobileRTCDirectShareStatus_In_Direct_Share_Mode,
    /** End the direct sharing. */
    MobileRTCDirectShareStatus_Ended,
    /** Re-enter the meeting ID/paring code. */
    MobileRTCDirectShareStatus_Need_MeetingID_Or_PairingCode,
    /** Network error. Please try again later. */
    MobileRTCDirectShareStatus_NetWork_Error,
    /** Other errors. Mainly occur in SIP call mode. */
    MobileRTCDirectShareStatus_Other_Error,
    /** Wrong meeting id or sharing key. */
    MobileRTCDirectShareStatus_WrongMeetingID_Or_SharingKey,
    /** Require input paringCode again for users on a different network. */
    MobileRTCDirectShareStatus_Need_Input_New_ParingCode,
    /** Direct share prepared. */
    MobileRTCDirectShareStatus_DirectShare_Prepared
};

/**
 * @brief Enumeration of the available emoji reaction types. For more information, please visit <https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0060612>.
 */
typedef NS_ENUM(NSUInteger, MobileRTCEmojiReactionType) {
    /** Unknow. */
    MobileRTCEmojiReactionType_Unknown = 0,
    /** Clap emoji reaction. */
    MobileRTCEmojiReactionType_Clap,
    /** Thumbs-up emoji reaction. */
    MobileRTCEmojiReactionType_Thumbsup,
    /** Heart emoji reaction. */
    MobileRTCEmojiReactionType_Heart,
    /** Joy emoji reaction. */
    MobileRTCEmojiReactionType_Joy,
    /** Open-mouth emoji reaction. */
    MobileRTCEmojiReactionType_Openmouth,
    /** Tada emoji reaction. */
    MobileRTCEmojiReactionType_Tada,
};

/**
 * @brief Enumeration of emoji feedback types.
 */
typedef NS_ENUM(NSUInteger, MobileRTCEmojiFeedbackType) {
    /** None. */
    MobileRTCEmojiFeedbackType_None,
    /** Yes. */
    MobileRTCEmojiFeedbackType_Yes,
    /** No. */
    MobileRTCEmojiFeedbackType_No,
    /** Speed Up. */
    MobileRTCEmojiFeedbackType_SpeedUp,
    /** Slow Down. */
    MobileRTCEmojiFeedbackType_SlowDown,
    /** Away. */
    MobileRTCEmojiFeedbackType_Away
};

/**
 * @brief Enumeration of the emoji reactions skin tone.
 */
typedef NS_ENUM(NSUInteger, MobileRTCEmojiReactionSkinTone) {
    /** Unknow. */
    MobileRTCEmojiReactionSkinTone_Unknown = 0,
    /** Default skin tone. */
    MobileRTCEmojiReactionSkinTone_Default,
    /** Light skin tone. */
    MobileRTCEmojiReactionSkinTone_Light,
    /** Medium light skin tone. */
    MobileRTCEmojiReactionSkinTone_MediumLight,
    /** Medium skin tone. */
    MobileRTCEmojiReactionSkinTone_Medium,
    /** Medium dark skin tone. */
    MobileRTCEmojiReactionSkinTone_MediumDark,
    /** Dark skin tone. */
    MobileRTCEmojiReactionSkinTone_Dark,
};

/**
 * @brief Enumeration of meeting types.
 */
typedef NS_ENUM(NSUInteger, MobileRTCMeetingType) {
    /** There is no meeting. */
    MobileRTCMeetingType_None,
    /** Normal meeting. */
    MobileRTCMeetingType_Normal,
    /** Breakout meeting. */
    MobileRTCMeetingType_BreakoutRoom,
    /** Webinar. */
    MobileRTCMeetingType_Webinar,
};

/**
 * @brief Enumeration of user roles.
 */
typedef NS_ENUM(NSUInteger, MobileRTCUserRole) {
    /** For initialization. */
    MobileRTCUserRole_None,
    /** Host. */
    MobileRTCUserRole_Host,
    /** Co-host. */
    MobileRTCUserRole_CoHost,
    /** Attendee in the webinar. */
    MobileRTCUserRole_Attendee,
    /** Panelist. */
    MobileRTCUserRole_Panelist,
    /** Moderator of breakout room. */
    MobileRTCUserRole_BreakoutRoom_Moderator,
};

/**
 * @brief Enumeration of the recording status.
 */
typedef NS_ENUM(NSUInteger, MobileRTCRecordingStatus) {
    /** Recording start. */
    MobileRTCRecording_Start,
    /** Recording stop. */
    MobileRTCRecording_Stop,
    /** Pause recording. */
    MobileRTCRecording_Pause,
    /** Recording connecting. */
    MobileRTCRecording_Connecting,
    /** There is no more space to store cloud recording. */
    MobileRTCRecording_DiskFull,
    /** Saving the recording failed. */
    MobileRTCRecording_Fail,
};

/**
 * @brief Enumeration of the status of the local recording permission request.
 */
typedef NS_ENUM(NSUInteger, MobileRTCRequestStartCloudRecordingStatus)
{
    /** The request for local recording permission was granted. */
    MobileRTCRequestStartCloudRecording_Granted,
    /** The request for local recording permission was denied. */
    MobileRTCRequestStartCloudRecording_Denied,
    /** The request timed out without a response. */
    MobileRTCRequestStartCloudRecording_TimedOut,
};
/**
 * @brief Enumeration of the types of shared content.
 */
typedef NS_ENUM(NSUInteger, MobileRTCShareContentType)
{
    /** Type unknown. */
    MobileRTCShareContentType_UNKNOWN,
    /** Type of sharing the application. */
    MobileRTCShareContentType_AS,
    /** Type of sharing the desktop. */
    MobileRTCShareContentType_DS,
    /** Type of sharing the white-board. */
    MobileRTCShareContentType_WB,
    /** Type of sharing data from the device connected WIFI. */
    MobileRTCShareContentType_AIRHOST,
    /** Type of sharing the camera. */
    MobileRTCShareContentType_CAMERA,
    /** Type of sharing the data. */
    MobileRTCShareContentType_DATA,
    /** Wired device, connect Mac and iPhone. */
    MobileRTCShareContentType_WIRED_DEVICE,
    /** Share a portion of screen in the frame. */
    MobileRTCShareContentType_FRAME,
    /** Share a document. */
    MobileRTCShareContentType_DOCUMENT,
    /** Share only the audio sound of computer. */
    MobileRTCShareContentType_COMPUTER_AUDIO,
    /** Type of sharing video file. */
    MobileRTCShareContentType_VIDEO_FILE
};

/**
 * @brief Enumeration of the sharing status.
 */
typedef NS_ENUM(NSUInteger, MobileRTCSharingStatus)
{
    /** Begin to share by the user himself. */
    MobileRTCSharingStatus_Self_Send_Begin,
    /** Stop sharing by the user. */
    MobileRTCSharingStatus_Self_Send_End,
    /** Others begin to share. */
    MobileRTCSharingStatus_Other_Share_Begin,
    /** Others stop sharing. */
    MobileRTCSharingStatus_Other_Share_End,
    /** View the sharing of others. */
    MobileRTCSharingStatus_View_Other_Sharing,
    /** Pause sharing. */
    MobileRTCSharingStatus_Pause,
    /** Resume sharing. */
    MobileRTCSharingStatus_Resume,
    /** Other user begins to share the sounds of computer audio. */
    MobileRTCSharingStatus_OtherPureAudioShareStart,
    /** Other user stops sharing the sounds of computer audio. */
    MobileRTCSharingStatus_OtherPureAudioShareStop,
};

/**
 * @brief Enumeration of the LockShare Status changed.
 */
typedef NS_ENUM(NSUInteger, MobileRTCShareSettingType)
{
    /** Share settings type none. */
    MobileRTCShareSettingType_None,
    /** Only host can share, the same as "lock share" */
    MobileRTCShareSettingType_LockShare,
    /** Anyone can share, but only one can share at a  moment, and only the host can start sharing when another user is sharing. The previous share will be ended once the host grabs the sharing. For more information, please visit <https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0058730#h_01GCCD82NKKECQ6QJNH6F4CTWA>. */
    MobileRTCShareSettingType_HostGrab,
    /** Anyone can share, but one sharing only at one moment, and anyone can grab other's sharing. */
    MobileRTCShareSettingType_AnyoneGrab,
    /** Anyone can share, Multi-share can exist at the same time. */
    MobileRTCShareSettingType_MultiShare,

};

/**
 * @brief Enumeration of the reasons why sharing is not allowed.
 */
typedef NS_ENUM(NSUInteger, MobileRTCCannotShareReasonType)
{
    /** For initialization. */
    MobileRTCCannotShareReasonType_None,
    /** Only the host is allowed to share. */
    MobileRTCCannotShareReasonType_Locked,
    /** Share is disabled. */
    MobileRTCCannotShareReasonType_Disabled,
    /** Another participant is sharing their screen. */
    MobileRTCCannotShareReasonType_Other_Screen_Sharing,
    /** Another participant is sharing their whiteboard. */
    MobileRTCCannotShareReasonType_Other_WB_Sharing,
    /** The user is sharing their screen, and can grab.To grab,call EnableGrabShareWithoutReminder(true) before starting share. */
    MobileRTCCannotShareReasonType_Need_Grab_Myself_Screen_Sharing,
    /** Another is sharing their screen, and can grab. To grab,call EnableGrabShareWithoutReminder(true) before starting share. */
    MobileRTCCannotShareReasonType_Need_Grab_Other_Screen_Sharing,
    /** Another user is sharing pure computer audio, and can grab. To grab, call EnableGrabShareWithoutReminder(true) before starting share. */
    MobileRTCCannotShareReasonType_Need_Grab_Audio_Sharing,
    /** Other or myself is sharing whiteboard, and can gGrab. To grab, call EnableGrabShareWithoutReminder(true) before starting share. */
    MobileRTCCannotShareReasonType_Need_Grap_WB_Sharing,
    /** The meeting has reached the maximum allowed screen share sessions. */
    MobileRTCCannotShareReasonType_Reach_Maximum,
    /** Other share screen in main session. */
    MobileRTCCannotShareReasonType_Have_Share_From_Mainsession,
    /** Another participant is sharing their zoom docs. */
    MobileRTCCannotShareReasonType_Other_Docs_Sharing,
    /** Other or myself is sharing docs, can grab. To grab, call 'EnableGrabShareWithoutReminder:true' before starting the share. */
    MobileRTCCannotShareReasonType_Need_Grab_Docs_Sharing,
    /** UnKnown reason. */
    MobileRTCCannotShareReasonType_UnKnown,
};

/**
 * @brief Enumeration of the virtual background type in MobileRTCVirtualBGImageInfo .
 */
typedef NS_ENUM(NSInteger, MobileRTCVBType)
{
    /** Virtual background type none. */
    MobileRTCVBType_None,
    /** Virtual background type blur. */
    MobileRTCVBType_Blur,
    /** Virtual background type with image. */
    MobileRTCVBType_Item
};

/**
 * @brief Enumeration of the type for video subscribe failed reason.
 */
typedef NS_ENUM(NSInteger, MobileRTCSubscribeFailReason)
{
    /** No failure. */
    MobileRTCSubscribe_Fail_None = 0,
    /** The user is in view-only mode and cannot subscribe to video. */
    MobileRTCSubscribe_Fail_ViewOnly,
    /** The user is not currently in the meeting. */
    MobileRTCSubscribe_Fail_NotInMeeting,
    /** Already subscribed to a 1080p video stream. Cannot subscribe to additional streams at that quality. */
    MobileRTCSubscribe_Fail_NotSupport1080P,
    /** Already subscribed to a 720p video stream. */
    MobileRTCSubscribe_Fail_HasSubscribe720P,
    /** The number of video subscriptions has exceeded the allowed limit. */
    MobileRTCSubscribe_Fail_HasSubscribeExceededLimit,
    /** The subscription requests were made too frequently in a short period of time. */
    MobileRTCSubscribe_Fail_TooFrequentCall,
    /** Already subscribed to one share on mobile. */
    MobileRTCSubscribe_Fail_HasSubscribeOneShare,
};

/**
 * @brief Enumeration of the live transcription status.
 */
typedef NS_ENUM(NSUInteger, MobileRTCLiveTranscriptionStatus) {
    /** Live transcription not start. */
    MobileRTC_LiveTranscription_Status_Unknown                  = 0,
    /** Live transcription not start. */
    MobileRTC_LiveTranscription_Status_Stop                     = 1,
    /** Live transcription start. */
    MobileRTC_LiveTranscription_Status_Start                    = 2,
    /** Live transcription connecting. */
    MobileRTC_LiveTranscription_Status_Connecting               = 3,
    /** Live transcription user sub. */
    MobileRTC_LiveTranscription_Status_UserSub               = 4,
};

/**
 * @brief Enumeration of the live transcription operation types.
 */
typedef NS_ENUM(NSUInteger, MobileRTCLiveTranscriptionOperationType) {
    /** No operation. Typically used for initialization. */
    MobileRTC_LiveTranscription_OperationType_None              = 0,
    /** Add a new live transcription entry. */
    MobileRTC_LiveTranscription_OperationType_Add               = 1,
    /** Update an existing live transcription entry. */
    MobileRTC_LiveTranscription_OperationType_Update            = 2,
    /** Delete a live transcription entry. */
    MobileRTC_LiveTranscription_OperationType_Delete            = 3,
    /** The transcription entry complete. */
    MobileRTC_LiveTranscription_OperationType_Complete          = 4,
    /** The operation is not supported. */
    MobileRTC_LiveTranscription_OperationType_NotSupported      = 5,
};

/**
 * @brief Enumeration of the status of the sign language interpretation.
 */
typedef NS_ENUM(NSInteger,MobileRTCSignInterpretationStatus)
{
    /** The initial status. */
    MobileRTCSignInterpretationStatus_Initial,
    /** Sign language interpretation has started. */
    MobileRTCSignInterpretationStatus_Started,
    /** Sign language interpretation has been stopped. */
    MobileRTCSignInterpretationStatus_Stopped,
};

/**
 * @brief Enumeration of the type for alive connect service status.
 */
typedef NS_ENUM(NSInteger, MobileRTCNotificationServiceStatus) {
    /** For initialization. */
    MobileRTCNotificationServiceStatus_None = 0,
    /** Starting. */
    MobileRTCNotificationServiceStatus_Starting,
    /** Started. */
    MobileRTCNotificationServiceStatus_Started,
    /** Failed to start. */
    MobileRTCNotificationServiceStatus_StartFailed,
    /** Closed. */
    MobileRTCNotificationServiceStatus_Closed
};

/**
 * @brief Enumeration of the notification service error codes.
 */
typedef NS_ENUM(NSInteger, MobileRTCNotificationServiceError)
{
    /** Operation completed successfully. */
    MobileRTCNotificationServiceError_Success = 0,
    /** Unknown error. */
    MobileRTCNotificationServiceError_Unknown,
    /** Internal error, need retry. */
    MobileRTCNotificationServiceError_Internal_Error,
    /** Invalid token. */
    MobileRTCNotificationServiceError_Invalid_Token,
    /** Use same user login again, the previous device will receive it. */
    MobileRTCNotificationServiceError_Multi_Connect,
    /** Network issue. */
    MobileRTCNotificationServiceError_Network_Issue,
    /** Server disconnects the connection if client stayed connected with server for more than 24 hours. Client need to reconnect/login again. */
    MobileRTCNotificationServiceError_Max_Duration,
    /** App switch to background. */
    MobileRTCNotificationServiceError_App_Background,
};

/**
 * @brief Enumeration of the supported audio types in a Zoom meeting. This is a bitmask enumeration; multiple values can be combined using bitwise OR.
 */
typedef NS_ENUM(NSInteger, MobileRTCInMeetingSupportAudioType) {
    /** No audio support. */
    MobileRTCInMeetingSupportAudioType_None = 0,
    /** VoIP (Voice over Internet Protocol) audio supported. */
    MobileRTCInMeetingSupportAudioType_Voip = 1,
    /** Telephony (phone dial-in/out) audio supported. */
    MobileRTCInMeetingSupportAudioType_Telephone = 1 << 1
};

/**
 * @brief Enumeration of the attendee view modes in a Zoom meeting. For more information, please visit <https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0063672>.
 */
typedef NS_ENUM(NSInteger, MobileRTCAttendeeViewMode){
    /** For initialization. */
    MobileRTCAttendeeViewMode_None,
    /** Attendee view follows the host's view setting. */
    MobileRTCAttendeeViewMode_FollowHost,
    /** Speaker view: shows the active speaker. */
    MobileRTCAttendeeViewMode_Speaker,
    /** Gallery view: displays all participants in a grid. */
    MobileRTCAttendeeViewMode_Gallery,
    /** Standard screen sharing view. */
    MobileRTCAttendeeViewMode_Sharing_Standard,
    /** Side-by-side view with shared content and speaker. */
    MobileRTCAttendeeViewMode_Sharing_SidebysideSpeaker,
    /** Side-by-side view with shared content and gallery. */
    MobileRTCAttendeeViewMode_Sharing_SidebysideGallery
};

/**
 * @brief Enumeration of the local recording request privilege settings.
 */
typedef NS_ENUM(NSUInteger, MobileRTCLocalRecordingRequestPrivilegeStatus) {
    /** For initialization. */
    MobileRTCLocalRecordingRequestPrivilege_None,
    /** Allow participant to send request privilege. */
    MobileRTCLocalRecordingRequestPrivilege_AllowRequest,
    /** Host auto allow all privilege request. */
    MobileRTCLocalRecordingRequestPrivilege_AutoGrant,
    /** Host auto deny all privilege request. */
    MobileRTCLocalRecordingRequestPrivilege_AutoDeny,
};

/**
 * @brief Enumeration of reminder types.
 */
typedef NS_ENUM(NSUInteger, MobileRTCReminderType) {
    /** Disclaimer type of login. */
    MobileRTCReminderType_Login,
    /** Disclaimer type of start or join meeting. */
    MobileRTCReminderType_StartOrJoinMeeting,
    /** Disclaimer type of record reminder. */
    MobileRTCReminderType_RecordReminder,
    /** Disclaimer type of record disclaimer. */
    MobileRTCReminderType_RecordDisclaimer,
    /** Disclaimer type of live stream disclaimer. */
    MobileRTCReminderType_LiveStreamDisclaimer,
    /** Disclaimer type of archive disclaimer. */
    MobileRTCReminderType_ArchiveDisclaimer,
    /** Disclaimer type of join webinar as panelist. */
    MobileRTCReminderType_WebinarAsPanelistJoin,
    /** Disclaimer type of .terms or service. */
    MobileRTCReminderType_TermsOfService,
    /** Disclaimer type of Smart Summary Disclaimer. */
    MobileRTCReminderType_SmartSummaryDisclaimer,
    /** Disclaimer type of of smart summary enable request. DEPRECATED_MSG_ATTRIBUTE(deprecated("No longer used").*/
    MobileRTCReminderType_SmartSummaryEnableRequestReminder DEPRECATED_ATTRIBUTE,
    /** Disclaimer type  of query disclaimer. */
    MobileRTCReminderType_QueryDisclaimer,
    /** Disclaimer type of query enable request. DEPRECATED_MSG_ATTRIBUTE(deprecated("No longer used"). */
    MobileRTCReminderType_QueryEnableRequestReminder DEPRECATED_ATTRIBUTE,
    /** Reminder type of enable smart summary. DEPRECATED_MSG_ATTRIBUTE(deprecated("No longer used"). */
    MobileRTCReminderType_EnableSmartSummaryReminder DEPRECATED_ATTRIBUTE,
    /** Reminder type of webinar attendee promote. */
    MobileRTCReminderType_WebinarAttendeePromoteReminder,
    /** Reminder type of joining a meeting with private mode. */
    MobileRTCReminderType_JoinPrivateModeMeetingReminder,
    /** Reminder type of AICompanionPlus disclaimer. DEPRECATED_MSG_ATTRIBUTE(deprecated("No longer used"). */
    MobileRTCReminderType_AICompanionPlusDisclaimer DEPRECATED_ATTRIBUTE,
    /** Reminder type of Closed Caption disclaimer. */
    MobileRTCReminderTypeClosedCaptionDisclaimer,
    /** Reminder type of disclaimers combination. */
    MobileRTCReminderType_MultiDisclaimer,
    /** Reminder type of join meeting Connector with guest mode. */
    MobileRTCReminderType_JoinMeetingConnectorAsGuestReminder,
    /** Reminder type of common disclaimer. */
    MobileRTCReminderType_CommonDisclaimer,
    /** Reminder type of Custom AI Companio disclaimer. */
    MobileRTCReminderType_CustomAICompanionDisclaimer,
    /** Reminder type of AIC restrict notify disclaimer. */
    MobileRTCReminderType_AICRestrictNotifyDisclaimer,
};

/**
 * @brief Enumeration of invite meeting types.
 */
typedef NS_ENUM(NSInteger, MobileRTCInviteMeetingStatus) {
    /** Meeting invitation accepted . */
    MobileRTCInviteMeetingStatus_Accepted,
    /** Meeting invitation declined . */
    MobileRTCInviteMeetingStatus_Declined,
    /** Meeting invitation canceled. */
    MobileRTCInviteMeetingStatus_Canceled,
    /** Meeting invitation timeout. */
    MobileRTCInviteMeetingStatus_Timeout
};

/**
 * @brief Enumeration of the user's presence status. For more information, please visit <https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0065488>.
 */
typedef NS_ENUM(NSInteger, MobileRTCPresenceStatus) {
    /** For initialization. */
    MobileRTCPresenceStatus_None,
    /** User is available. */
    MobileRTCPresenceStatus_Available,
    /** User is offline or not available. */
    MobileRTCPresenceStatus_UnAvailable,
    /** User is currently in a meeting. */
    MobileRTCPresenceStatus_InMeeting,
    /** User is marked as busy. */
    MobileRTCPresenceStatus_Busy,
    /** User does not want to be disturbed. */
    MobileRTCPresenceStatus_DoNotDisturb,
    /** User is away from the device. */
    MobileRTCPresenceStatus_Away,
    /** User is on a phone call. */
    MobileRTCPresenceStatus_PhoneCall,
    /** User is currently presenting content. */
    MobileRTCPresenceStatus_Presenting,
    /** User is in a calendar-scheduled event. */
    MobileRTCPresenceStatus_Calendar,
    /** User is marked as out of office. */
    MobileRTCPresenceStatus_OutOfOffice
};

/**
 * @brief Enumeration of the reminder action type.
 */
typedef NS_ENUM(NSInteger, MobileRTCReminderActionType) {
    /** Need no more action. */
    MobileRTCReminderActionType_None = 0,
    /** Need to sign in. */
    MobileRTCReminderActionType_NeedSignIn,
    /** Need to switch account. */
    MobileRTCReminderActionType_NeedSwitchAccount
};

/**
 * @brief Enumeration of the auto framing modes in video.
 */
typedef NS_ENUM(NSInteger, MobileRTCAutoFramingMode) {
    /** No use of the auto-framing. */
    MobileRTCAutoFramingMode_None,
    /** Use the video frame’s center point as the center to zoom. */
    MobileRTCAutoFramingMode_CenterCoordinates,
    /** Use the detected face in the video frame as the center to zoom in. */
    MobileRTCAutoFramingMode_FaceRecognition
};

/**
 * @brief Enumeration of the face recognition failure strategies.
 */
typedef NS_ENUM(NSInteger, MobileRTCFaceRecognitionFailStrategy) {
    /** No use of the fail strategy. */
    MobileRTCFaceRecognitionFailStrategy_None,
    /** After face recognition fails, do nothing until face recognition succeed again. */
    MobileRTCFaceRecognitionFailStrategy_Remain,
    /** After face recognition fails, use the video frame’s center point as the center for zoom in. */
    MobileRTCFaceRecognitionFailStrategy_UsingCenterCoordinates,
    /** After face recognition fails, use original video. */
    MobileRTCFaceRecognitionFailStrategy_UsingOriginalVideo
};

/**
 * @brief Enumeration of audio channel types.
 */
typedef NS_ENUM(NSInteger, MobileRTCAudioChannel) {
    /** Mono audio channel. */
    MobileRTCAudioChannel_Mono,
    /** Stereo audio channel. */
    MobileRTCAudioChannel_Stereo,
};

/**
 * @brief Enumeration of the content font style type for chat message. For more information, please visit <https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0064400>.
 */
typedef NS_ENUM(NSInteger, MobileRTCRichTextStyle) {
    /** Chat message content font style normal. */
    MobileRTCRichTextStyle_None,
    /** Chat message content font style bold. */
    MobileRTCRichTextStyle_Bold,
    /** Chat message content font style italic. */
    MobileRTCRichTextStyle_Italic,
    /** Chat message content font style strikethrough. */
    MobileRTCRichTextStyle_Strikethrough,
    /** Chat message content font style bulletedlist. */
    MobileRTCRichTextStyle_BulletedList,
    /** Chat message content font style numberedlist. */
    MobileRTCRichTextStyle_NumberedList,
    /** The style is under line. */
    MobileRTCRichTextStyle_Underline,
    /** The font size. */
    MobileRTCRichTextStyle_FontSize,
    /** The font color. */
    MobileRTCRichTextStyle_FontColor,
    /** Chat message content background color. */
    MobileRTCRichTextStyle_BackgroundColor,
    /** Chat message content font style indent. */
    MobileRTCRichTextStyle_Indent,
    /** Chat message content font style paragraph. */
    MobileRTCRichTextStyle_Paragraph,
    /** Chat message content font style quote. */
    MobileRTCRichTextStyle_Quote,
    /** Chat message content font style insert link. */
    MobileRTCRichTextStyle_InsertLink
};

/**
 * @brief Enumeration of the whiteboard share options.
 */
typedef NS_ENUM(NSInteger, MobileRTCWhiteboardShareOption) {
    /** Only the host can share a whiteboard. */
    MobileRTCWhiteboardShareOption_HostShare,
    /** Anyone can share a whiteboard, but only one can share at a time, and only the host can take another's sharing role. */
    MobileRTCWhiteboardShareOption_HostGrabShare,
    /** Anyone can share a whiteboard, but only one can share at a time, and anyone can take another's sharing role. */
    MobileRTCWhiteboardShareOption_AllGrabShare
};

/**
 * @brief Enumeration of the whiteboard create options.
 */
typedef NS_ENUM(NSInteger, MobileRTCWhiteboardCreateOption) {
    /** Only the host can initiate a new whiteboard. */
    MobileRTCWhiteboardCreateOption_HostOnly,
    /** Users under the same account as the meeting owner can initiate a new whiteboard. */
    MobileRTCWhiteboardCreateOption_AccountUsers,
    /** All participants can initiate a new whiteboard. */
    MobileRTCWhiteboardCreateOption_All
};

/**
 * @brief Enumeration of the whiteboard status.
 */
typedef NS_ENUM(NSInteger, MobileRTCWhiteboardStatus) {
    /** User stared sharing their whiteboard. */
    MobileRTCWhiteboardStatus_Started,
    /** User stopped sharing their whiteboard. */
    MobileRTCWhiteboardStatus_Stopped,
};

/**
 * @brief Enumeration of polling statuses.
 */
typedef NS_ENUM(NSInteger, MobileRTCPollingStatus) {
    /** The initial status. */
    MobileRTCPollingStatus_Initial,
    /** User started polling. */
    MobileRTCPollingStatus_Started,
    /** User shared polling result. */
    MobileRTCPollingStatus_ShareResult,
    /** User stopped polling. */
    MobileRTCPollingStatus_Stopped,
};

/**
 * @brief Enumeration of polling types.
 */
typedef NS_ENUM(NSInteger, MobileRTCPollingType) {
    /** Unknown polling type. */
    MobileRTCPollingType_Unknown,
    /** Standard polling type, typically used for gathering opinions or votes. */
    MobileRTCPollingType_Poll,
    /** Quiz type, used for knowledge checks or assessments. */
    MobileRTCPollingType_Quiz
};

/**
 * @brief Enumeration of the polling question types. For more information, please visit <https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0057587>.
 */
typedef NS_ENUM(NSInteger, MobileRTCPollingQuestionType) {
    /** Unknown question type. */
    MobileRTCPollingQuestionType_Unknown,
    /** Single choice question type. */
    MobileRTCPollingQuestionType_Single,
    /** Multiple choice question type. */
    MobileRTCPollingQuestionType_Multi,
    /** Matching question type. */
    MobileRTCPollingQuestionType_Matching,
    /** Rank order question type. */
    MobileRTCPollingQuestionType_RankOrder,
    /** Short answer question type. */
    MobileRTCPollingQuestionType_ShortAnswer,
    /** Long answer question type. */
    MobileRTCPollingQuestionType_LongAnswer,
    /** Fill in the blank question type. */
    MobileRTCPollingQuestionType_FillBlank,
    /** Rating scale question type. */
    MobileRTCPollingQuestionType_RatingScale,
    /** Dropdown question type. */
    MobileRTCPollingQuestionType_Dropdown,
};

/**
 * @brief Enumeration of the polling action types.
 */
typedef NS_ENUM(NSInteger, MobileRTCPollingActionType) {
    
    /** Unknown action type. */
    MobileRTCPollingActionType_Unknown,
    /** Start the polling session. */
    MobileRTCPollingActionType_Start,
    /** Stop the polling session. */
    MobileRTCPollingActionType_Stop,
    /** Share the polling results with participants. */
    MobileRTCPollingActionType_ShareResult,
    /** Stop sharing the polling results. */
    MobileRTCPollingActionType_StopShareResult,
    /** Duplicate the polling. */
    MobileRTCPollingActionType_Duplicate,
    /** Delete the polling. */
    MobileRTCPollingActionType_Delete,
    /** Submit polling responses. */
    MobileRTCPollingActionType_Submit,
    /** An error occurred with the polling action. */
    MobileRTCPollingActionType_Error
};

/**
 * @brief Enumeration of the focus mode share type. For more information, please visit <https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0063004>.
 */
typedef NS_ENUM(NSInteger, MobileRTCFocusModeShareType) {
    /** For initialization. */
    MobileRTCFocusModeShareType_None,
    /** Only the host can view share content in focus mode. */
    MobileRTCFocusModeShareType_HostOnly,
    /** All participants can view share content in focus mode. */
    MobileRTCFocusModeShareType_AllParticipants,
};

/**
 * @brief Enumeration of the AI companion types.
 */
typedef NS_ENUM(NSUInteger, MobileRTCAICompanionType) {
    /** Meeting summary with AI Ccompanion  generates summary assets. */
    MobileRTCAICompanionType_SMART_SUMMARY,
    /** Meeting questions with AI Ccompanion  generates transcripts assets. */
    MobileRTCAICompanionType_QUERY,
    /** Ssmart recording with AI Ccompanion  generates recordings assets. */
    MobileRTCAICompanionType_SMART_RECORDING
};

/**
 * @brief Enumeration of the status of the file transfer.
 */
typedef NS_ENUM(NSInteger, MobileRTCFileTransferStatus) {
    /** The file transfer has no state. */
    FileTransferState_NONE = 0,
    /** The file transfer is ready to start. */
    FileTransferState_ReadyToTransfer,
    /** The file transfer is in progress. */
    FileTransferState_Transfering,
    /** The file transfer failed. */
    FileTransferState_TransferFailed,
    /** The file transfer completed successfully. */
    FileTransferState_TransferDone,
};

/**
 * @brief Enumeration of the UVC camera types.
 */
typedef NS_ENUM(NSInteger, MobileRTCUVCCameraStatus) {
    /** UVC camera attached. */
    MobileRTCUVCCameraStatus_Attached = 0,
    /** UVC camera detached. */
    MobileRTCUVCCameraStatus_Detached
};

/**
 * @brief Enumeration of the video preference modes.
 */
typedef NS_ENUM(NSUInteger, MobileRTCVideoPreferenceMode) {
    /** Balance (Default preference with no additional parameters needed): Zoom will do what is best under the current bandwidth situation and make adjustments as needed. */
    MobileRTCVideoPreferenceMode_Balance,
    /** Sharpness: Prioritizes a smooth video frame transition by preserving the frame rate as much as possible. */
    MobileRTCVideoPreferenceMode_Sharpness,
    /** Smoothness: Prioritizes a sharp video image by preserving the resolution as much as possible. */
    MobileRTCVideoPreferenceMode_Smoothness,
    /** Custom: Allows customization by providing the minimum and maximum frame rate. Use this mode if you have an understanding of your network behavior and a clear idea on how to adjust the frame rate to achieve the desired video quality. */
    MobileRTCVideoPreferenceMode_Custom
};

/**
 * @brief Enumeration of the document sharing status in a meeting.
 */
typedef NS_ENUM(NSUInteger, MobileRTCDocsStatus) {
    /** User starts sharing docs. */
    MobileRTCDocsStatus_Start = 0,
    /** User stops sharing docs. */
    MobileRTCDocsStatus_Stop,
};

/**
 * @brief Enumeration of the document sharing permission options.
 */
typedef NS_ENUM(NSUInteger, MobileRTCDocsShareOption) {
    /** Invalid option, such as the meeting not supporting document sharing. */
    MobileRTCDocsShareOption_None = 0,
    /** Only Only the host or co-host can share documents. */
    MobileRTCDocsShareOption_HostShare,
    /** Anyone can share docs, but only one doc can be shared at a time, and the host or co-host can take over another'sharing. */
    MobileRTCDocsShareOption_HostGrabShare,
    /** Anyone can share docs, but only one doc can be shared at a time, and any participant can take over another'sharing. */
    MobileRTCDocsShareOption_AllGrabShare,
};

/**
 * @brief Enumeration of the document creation permission options.
 */
typedef NS_ENUM(NSUInteger, MobileRTCDocsCreateOption) {
    /** Invalid option, possibly because the meeting does not support docs. */
    MobileRTCDocsCreateOption_None = 0,
    /** Only the host can initiate new docs. */
    MobileRTCDocsCreateOption_HostOnly,
    /** Users under the same account can initiate new docs. */
    MobileRTCDocsCreateOption_AccountUsers,
    /** All participants can initiate new docs. */
    MobileRTCDocsCreateOption_All,
};


/**
 * @brief Enumeration of co-owner assets type.
 */
typedef NS_ENUM(NSUInteger, MobileRTCDGrantCoOwnerAssetsType) {
    /** For initialization. */
    MobileRTCDGrantCoOwnerAssetsType_None,
    /** Summary. */
    MobileRTCDGrantCoOwnerAssetsType_Summary,
    /** CloudRecording. */
    MobileRTCDGrantCoOwnerAssetsType_CloudRecording,
};

/**
 * @brief Enumeration of possible results for pinning a user.
 */
typedef NS_ENUM(NSUInteger, MobileRTCPinResult) {
    /** Pinning succeeded. */
    MobileRTCPinResult_Success,
    /** User counts less than 2. */
    MobileRTCPinResult_Fail_NotEnoughUsers,
    /** User cannot be pinned (e.g., view-only mode, silent mode, or active speaker). */
    MobileRTCPinResult_Fail_UserCannotBePinned,
    /** Other reasons.  */
    MobileRTCPinResult_Fail_VideoModeDoNotSupport,
    /** Current user has no privilege to pin. */
    MobileRTCPinResult_Fail_NoPrivilegeToPin,
    /** Webinar and in view only meeting. */
    MobileRTCPinResult_Fail_MeetingDoNotSupport,
    /** Too many users in the meeting to allow pinning. */
    MobileRTCPinResult_Fail_TooManyUsers,
    /** Unknown error. */
    MobileRTCPinResult_Unknown,
};

/**
 * @brief Enumeration of custom 3D avatar element image types.
 */
typedef NS_ENUM(NSInteger, MobileRTCCustom3DAvatarElementImageType) {
    /** None. */
    MobileRTCCustom3DAvatarElementImageType_None = 0,
    /** Skin. */
    MobileRTCCustom3DAvatarElementImageType_Skin,
    /** Face. */
    MobileRTCCustom3DAvatarElementImageType_Face,
    /** Hair. */
    MobileRTCCustom3DAvatarElementImageType_Hair,
    /** Eyes. */
    MobileRTCCustom3DAvatarElementImageType_Eyes,
    /** Eye color. */
    MobileRTCCustom3DAvatarElementImageType_EyeColor,
    /** Eyelashes. */
    MobileRTCCustom3DAvatarElementImageType_Eyelashes,
    /** Eyebrows. */
    MobileRTCCustom3DAvatarElementImageType_Eyebrows,
    /** Nose. */
    MobileRTCCustom3DAvatarElementImageType_Nose,
    /** Mouth. */
    MobileRTCCustom3DAvatarElementImageType_Mouth,
    /** Lip color. */
    MobileRTCCustom3DAvatarElementImageType_LipColor,
    /** Age. */
    MobileRTCCustom3DAvatarElementImageType_Age,
    /** Facial hair. */
    MobileRTCCustom3DAvatarElementImageType_FacialHair,
    /** Body. */
    MobileRTCCustom3DAvatarElementImageType_Body,
    /** Clothing. */
    MobileRTCCustom3DAvatarElementImageType_Clothing,
    /** Head covering. */
    MobileRTCCustom3DAvatarElementImageType_HeadCovering,
    /** Glasses. */
    MobileRTCCustom3DAvatarElementImageType_Glasses,
};

/**
 * @brief Enumeration of custom 3D avatar element color types.
 */
typedef NS_ENUM(NSInteger, MobileRTCCustom3DAvatarElementColorType) {
    /** None. */
    MobileRTCCustom3DAvatarElementColorType_None = 0,
    /** Eyebrow. */
    MobileRTCCustom3DAvatarElementColorType_Eyebrow,
    /** Mustache. */
    MobileRTCCustom3DAvatarElementColorType_Mustache,
    /** Hair. */
    MobileRTCCustom3DAvatarElementColorType_Hair,
    /** Eyelash. */
    MobileRTCCustom3DAvatarElementColorType_Eyelash,
};

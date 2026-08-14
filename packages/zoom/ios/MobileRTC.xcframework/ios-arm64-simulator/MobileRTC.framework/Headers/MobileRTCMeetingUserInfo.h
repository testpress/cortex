/**
 * @file MobileRTCMeetingUserInfo.h
 * @brief User information and participant data structures.
 */

#import <Foundation/Foundation.h>

/**
 * @class MobileRTCVideoStatus
 * @brief A class that contains video status of the current user in the meeting.
 */
@interface MobileRTCVideoStatus : NSObject

/**
 * @brief Indicates if the user is sending video.
 */
@property (nonatomic, assign) BOOL  isSending;

/**
 * @brief Indicates if the user is receiving video.
 */
@property (nonatomic, assign) BOOL  isReceiving;

/**
 * @brief Indicates if the camera is connected to the current meeting.
 */
@property (nonatomic, assign) BOOL  isSource;

@end

/**
 * @brief Enumeration of the type of a user's audio connection.
 */
typedef NS_ENUM(NSUInteger, MobileRTCAudioType) {
    /** Connected via VoIP (Voice over Internet Protocol). */
    MobileRTCAudioType_VoIP   = 0,
    /** Connected via phone call. */
    MobileRTCAudioType_Telephony,
    /** Unknown audio connection type. */
    MobileRTCAudioType_None,
};

/**
 * @class MobileRTCAudioStatus
 * @brief A class that contains audio status of the current user in the meeting.
 */
@interface MobileRTCAudioStatus : NSObject

/**
 * @brief Indicates if the audio of the current user is muted.
 */
@property (nonatomic, assign) BOOL  isMuted;

/**
 * @brief Indicates if the current user is speaking.
 * @warning Webinar attendees cannot get this property.
 */
@property (nonatomic, assign) BOOL  isTalking;

/**
 * @brief The audio type of the current meeting.
 */
@property (nonatomic, assign) MobileRTCAudioType  audioType;

@end

/**
 * @class MobileRTCVirtualNameTag
 * @brief A class that represents a virtual name tag.
 */
@interface MobileRTCVirtualNameTag : NSObject

/**
 * @brief The tag ID. tagID is the unique identifier. The range of tagID is 0-1024.
 */
@property (nonatomic, assign)       NSInteger tagID;

/**
 * @brief The tag name.
 */
@property (nonatomic, copy)         NSString * _Nullable tagName;
@end

/**
 * @class MobileRTCGrantCoOwnerAssetsInfo
 * @brief A class that provides properties to specify and manage the privileges associated with different types of assets when assigning roles such as co-host or host in a meeting.
 * @note \link MobileRTCGrantCoOwnerAssetsInfo \endlink objects must be obtained through the \link -[MobileRTCMeetingUserInfo getGrantCoOwnerAssetsInfo] \endlink interface provided by the SDK. Manual creation is not allowed.
 */
@interface MobileRTCGrantCoOwnerAssetsInfo : NSObject

/**
 * @brief Gets the asset type.
 */
@property (nonatomic, assign, readonly) MobileRTCDGrantCoOwnerAssetsType type;

/**
 * @brief Indicates if the asset is locked.
 * @note When the asset is locked, changing the grant property through the \link MobileRTCGrantCoOwnerAssetsInfo.isGranted \endlink interface is invalid.
 */
@property (nonatomic, assign, readonly) BOOL isAssetsLocked;

/**
 * @brief Gets or sets if the asset is granted.
 */
@property (nonatomic, assign) BOOL isGranted;

@end


/**
 * @class MobileRTCMeetingUserInfo
 * @brief A class that contains information of the current user in the meeting.
 */
@interface MobileRTCMeetingUserInfo : NSObject

/**
 * @brief The user ID.
 */
@property (nonatomic, assign) NSUInteger       userID;

/**
 * @brief Gets the user persistent ID matched with the current user information. This ID persists for the duration of the main meeting. Once the main meeting ends, the ID will be discarded.
 */
@property (nonatomic, copy) NSString* _Nullable       persistentId;

/**
 * @brief Determines if the information corresponds to the current user.
 */
@property (nonatomic, assign) BOOL             isMySelf;

/**
 * @brief The customer key that the app integrated with SDK needs to specify. The SDK will set this value when the associated settings are turned on. The max length of customer_key is 35.
 */
@property (nonatomic, copy) NSString* _Nullable       customerKey;

/**
 * @brief The screen name of the user.
 */
@property (nonatomic, copy) NSString* _Nullable        userName;

/**
 * @brief The path to store the head portrait.
 */
@property (nonatomic, copy) NSString* _Nullable       avatarPath;

/**
 * @brief The user's video status in the meeting.
 */
@property (nonatomic, retain) MobileRTCVideoStatus* _Nullable videoStatus;

/**
 * @brief The user's audio status in the meeting.
 */
@property (nonatomic, retain) MobileRTCAudioStatus* _Nullable audioStatus;

/**
 * @brief Indicates if the user raised their hand.
 */
@property (nonatomic, assign) BOOL             handRaised;

/**
 * @brief Indicates if the participant has a camera.
 */
@property (nonatomic, assign) BOOL             hasCamera;

/**
 * @brief Indicates if the user entered the waiting room when joining the meeting.
 */
@property (nonatomic, assign) BOOL             inWaitingRoom;

/**
 * @brief Indicates if the current user is the co-host.
 */
@property (nonatomic, assign) BOOL             isCohost;

/**
 * @brief Indicates if the current user is the host.
 */
@property (nonatomic, assign) BOOL             isHost;

/**
 * @brief Indicates if the current user is an H.323 user.
 */
@property (nonatomic, assign) BOOL             isH323User;

/**
 * @brief Indicates if the current user is a telephone user.
 */
@property (nonatomic, assign) BOOL             isPureCallInUser;

/**
 * @brief Indicates if the user is sharing only the sounds of computer.
 */
@property (nonatomic, assign) BOOL             isSharingPureComputerAudio;

/**
 * @brief The emoji feedback type from the user.
 */
@property (nonatomic, assign) MobileRTCEmojiFeedbackType  emojiFeedbackType;

/**
 * @brief The type of role of the user specified by the current information.
 */
@property (nonatomic, assign) MobileRTCUserRole  userRole;

/**
 * @brief Determines if the user is an interpreter.
 */
@property (nonatomic, assign) BOOL             isInterpreter;

/**
 * @brief Determines whether the user specified by the current information is a sign language interpreter.
 */
@property (nonatomic, assign) BOOL             isSignLanguageInterpreter;

/**
 * @brief Gets the interpreter active language.
 */
@property (nonatomic, copy) NSString* _Nullable   interpreterActiveLanguage;

/**
 * @brief Determines whether the user has started a raw live stream.
 */
@property (nonatomic, assign) BOOL             isRawLiveStreaming;

/**
 * @brief Determines whether the user has raw live stream privilege.
 */
@property (nonatomic, assign) BOOL             hasRawLiveStreamPrivilege;

/**
 * @brief Determines whether the user corresponding to the current information is the sender of Closed Caption.
 */
@property (nonatomic, assign) BOOL       isClosedCaptionSender;

/**
 * @brief Indicates whether the user is a production studio user.
 */
@property (nonatomic, assign) BOOL  isProductionStudioUser;

/**
 * @brief Determines whether the user specified by the current information is in companion mode.
 */
@property (nonatomic, assign) BOOL  isCompanionModeUser;

/**
 * @brief The ID of the parent user of this production user.
 */
@property (nonatomic, assign) NSInteger  productionStudioParent;

/**
 * @brief Determines whether the user specified by the current information is in the webinar backstage.
 */
@property (nonatomic, assign) BOOL  isInWebinarBackstage;

/**
 * @brief Determines whether the user specified by the current information is a bot user.
 */
@property (nonatomic, assign) BOOL isBotUser;

/**
 * @brief Gets the bot app name.
 */
@property (nonatomic, copy) NSString* _Nullable        botAppName;

/**
 * @brief Queries if the participant enabled virtual name tag.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)isVirtualNameTagEnabled;

/**
 * @brief Queries the virtual name tag roster information.
 * @return If the function succeeds, it returns an NSArray of MobileRTCVirtualNameTag objects. Otherwise, this function fails and returns nil.
 */
- (NSArray<MobileRTCVirtualNameTag*> * _Nullable)getVirtualNameTagArray;

/**
 * @brief Queries the granted assets info when assigning a co-owner.
 * @return If the function succeeds, it returns an NSArray of MobileRTCGrantCoOwnerAssetsInfo objects. Otherwise, this function fails and returns nil.
 * @note If not granted any assets privilege, the default configuration of the web will be queried. If assets privilege has been granted, the result after granting will be queried.
 */
- (nullable NSArray <MobileRTCGrantCoOwnerAssetsInfo*> *)getGrantCoOwnerAssetsInfo;

/**
 * @brief Determines whether the specified user is an audio only user.
 * @return YES if the specified user is an audio only user. Otherwise, NO.
 */
- (BOOL)isAudioOnlyUser;

@end

/**
 * @class MobileRTCMeetingWebinarAttendeeInfo
 * @brief A class that contains information of a user in the webinar.
 */
@interface MobileRTCMeetingWebinarAttendeeInfo : NSObject

/**
 * @brief The user ID.
 */
@property (nonatomic, assign) NSUInteger userID;

/**
 * @brief Determines if the information corresponds to the current user.
 */
@property (nonatomic, assign) BOOL             isMySelf;

/**
 * @brief The screen name of the user.
 */
@property (nonatomic, copy) NSString * _Nullable userName;

/**
 * @brief The type of role of the user specified by the current information.
 */
@property (nonatomic, assign) MobileRTCUserRole  userRole;

/**
 * @brief Indicates if the user raised their hand.
 */
@property (nonatomic, assign) BOOL             handRaised;

/**
 * @brief Indicates if the attendee can talk.
 */
@property (nonatomic, assign) BOOL             isAttendeeCanTalk;

/**
 * @brief The user's audio status in the webinar meeting.
 */
@property (nonatomic, retain) MobileRTCAudioStatus* _Nullable audioStatus;

@end

/**
 * @file MobileRTCBORole.h
 * @brief Breakout room role management and user status definitions.
 * The AI Companion brand has been retired. AI-powered features are now more deeply integrated throughout Zoom Workplace. Existing APIs and SDKs that reference AI Companion will continue to function as before to ensure backward compatibility.
 */

#import <Foundation/Foundation.h>

/**
 * @brief Enumeration of breakout meeting user status.
 */
typedef enum : NSUInteger {
    /** The breakout meeting status is unknown. */
    BOUserStatusUnknown      = 0,
    /** The user is unassigned to any breakout meeting. */
    BOUserStatusUnassigned  = 1,
    /** The user is assigned but has not joined the breakout meeting. */
    BOUserStatusNotJoin     = 2,
    /** The user is currently in the breakout meeting. */
    BOUserStatusInBO        = 3,
} MobileRTCBOUserStatus;

/**
 * @class MobileRTCBOUser
 * @brief A class that represents a user in a breakout room.
 */
@interface MobileRTCBOUser : NSObject

/**
 * @brief Gets the breakout meeting user ID.
 * @return The breakout meeting user ID.
 */
- (NSString * _Nullable)getUserId;

/**
 * @brief Gets the breakout meeting user name.
 * @return The breakout meeting user name.
 */
- (NSString * _Nullable)getUserName;

@end

/**
 * @class MobileRTCBOMeeting
 * @brief A class that provides functions for breakout meetings.
 */
@interface MobileRTCBOMeeting : NSObject

/**
 * @brief Gets the breakout meeting ID.
 * @return The breakout meeting ID.
 */
- (NSString * _Nullable)getBOMeetingId;

/**
 * @brief Gets the breakout meeting name.
 * @return The breakout meeting name.
 */
- (NSString * _Nullable)getBOMeetingName;

/**
 * @brief Gets the breakout meeting user array.
 * @return If the function succeeds, will get the breakout meeting user list.
 */
- (NSArray <NSString *>* _Nullable)getBOMeetingUserList;

/**
 * @brief Gets the breakout meeting user status.
 * @param userID The user's user ID.
 * @return If the function succeeds, it returns the user status.
 */
-(MobileRTCBOUserStatus)getBOUserStatusWithUserID:(NSString *_Nonnull)userID;
@end

/**
 * @brief Enumeration of Breakout Room (BO) stop countdown durations.
 */
typedef NS_ENUM(NSUInteger, MobileRTCBOStopCountDown) {
    /** No countdown. Breakout Rooms stop immediately. */
    MobileRTCBOStopCountDown_Not_CountDown  = 0,
    /** Countdown duration: 10 seconds before BO stops. */
    MobileRTCBOStopCountDown_Seconds_10,
    /** Countdown duration: 15 seconds before BO stops. */
    MobileRTCBOStopCountDown_Seconds_15,
    /** Countdown duration: 30 seconds before BO stops. */
    MobileRTCBOStopCountDown_Seconds_30,
    /** Countdown duration: 60 seconds before BO stops. */
    MobileRTCBOStopCountDown_Seconds_60,
    /** Countdown duration: 120 seconds before BO stops. */
    MobileRTCBOStopCountDown_Seconds_120,
};

/**
 * @class MobileRTCBOOption
 * @brief A class that contains breakout room options.
 */
@interface MobileRTCBOOption : NSObject

/**
 * @brief The breakout room countdown seconds.
 */
@property (nonatomic, assign) MobileRTCBOStopCountDown countdownSeconds;

/**
 * @brief Enables or disables that participant can choose breakout room.
 */
@property (nonatomic, assign) BOOL isParticipantCanChooseBO;

/**
 * @brief Enables or disables that participant can return to main session at any time.
 */
@property (nonatomic, assign) BOOL isParticipantCanReturnToMainSessionAtAnyTime;

/**
 * @brief Enables or disables that auto move all assigned participants to breakout room.
 */
@property (nonatomic, assign) BOOL isAutoMoveAllAssignedParticipantsEnabled;

/**
 * @brief Indicates whether it's a timer breakout room. YES if it's a timer breakout room, NO otherwise.
 */
@property (nonatomic, assign) BOOL isBOTimerEnabled;

/**
 * @brief Indicates whether to auto stop breakout room when time is up. YES if auto stop is enabled, NO otherwise.
 */
@property (nonatomic, assign) BOOL isTimerAutoStopBOEnabled;

/**
 * @brief The minutes of breakout room timer duration.
 * @warning When timerDurationMinutes is 0, it means that the breakout room duration is 30 minutes.
 */
@property (nonatomic, assign) NSInteger timerDurationMinutes;

//  WebinarBo
/**
 * @brief Enables or disables webinar attendee join webinar breakout room. When it changes, the breakout room data will be reset.
 */
@property(nonatomic,assign) BOOL isAttendeeContained;

/**
 * @brief Enables or disables that panelist can choose breakout room.
 */
@property(nonatomic,assign) BOOL isPanelistCanChooseBO;

/**
 * @brief Enables or disables that attendee can choose breakout room. Invalid when attendee is not contained.
 */
@property(nonatomic,assign) BOOL isAttendeeCanChooseBO;

/**
 * @brief Enables or disables that max room user limits in breakout room.
 */
@property(nonatomic,assign) BOOL isUserConfigMaxRoomUserLimitsEnabled;

/**
 * @brief The number of max room user limits in breakout room. The default is 20.
 */
@property(nonatomic,assign)unsigned int nUserConfigMaxRoomUserLimits;

/**
 * @brief Enables or disables auto-starting AI Companion for host or co-host in breakout rooms.
 * @note This is effective only when \link MobileRTCBOCreator::isAICompanionSupported \endlink returns YES.
 */
@property(nonatomic, assign) BOOL isAICompanionEnabled;

/**
 * @brief Enables or disables auto-starting transcription in breakout rooms.
 * @note This is effective only when \link MobileRTCBOCreator::isTranscriptionSupported \endlink returns YES.
 */
@property(nonatomic, assign) BOOL isTranscriptionEnabled;

@end

/**
 *    //////////////////////////// Creator ////////////////////////////
 *    1. Main Functions:
 *        1) create|delete|rename BO
 *        2) assign|remove user to BO
 *       3) set BO option
 *    2. Remarks:
 *       1) These editing can only be done before BO is started
 *
 *    //////////////////////////// Admin ////////////////////////////
 *   1. Main Functions:
 *        1) after BO is started, assign new user to BO,
 *        2) after BO is started, switch user from BO-A to BO-B
 *       3) stop BO
 *        4) start BO
 *
 *    //////////////////////////// Assistant ////////////////////////////
 *    1. Main Functions:
 *        1) join BO with BO id
 *        2) leave BO
 *
 *   //////////////////////////// Attendee ////////////////////////////
 *   1. Main Functions:
 *        1) join BO
 *       2) leave BO
 *       3) request help
 *
 *    //////////////////////////// DataHelper ////////////////////////////
 *    1. Main Functions:
 *        1) get unassigned user list
 *        2) get BO list
 *       3) get BO object
 *
 *
 *    host in master conference     : creator + admin + assistant + dataHelper
 *    host in BO conference         : admin + assistant + dataHelper
 *    CoHost in master conference   : [attendee] or [creator + admin + assistant + dataHelper]
 *    CoHost in BO conference       : [attendee] or [admin + assistant + dataHelper]
 *    attendee in master conference : attendee + [assistant + dataHelper]
 *   attendee in BO conference     : attendee + [assistant + dataHelper]
 *
 *   Import Remarks:
 *   1. attendee in master conference/attendee in BO conference
 *       1) if BOOption.IsParticipantCanChooseBO is YES, attendee has objects:  [attendee + assistant + dataHelper]
 *      2) if BOOption.IsParticipantCanChooseBO is NO, attendee has object:  [attendee]
 *   2. CoHost in master conference
 *       1) if CoHost is desktop client, and host is desktop client, the CoHost has objects: [creator + admin + assistant + dataHelper]
 *      2) if CoHost is desktop client, and host is mobile client, the CoHost has object: [attendee]
 *      3) if CoHost is mobile client, the CoHost has object: [attendee]
 */

/**
 * @class MobileRTCBOCreator
 * @brief A class for creating and managing breakout rooms.
 */
@interface MobileRTCBOCreator : NSObject

/**
 * @brief Creates a breakout meeting.
 * @param boName The breakout room name.
 * @return The breakout meeting ID.
 * @deprecated Use \link createBreakoutRoom: \endlink instead.
 */
- (NSString * _Nullable)createBO:(NSString * _Nonnull)boName DEPRECATED_MSG_ATTRIBUTE("Use createBreakoutRoom: instead");

/**
 * @brief Creates a breakout room.
 * @param boName The breakout room name.
 * @return YES if the function succeeds. Otherwise, NO.
 * @note 1. This function is compatible with meeting breakout room and webinar breakout room.
 * @note 2. This function is asynchronous. The callback is 'onCreateBOResponse:BOID:'.
 * @note 3. Webinar breakout room is only supported in Zoom UI mode.
 */
- (BOOL)createBreakoutRoom:(NSString * _Nonnull)boName;

/**
 * @brief Creates breakout meetings in batches.
 * @param boNameList The breakout room name list.
 * @return YES if batch breakout room creation succeeds. Otherwise, NO.
 */
- (BOOL)createGroupBO:(NSArray<NSString*> * _Nonnull)boNameList;

/**
 * @brief Creates webinar breakout meeting. Available only for Zoom UI mode.
 * @param boNameList The breakout meeting name list. Each element of nameList should be less than 50 characters.
 * @return YES if the function succeeds. Otherwise, NO.
 * @deprecated Use \link createBreakoutRoom: \endlink instead.
 */
- (BOOL)createWebinarBO:(NSArray<NSString*> * _Nonnull)boNameList DEPRECATED_MSG_ATTRIBUTE("Use createBreakoutRoom: instead");

/**
 * @brief Updates breakout meeting name with breakout room ID. The callback is 'onUpdateBONameResponse:BOID'.
 * @param boId The breakout room ID.
 * @param boName The breakout room name.
 * @return YES if update succeeds. Otherwise, NO.
 */
- (BOOL)updateBO:(NSString * _Nonnull)boId name:(NSString * _Nonnull)boName;

/**
 * @brief Removes a breakout meeting. The callback is 'onRemoveBOResponse:BOID:'.
 * @param boId The breakout room ID.
 * @return YES if remove breakout meeting succeeds. Otherwise, NO.
 */
- (BOOL)removeBO:(NSString * _Nonnull)boId;

/**
 * @brief Assigns a user to a breakout meeting.
 * @param boUserId The breakout room user ID.
 * @param boId The breakout room ID.
 * @return YES if assign succeeds. Otherwise, NO.
 */
- (BOOL)assignUser:(NSString * _Nonnull)boUserId toBO:(NSString * _Nonnull)boId;

/**
 * @brief Removes a user from a breakout meeting.
 * @param boUserId The breakout room user ID.
 * @param boId The breakout room ID.
 * @return YES if remove succeeds. Otherwise, NO.
 */
- (BOOL)removeUser:(NSString * _Nonnull)boUserId fromBO:(NSString * _Nonnull)boId;

/**
 * @brief Sets breakout room option.
 * @param option The option that you want to set.
 * @return MobileRTCSDKError_Success if the function succeeds. Otherwise, returns a specific error (e.g. MobileRTCSDKError_Breakout_Room_Not_Created).
 */
- (MobileRTCSDKError)setBOOption:(MobileRTCBOOption *_Nonnull)option;

/**
 * @brief Gets breakout room option.
 * @return The breakout room option value.
 */
- (MobileRTCBOOption * _Nullable)getBOOption;

/**
 * @brief Checks whether web enabled the pre-assigned option when scheduling a meeting.
 * @return YES if it is enabled. Otherwise, NO.
 */
- (BOOL)isWebPreAssignBOEnabled;

/**
 * @brief Requests web pre-assigned data and creates those rooms.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)requestAndUseWebPreAssignBOList;

/**
 * @brief Gets the downloading status of pre-assigned data.
 * @return The download status.
 */
- (MobileRTCBOPreAssignBODataStatus)getWebPreAssignBODataStatus;

/**
 * @brief Checks whether AI Companion can be enabled in breakout rooms.
 * @return YES if AI Companion is supported for breakout rooms. Otherwise, NO.
 */
- (BOOL)isAICompanionSupported;

/**
 * @brief Checks whether transcription can be enabled in breakout rooms.
 * @return YES if transcription is supported for breakout rooms. Otherwise, NO.
 */
- (BOOL)isTranscriptionSupported;

@end

/**
 * @class MobileRTCBOAdmin
 * @brief A class for managing breakout rooms.
 */
@interface MobileRTCBOAdmin : NSObject

/**
 * @brief Starts the assigned breakout meeting. The callback is 'onStartBOResponse:'.
 * @return YES if start succeeds. Otherwise, NO.
 */
- (BOOL)startBO;

/**
 * @brief Stops the assigned breakout meeting. The callback is 'onStopBOResponse:'.
 * @return YES if stop succeeds. Otherwise, NO.
 */
- (BOOL)stopBO;

/**
 * @brief Assigns a breakout room user to a started breakout meeting.
 * @param boUserId The breakout room user ID.
 * @param boId The breakout room ID.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)assignNewUser:(NSString * _Nonnull)boUserId toRunningBO:(NSString * _Nonnull)boId;

/**
 * @brief Switches a user to a new started breakout meeting.
 * @param boUserId The breakout room user ID.
 * @param boId The breakout room ID.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)switchUser:(NSString * _Nonnull)boUserId toRunningBO:(NSString * _Nonnull)boId;

/**
 * @brief Determines if the breakout room can be started.
 * @return YES if the breakout room can be started. Otherwise, NO.
 */
- (BOOL)canStartBO;

/**
 * @brief Joins breakout meeting for designated breakout room user ID.
 * @param boUserId The breakout room user ID.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)joinBOByUserRequest:(NSString * _Nonnull)boUserId;

/**
 * @brief Ignores the help request from breakout room attendees.
 * @param boUserId The breakout room user ID.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)ignoreUserHelpRequest:(NSString * _Nonnull)boUserId;

/**
 * @brief Broadcasts a message to all attendees in the meeting.
 * @param strMsg The breakout room message.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)broadcastMessage:(NSString * _Nonnull)strMsg;

/**
 * @brief Host invites user to return to main session. When breakout room is started and user is in breakout room.
 * @param boUserId The breakout room user ID.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)inviteBOUserReturnToMainSession:(NSString * _Nonnull)boUserId;

/**
 * @brief Queries if the current meeting supports broadcasting host's voice to breakout room.
 * @return YES if the meeting supports this. Otherwise, NO.
 */
- (BOOL)isBroadcastVoiceToBOSupport;

/**
 * @brief Queries if the host now has the ability to broadcast voice to breakout room.
 * @return YES if the host now has the ability. Otherwise, NO.
 */
- (BOOL)canBroadcastVoiceToBO;

/**
 * @brief Starts or stops broadcasting voice to breakout room.
 * @param bStart YES to start, NO to stop.
 * @return YES if the invocation succeeds. Otherwise, NO.
 */
- (BOOL)broadcastVoiceToBO:(BOOL)bStart;
@end

/**
 * @class MobileRTCBOAssistant
 * @brief A class that manages operations for joining and leaving breakout meetings as an assistant.
 */
@interface MobileRTCBOAssistant : NSObject

/**
 * @brief Joins a breakout meeting with breakout room ID.
 * @param boId The breakout room ID.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)joinBO:(NSString * _Nonnull)boId;

/**
 * @brief Leaves the joined breakout meeting.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)leaveBO;

@end

/**
 * @class MobileRTCBOAttendee
 * @brief A class that manages operations for attendees in breakout meetings.
 */
@interface MobileRTCBOAttendee : NSObject

/**
 * @brief Joins the assigned breakout meeting.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)joinBO;

/**
 * @brief Leaves the assigned breakout meeting.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)leaveBO;

/**
 * @brief Gets the breakout meeting name.
 * @return The breakout room name.
 */
- (NSString * _Nullable)getBOName;

/**
 * @brief Sends help request to admin.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)requestForHelp;

/**
 * @brief Determines if the host is in the current breakout room.
 * @return YES if the host is in the current breakout room. Otherwise, NO.
 */
- (BOOL)isHostInThisBO;

/**
 * @brief Determines if participant can return to main session.
 * @return YES if participant can return to main session. Otherwise, NO.
 */
- (BOOL)isCanReturnMainSession;

@end

/**
 * @class MobileRTCBOData
 * @brief A class that provides data helper functions for breakout meetings.
 */
@interface MobileRTCBOData : NSObject

/**
 * @brief Gets the unassigned user list.
 * @return The unassigned user list.
 */
- (NSArray * _Nullable)getUnassignedUserList;

/**
 * @brief Gets all breakout meeting ID list.
 * @return The breakout meeting ID list.
 */
- (NSArray * _Nullable)getBOMeetingIDList;

/**
 * @brief Gets the breakout room user object by breakout room user ID.
 * @param userId The user ID.
 * @return If the function succeeds, it returns a MobileRTCBOUser object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCBOUser * _Nullable)getBOUserByUserID:(NSString * _Nonnull)userId;

/**
 * @brief Gets the breakout meeting object by breakout meeting ID.
 * @param boId The breakout room ID.
 * @return If the function succeeds, it returns a MobileRTCBOMeeting object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCBOMeeting * _Nullable)getBOMeetingByID:(NSString * _Nonnull)boId;

/**
 * @brief Gets the breakout meeting name of the current breakout room.
 * @return The current breakout room name.
 */
- (NSString * _Nullable)getCurrentBOName;

/**
 * @brief Determines whether the breakout room user ID is the current user.
 * @param boUserId The breakout room user ID.
 * @return YES if the breakout room user ID is the current user. Otherwise, NO.
 */
- (BOOL)isBOUserMyself:(NSString *_Nonnull)boUserId;

@end


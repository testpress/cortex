/**
 * @file MobileRTCMeetingService+Audio.h
 * @brief Meeting+Audio service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

/**
 * @brief Audio of MobileRTCMeetingService
 */
@interface MobileRTCMeetingService (Audio)

/**
 * @brief Gets the in-meeting audio type of the current user.
 * @return The audio type.
 */
- (MobileRTCAudioType)myAudioType;


/**
 * @brief Determines whether the meeting has third party telephony audio enabled.
 * @return YES if third party telephony audio is enabled. Otherwise, NO.
 */
 - (BOOL)is3rdPartyTelephonyAudioOn;

/**
 * @brief Sets whether to connect the audio in the meeting.
 * @param on YES to connect, NO to disconnect.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)connectMyAudio:(BOOL)on;

/**
 * @brief Gets the audio output type of the current user.
 * @return The descriptions of audio output types.
 */
- (MobileRTCAudioOutput)myAudioOutputDescription;

/**
 * @brief Determines whether the audio of the current user is muted.
 * @return YES if the audio is muted. Otherwise, NO.
 */
- (BOOL)isMyAudioMuted;

/**
 * @brief Determines whether the user can unmute audio.
 * @return YES if the user can unmute audio. Otherwise, NO.
 */
- (BOOL)canUnmuteMyAudio;

/**
 * @brief Determines whether the host or cohost can enable mute on entry.
 * @return YES if the host or cohost can enable mute on entry. Otherwise, NO.
 * @note Valid for both ZOOM style and user custom interface mode.
 */
- (BOOL)canEnableMuteOnEntry;
/**
 * @brief Enables or disables mute on entry for users after joining the meeting.
 * @param bEnable YES to mute the user after joining the meeting, NO otherwise.
 * @param allowUnmuteBySelf YES to allow users to unmute themselves, NO otherwise.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @note Valid for both ZOOM style and user custom interface mode.
 */
- (MobileRTCSDKError)enableMuteOnEntry:(BOOL)bEnable allowUnmuteBySelf:(BOOL)allowUnmuteBySelf;

/**
 * @brief Determines whether mute on entry is enabled for attendees when they join the meeting.
 * @return YES if mute on entry is enabled. Otherwise, NO.
 */
- (BOOL)isMuteOnEntryOn;

/**
 * @brief Determines whether the user's audio is muted.
 * @param userID The user's ID to be checked.
 * @return YES if the user's audio is muted. Otherwise, NO.
 */
- (BOOL)isUserAudioMuted:(NSUInteger)userID;

/**
 * @brief Mutes or unmutes the user's audio.
 * @param mute YES to mute, NO to unmute.
 * @param userID The user's ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host can run the function.
 */
- (BOOL)muteUserAudio:(BOOL)mute withUID:(NSUInteger)userID;

/**
 * @brief Mutes audio of all attendees.
 * @param allowSelfUnmute YES to allow attendees to unmute audio themselves, NO otherwise.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function.
 */
- (BOOL)muteAllUserAudio:(BOOL)allowSelfUnmute;

/**
 * @brief Asks all attendees to unmute audio.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function.
 */
- (BOOL)askAllToUnmute;

/**
 * @brief Determines whether the meeting supports VoIP.
 * @return YES if the meeting supports VoIP. Otherwise, NO.
 */
- (BOOL)isSupportedVOIP;

/**
 * @brief Determines whether chime is enabled when user joins or leaves meeting.
 * @return YES if chime is enabled. Otherwise, NO.
 */
- (BOOL)isPlayChimeOn;

/**
 * @brief Sets whether chime is enabled when the user joins or leaves meeting.
 * @param on YES to enable chime, NO to disable.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or cohost can run the function when in meeting.
 */
- (BOOL)playChime:(BOOL)on;

/**
 * @brief Mutes or unmutes the audio of the current user.
 * @param mute YES to mute, NO to unmute.
 * @return If the function succeeds, it returns MobileRTCAudioError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCAudioError)muteMyAudio:(BOOL)mute;

/**
 * @brief Switches the audio output between receiver and speaker.
 * @return If the function succeeds, it returns MobileRTCAudioError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCAudioError)switchMyAudioSource;

/**
 * @brief Resets the meeting audio session including category and mode.
 */
- (void)resetMeetingAudioSession;

/**
 * @brief Resets the meeting audio session including category and mode. When the call comes in or goes out, click hold or swap in the dial-up UI to restore the zoom sound.
 */
- (void)resetMeetingAudioForCallKitHeld;

/**
 * @brief Determines whether the incoming audio is stopped.
 * @return YES if the incoming audio is stopped. Otherwise, NO.
 */
- (BOOL)isIncomingAudioStopped;

/**
 * @brief Stops or resumes the incoming audio.
 * @param enabled YES to stop incoming audio, NO to resume.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)stopIncomingAudio:(BOOL)enabled;

/**
 * @brief Gets the audio type supported by the current meeting.
 * @return If the function succeeds, it will return the type. The value is the 'bitwise OR' of each supported audio type.
 */
- (NSInteger)getSupportedMeetingAudioType;

/**
 * @brief Enables or disables SDK to play meeting audio. When the value of enabled is NO, the SDK will not play meeting audio, but you can still subscribe audio rawdata.
 * @param enabled YES to enable SDK to play meeting audio, NO to disable.
 * @return If the function succeeds, it will return MobileRTCRawDataError_Success. Otherwise return an error.
 */
- (MobileRTCRawDataError)enablePlayMeetingAudio:(BOOL)enabled;

/**
 * @brief Determines whether play meeting audio is enabled.
 * @return YES if play meeting audio is enabled. Otherwise, NO.
 */
- (BOOL)isPlayMeetingAudioEnabled;

@end

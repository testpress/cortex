/**
 * @file MobileRTCMeetingService+LiveTranscription.h
 * @brief Meeting+LiveTranscription service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>
#import <MobileRTC/MobileRTCLiveTranscriptionLanguage.h>

/**
 * @class MobileRTCLiveTranscriptionMessageInfo
 * @brief Interface representing a live transcription message.
 */
@interface MobileRTCLiveTranscriptionMessageInfo : NSObject
/**
 * @brief The message ID of the transcription message.
 */
@property (nonatomic, copy)NSString * _Nonnull messageID;
/**
 * @brief The speaker ID of the transcription message.
 */
@property (nonatomic, assign)NSInteger speakerID;
/**
 * @brief The speaker name of the transcription message.
 */
@property (nonatomic, copy)NSString * _Nullable speakerName;
/**
 * @brief The message content of the transcription message.
 */
@property (nonatomic, copy)NSString * _Nullable messageContent;
/**
 * @brief The timestamp of the transcription message.
 */
@property (nonatomic, assign)NSInteger timeStamp;
/**
 * @brief The message type of the transcription message.
 */
@property (nonatomic, assign)MobileRTCLiveTranscriptionOperationType messageType;

@end

/**
 * @class MobileRTCCaptionsControlHandler
 * @brief The helper to handle the requested of start captions.
 * @note When isRequestTranslationOn is YES, use \link MobileRTCCaptionsControlOnHandler::approveStartCaptionsRequest \endlink to approve start captions request.
 * @note When isRequestTranslationOn is NO,  use \link MobileRTCCaptionsControlOnHandler::approveStartCaptionsRequest: \endlink to approve start captions request.
 */
@interface MobileRTCCaptionsControlHandler : NSObject
/**
 * @brief Denies the start captions request and then self-destroys.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
-(MobileRTCSDKError)deny;

/**
 * @brief Gets the sender user ID.
 * @return The user ID of the user who sent the request to start captions.
 */
-(NSUInteger)getSenderUserId;

/**
 * @brief Determines if the request is to start captions with translation on.
 * @return YES if the request is to start captions with translation on. Otherwise, NO.
 */
-(BOOL)isRequestTranslationOn;

@end

/**
 * @class MobileRTCCaptionsControlOnHandler
 * @brief Subclass of MobileRTCCaptionsControlHandler for requests with translation enabled.
 */
@interface MobileRTCCaptionsControlOnHandler : MobileRTCCaptionsControlHandler
/**
 * @brief Approves the start captions request and then self-destroys.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
-(MobileRTCSDKError)approveStartCaptionsRequest;

@end


/**
 * @class MobileRTCCaptionsControlOffHandler
 * @brief Subclass of MobileRTCCaptionsControlHandler for requests without translation.
 */
@interface MobileRTCCaptionsControlOffHandler : MobileRTCCaptionsControlHandler
/**
 * @brief Approves the start captions request and then self-destroys.
 * @param languageId The language to be set for all participants in the meeting.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
-(MobileRTCSDKError)approveStartCaptionsRequest:(NSInteger)languageId;
@end

/**
 * @brief Interface to manage closed captions and live transcription in meetings.
 */
@interface MobileRTCMeetingService (LiveTranscription)

/**
 * @brief Queries if the current meeting supports closed caption.
 * @return YES if the current meeting supports closed caption. Otherwise, NO.
 */
- (BOOL)isMeetingSupportCC;

/**
 * @brief Queries if the user can disable captions.
 * @return YES if the host can disable captions. Otherwise, NO.
 */
- (BOOL)canDisableCaptions;

/**
 * @brief Enables or disables captions.
 * @param bEnable YES to enable captions. Otherwise, NO to disable.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)enableCaptions:(BOOL)bEnable;

/**
 * @brief Queries if captions are enabled.
 * @return YES if captions are enabled. Otherwise, NO.
 */
- (BOOL)isCaptionsEnabled;

/**
 * @brief Determines whether users can request to start captions.
 * @return YES if users can request to start captions. Otherwise, NO.
 */
- (BOOL)isSupportRequestCaptions;

/**
 * @brief Requests the host to start captions. If the host approves your request, you receive the callback \link MobileRTCMeetingServiceDelegate::onStartCaptionsRequestApproved \endlink, and you should start captions or translation there.
 * @param enableTranslation YES to enable translation at the same time. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)requestToStartCaptions:(BOOL)enableTranslation;

/**
 * @brief Determines if translation is available when users request to start captions.
 * @return YES if translation is available when users request to start captions. Otherwise, NO.
 */
- (BOOL)isSupportTranslationWhenRequestToStartCaptions;

/**
 * @brief Queries if the user can be assigned to send closed caption.
 * @param userId The user ID.
 * @return YES if the user can be assigned to send closed caption. Otherwise, NO.
 */
- (BOOL)canBeAssignedToSendCC:(NSUInteger)userId;

/**
 * @brief Assigns the user privilege to send closed caption.
 * @param userId The user ID.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)assignCCPrivilege:(NSUInteger)userId;

/**
 * @brief Withdraws the user privilege to send closed caption.
 * @param userId The user ID.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)withdrawCCPrivilege:(NSUInteger)userId;

/**
 * @brief Queries if the current user can assign the privilege of sending closed caption to others.
 * @return YES if the user can assign others privilege to send closed caption. Otherwise, NO.
 */
- (BOOL)canAssignOthersToSendCC;

/**
 * @brief Hosts only API to set meeting language for the entire meeting.
 * @param bEnable YES to enable. Otherwise, NO.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)enableMeetingManualCaption:(BOOL)bEnable;
/**
 * @brief Determines whether it is enabled to manually input CC for the meeting.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)isMeetingManualCaptionEnabled;

/**
 * @brief Queries if this meeting supports the live transcription feature.
 * @return YES if the live transcription feature is supported. Otherwise, NO.
 */
- (BOOL)isLiveTranscriptionFeatureEnabled;

/**
 * @brief Gets the current live transcription status.
 * @return The live transcription status. For more details, see MobileRTCLiveTranscriptionStatus.
 */
- (MobileRTCLiveTranscriptionStatus)getLiveTranscriptionStatus;

/**
 * @brief Queries if meeting participants can start live transcription.
 * @return YES if the participant can start live transcription. Otherwise, NO.
 */
- (BOOL)canStartLiveTranscription;

/**
 * @brief Starts live transcription. If the meeting enables multi-language transcription, all users can start live transcription. Otherwise, only the host can start.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)startLiveTranscription;

/**
 * @brief Stops live transcription. If the meeting enables multi-language transcription, all users can stop live transcription. Otherwise, only the host can stop.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)stopLiveTranscription;

/**
 * @brief The host enables or disables the request live transcription.
 * @param enable YES to enable the request live transcription. Otherwise, NO to disable.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)enableRequestLiveTranscription:(BOOL)enable;

/**
 * @brief Queries if it is enabled to request to start live transcription.
 * @return YES if it is enabled to request to start live transcription. Otherwise, NO.
 */
- (BOOL)isRequestToStartLiveTranscriptionEnabled;

/**
 * @brief Requests the host to start live transcription.
 * @param requestAnonymous YES if it is anonymous to request the host to start live transcription. Otherwise, NO.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)requestToStartLiveTranscription:(BOOL)requestAnonymous;

/**
 * @brief Determines whether the multi-language transcription feature is enabled.
 * @return YES if multi-language transcription is enabled. Otherwise, NO.
 */
- (BOOL)isMultiLanguageTranscriptionEnabled;

/**
 * @brief Determines whether the translated captions feature is enabled.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)isTextLiveTranslationEnabled;

/**
 * @brief Enables or disables receiving original and translated content. If you enable this feature, you need to start live transcription.
 * @param enabled YES to enable. Otherwise, NO to disable.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)enableReceiveSpokenlLanguageContent:(BOOL)enabled;

/**
 * @brief Determines whether receiving original and translated content is available.
 * @return YES if receiving original and translated content is available. Otherwise, NO.
 */
- (BOOL)isReceiveSpokenLanguageContentEnabled;

/**
 * @brief Gets the list of all available spoken languages in the meeting.
 * @return If the function succeeds, it returns an NSArray of MobileRTCLiveTranscriptionLanguage objects. Otherwise, this function fails and returns nil.
 */
- (NSArray<MobileRTCLiveTranscriptionLanguage*>* _Nullable)getAvailableMeetingSpokenLanguages;

/**
 * @brief Sets the spoken language of the current user.
 * @param languageID The spoken language ID.
 * @return YES if the function succeeds. Otherwise, NO.
 * @deprecated Use \link setMeetingSpokenLanguage:isForAll: \endlink instead.
 */
- (BOOL)setMeetingSpokenLanguage:(NSInteger)languageID DEPRECATED_MSG_ATTRIBUTE("Use setMeetingSpokenLanguage:isForAll: instead");

/**
 * @brief Sets the current user's spoken language.
 * @param languageID The spoken language ID.
 * @param isForAll YES to set spoken language for all users. Otherwise, NO to set only for myself.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)setMeetingSpokenLanguage:(NSInteger)languageID isForAll:(BOOL)isForAll;

/**
 * @brief Gets the spoken language of the current user.
 * @return If the function succeeds, it returns a MobileRTCLiveTranscriptionLanguage object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCLiveTranscriptionLanguage *_Nullable)getMeetingSpokenLanguage;

/**
 * @brief Gets the list of all available translation languages in the meeting.
 * @return If the function succeeds, it returns an NSArray of MobileRTCLiveTranscriptionLanguage objects. Otherwise, this function fails and returns nil.
 */
- (NSArray<MobileRTCLiveTranscriptionLanguage*>* _Nullable)getAvailableTranslationLanguages;

/**
 * @brief Sets the translation language of the current user.
 * @param languageID The translation language ID. If the language ID is set to -1, live translation is disabled. Then you can receive closed caption when the host sets meeting manual caption to YES.
 * @return YES if the function succeeds. Otherwise, NO.
 * @note If you call this method before calling startLiveTranscription, it will trigger the onSinkLiveTranscriptionStatus: callback when the translation status changes. If translation is already enabled, calling this method again will not trigger the onSinkLiveTranscriptionStatus: callback.
 */
- (BOOL)setTranslationLanguage:(NSInteger)languageID;

/**
 * @brief Gets the translation language of the current user.
 * @return If the function succeeds, it returns a MobileRTCLiveTranscriptionLanguage object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCLiveTranscriptionLanguage *_Nullable)getTranslationLanguage;

@end


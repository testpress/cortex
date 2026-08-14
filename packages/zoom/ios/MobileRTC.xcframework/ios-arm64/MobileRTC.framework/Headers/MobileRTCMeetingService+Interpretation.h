/**
 * @file MobileRTCMeetingService+Interpretation.h
 * @brief Meeting+Interpretation service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

/**
 * @class MobileRTCInterpretationLanguage
 * @brief The information of interpretation language.
 */
@interface MobileRTCInterpretationLanguage : NSObject
/**
 * @brief Gets the language ID.
 * @return The language ID.
 */
- (NSInteger)getLanguageID;
/**
 * @brief Gets the language alias (abbreviation).
 * @return A string representing the language abbreviation (e.g., "EN", "CN").
 */
- (NSString * _Nullable)getLanguageAbbreviations;
/**
 * @brief Gets the language name.
 * @return A string representing the full language name (e.g., "English", "Chinese").
 */
- (NSString * _Nullable)getLanguageName;
@end

/**
 * @class MobileRTCMeetingInterpreter
 * @brief The information of interpreter.
 */
@interface MobileRTCMeetingInterpreter : NSObject
/**
 * @brief Gets the interpreter's user ID.
 * @return The user ID of the interpreter.
 */
- (NSInteger)getUserID;
/**
 * @brief Gets the interpreter's first supported language ID.
 * @return The language ID.
 */
- (NSInteger)getLanguageID1;
/**
 * @brief Gets the interpreter's second supported language ID.
 * @return The language ID.
 */
- (NSInteger)getLanguageID2;
/**
 * @brief Determines if currently available in the meeting.
 * @return YES if the interpreter is available and has joined the meeting. Otherwise, NO.
 */
- (BOOL)isAvailable;

@end

/**
 * @brief Interface for managing interpretation in a Zoom meeting.
 */
@interface MobileRTCMeetingService (Interpretation)

//Common (for all)

/**
 * @brief Determines if the interpretation feature is enabled in the meeting.
 * @return YES if the interpretation function is enabled. Otherwise, NO.
 */
- (BOOL)isInterpretationEnabled;

/**
 * @brief Determines if interpretation has been started by the host.
 * @return YES if interpretation is started. Otherwise, NO.
 */
- (BOOL)isInterpretationStarted;

/**
 * @brief Determines if myself is an interpreter.
 * @return YES if self is an interpreter. Otherwise, NO.
 */
- (BOOL)isInterpreter;

/**
 * @brief Gets the interpretation language object of the specified language ID.
 * @param lanID The language ID for which you want to get the information.
 * @return If the function succeeds, it returns a MobileRTCInterpretationLanguage object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCInterpretationLanguage * _Nullable)getInterpretationLanguageByID:(NSInteger)lanID;

//Admin (only for host)

/**
 * @brief Gets all interpretation language list.
 * @return If the function succeeds, it returns an NSArray of MobileRTCInterpretationLanguage objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCInterpretationLanguage *> * _Nullable)getAllLanguageList;

/**
 * @brief Gets the interpreters list.
 * @return If the function succeeds, it returns an NSArray of MobileRTCMeetingInterpreter objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCMeetingInterpreter *> * _Nullable)getInterpreterList;

/**
 * @brief Adds someone as an interpreter.
 * @param userID The user ID.
 * @param lanID1 The first language ID.
 * @param lanID2 The second language ID.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)addInterpreter:(NSUInteger)userID lan1:(NSInteger)lanID1 andLan2:(NSInteger)lanID2;

/**
 * @brief Removes an interpreter.
 * @param userID The interpreter user ID.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)removeInterpreter:(NSUInteger)userID;

/**
 * @brief Modifies the language of an interpreter.
 * @param userID The interpreter user ID.
 * @param lanID1 The new first language ID.
 * @param lanID2 The new second language ID.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)modifyInterpreter:(NSUInteger)userID lan1:(NSInteger)lanID1 andLan2:(NSInteger)lanID2;

/**
 * @brief Starts interpretation.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)startInterpretation;

/**
 * @brief Stops interpretation.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)stopInterpretation;

//Listener (for non interpreter)

/**
 * @brief Gets the available interpretation language list.
 * @return If the function succeeds, it returns an NSArray of MobileRTCInterpretationLanguage objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCInterpretationLanguage *> * _Nullable)getAvailableLanguageList;

/**
 * @brief Joins a language channel.
 * @param lanID The language channel ID.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)joinLanguageChannel:(NSInteger)lanID;

/**
 * @brief Gets the language ID which myself is in.
 * @return The language ID.
 */
- (NSInteger)getJoinedLanguageID;

/**
 * @brief Turns off the major audio if you are in some interpreter language channel.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)turnOffMajorAudio;

/**
 * @brief Turns on the major audio if you are in some interpreter language channel.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)turnOnMajorAudio;

/**
 * @brief Determines if the major audio is off.
 * @return YES if the major audio is off. Otherwise, NO.
 */
- (BOOL)isMajorAudioTurnOff;

//interpreter (only for interpreter)

/**
 * @brief Gets languages if myself is an interpreter.
 * @return If the function succeeds, it returns an NSArray of MobileRTCInterpretationLanguage objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCInterpretationLanguage *> * _Nullable)getInterpreterLans;

/**
 * @brief Sets a language channel which myself will be in, if myself is an interpreter.
 * @param activeLanID The active language ID.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)setInterpreterActiveLan:(NSInteger)activeLanID;

/**
 * @brief Gets the active language ID, if myself is an interpreter.
 * @return The active language ID.
 */
- (NSInteger)getInterpreterActiveLan;

/**
 * @brief Gets the list of available languages that interpreters can hear.
 * @return If the function succeeds, it returns an NSArray of MobileRTCInterpretationLanguage objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCInterpretationLanguage *> * _Nullable)getInterpreterAvailableLanguages;

/**
 * @brief Sets a language that I can hear as an interpreter.
 * @param lanID The selected language ID that I can hear as an interpreter.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)setInterpreterListenLan:(NSInteger)lanID;

/**
 * @brief Gets a language that I can hear as an interpreter.
 * @return Specify the selected language that I can hear as an interpreter.Otherwise failed, the return value is -1.
 */
- (NSInteger)getInterpreterListenLan;

@end

#pragma mark  MobileRTCSignInterpreter

/**
 * @class MobileRTCSignInterpreterLanguage
 * @brief Represent interpretation language information.
 */
@interface  MobileRTCSignInterpreterLanguage : NSObject

/**
 * @brief The sign language name.
 */
@property (copy, nonatomic, nullable) NSString *  languageName;
/**
 * @brief The sign language ID.
 */
@property (copy, nonatomic, nullable) NSString *  languageID;

@end

/**
 * @class MobileRTCSignInterpreter
 * @brief Object of interpreter.
 */
@interface  MobileRTCSignInterpreter : NSObject
/**
 * @brief The user ID.
 */
@property (assign, nonatomic)           NSUInteger userID;
/**
 * @brief YES if the sign interpreter is available. Otherwise, NO.
 */
@property (assign, nonatomic)           BOOL available;
/**
 * @brief The sign user name.
 */
@property (copy, nonatomic, nullable)    NSString *  userName;
/**
 * @brief The sign email.
 */
@property (copy, nonatomic, nullable)    NSString *  email;
/**
 * @brief The sign language name.
 */
@property (copy, nonatomic, nullable)    NSString *  languageName;
/**
 * @brief The language ID of the sign interpreter support.
 */
@property (copy, nonatomic, nullable)    NSString *  languageID;

@end


/**
 * @brief Manage sign interpretation status, interpreters, and available languages in a Zoom meeting.
 */
@interface MobileRTCMeetingService (SignInterpreter)

/**
 * @brief Determines if the sign interpretation function is enabled.
 * @return YES if the sign interpretation function is enabled. Otherwise, NO.
 */
- (BOOL)isSignInterpretationEnabled;

/**
 * @brief Gets the sign interpretation status of the current meeting.
 * @return The sign interpretation status of the current meeting.
 */
- (MobileRTCSignInterpretationStatus)getSignInterpretationStatus;

/**
 * @brief Determines if self is a sign interpreter.
 * @return YES if self is a sign interpreter. Otherwise, NO.
 */
- (BOOL)isSignInterpreter;

/**
 * @brief Gets the sign interpretation language object of the specified sign language ID.
 * @param signLanguageID The sign language ID for which you want to get the information.
 * @return If the function succeeds, it returns a MobileRTCSignInterpreterLanguage object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCSignInterpreterLanguage *_Nullable)getSignInterpretationLanguageInfoByID:(NSString *_Nullable)signLanguageID;

/**
 * @brief Gets the available sign interpretation language list.
 * @return If the function succeeds, it returns an NSArray of MobileRTCSignInterpreterLanguage objects. Otherwise, this function fails and returns nil.
 */
- (NSArray<MobileRTCSignInterpreterLanguage *> *_Nullable)getAvailableSignLanguageInfoList;

/**
 * @brief Gets all supported sign interpretation language list. Only for host.
 * @return If the function succeeds, it returns an NSArray of MobileRTCSignInterpreterLanguage objects. Otherwise, this function fails and returns nil.
 * @warning The interface is for host only.
 */
- (NSArray<MobileRTCSignInterpreterLanguage *> *_Nullable)getAllSupportedSignLanguageInfoList;

/**
 * @brief Gets the sign interpreters list.
 * @return If the function succeeds, it returns an NSArray of MobileRTCSignInterpreter objects. Otherwise, this function fails and returns nil.
 */
- (NSArray<MobileRTCSignInterpreter *> *_Nullable)getSignInterpreterList;

/**
 * @brief Adds someone as a sign interpreter.
 * @param userID The unique identity of the user.
 * @param signLanID The ID of sign language.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning The interface is for host only.
 */
- (MobileRTCSDKError)addSignInterpreter:(NSUInteger)userID signLanId:(NSString *_Nullable)signLanID;

/**
 * @brief Removes an interpreter.
 * @param userID The unique identity of the user.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning The interface is for host only.
 */
- (MobileRTCSDKError)removeSignInterpreter:(NSUInteger)userID;

/**
 * @brief Modifies the language of a sign interpreter.
 * @param userID The unique identity of the user.
 * @param signLanID The ID of sign language.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning The interface is for host only.
 */
- (MobileRTCSDKError)modifySignInterpreter:(NSUInteger)userID signLanId:(NSString *_Nullable)signLanID;

/**
 * @brief Determines if I can start the sign interpretation in the meeting.
 * @return YES if I can start the sign interpretation in the meeting. Otherwise, NO.
 * @warning The interface is for host only.
 */
- (BOOL)canStartSignInterpretation;

/**
 * @brief Starts sign interpretation.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning The interface is for host only.
 */
- (MobileRTCSDKError)startSignInterpretation;

/**
 * @brief Stops sign interpretation.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning The interface is for host only.
 */
- (MobileRTCSDKError)stopSignInterpretation;

/**
 * @brief The host allows or disallows sign language interpreter to talk.
 * @param userID The unique identity of the user.
 * @param allowToTalk YES to allow to talk. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)requestSignLanuageInterpreterToTalk:(NSUInteger)userID allowToTalk:(BOOL)allowToTalk;

/**
 * @brief Determines if the sign language interpreter is allowed to talk.
 * @param userID The unique identity of the user.
 * @return YES if allowed to talk. Otherwise, NO.
 */
- (BOOL)isAllowSignLanuageInterpreterToTalk:(NSUInteger)userID;

/**
 * @brief Gets sign language ID if myself is a sign interpreter. Only for interpreter.
 * @return The current assigned sign language ID.
 */
- (NSString *_Nullable)getSignInterpreterAssignedLanID;

/**
 * @brief Joins a sign language channel if myself is not a sign interpreter. Only for non-interpreter.
 * @param signLanID The sign language ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning The interface is only for Zoom UI.
 */
- (MobileRTCSDKError)joinSignLanguageChannel:(NSString *_Nullable)signLanID;

/**
 * @brief Leaves the current sign language channel if myself is not a sign interpreter. Only for non-interpreter.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning The interface is only for Zoom UI.
 */
- (MobileRTCSDKError)leaveSignLanguageChannel;
@end


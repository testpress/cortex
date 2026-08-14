/**
 * @file MobileRTCMeetingService+Polling.h
 * @brief Meeting+Polling service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>


/**
 * @class MobileRTCPollingItem
 * @brief Polling item interface.
 */
@interface MobileRTCPollingItem : NSObject
/**
 * @brief Gets the polling ID.
 * @return The polling ID.
 */
- (NSString *_Nullable)getPollingID;
/**
 * @brief Gets the polling name.
 * @return The polling name.
 */
- (NSString *_Nullable)getPollingName;
/**
 * @brief Gets the polling type.
 * @return The polling type.
 */
- (MobileRTCPollingType)getPollingType;
/**
 * @brief Gets the polling status.
 * @return The polling status.
 */
- (MobileRTCPollingStatus)getPollingStatus;
/**
 * @brief Gets the polling question count.
 * @return The polling question count.
 */
- (NSInteger)getPollingQuestionCount;
/**
 * @brief Gets the count of total voted users.
 * @return The total voted user count.
 */
- (NSInteger)getTotalVotedUserCount;
/**
 * @brief Determines if it is library polling.
 * @return YES if it is library polling. Otherwise, NO.
 * @note This function is only available for the library polling.
 */
- (BOOL)isLibraryPolling;
@end

/**
 * @class MobileRTCPollingAnswerItem
 * @brief Polling answer item interface.
 */
@interface MobileRTCPollingAnswerItem : NSObject
/**
 * @brief Gets the polling ID of the answer item.
 * @return The polling ID.
 */
- (NSString *_Nullable)getPollingID;
/**
 * @brief Gets the polling question ID.
 * @return The polling question ID.
 */
- (NSString *_Nullable)getPollingQuestionID;
/**
 * @brief Gets the polling sub-question ID.
 * @return The polling sub-question ID.
 */
- (NSString *_Nullable)getPollingSubQuestionID;
/**
 * @brief Gets the polling answer ID.
 * @return The polling answer ID.
 */
- (NSString *_Nullable)getPollingAnswerID;
/**
 * @brief Gets the polling answer name.
 * @return The polling answer name.
 */
- (NSString *_Nullable)getPollingAnswerName;
/**
 * @brief Gets the polling answered content.
 * @return The polling answered content.
 */
- (NSString *_Nullable)getPollingAnsweredContent;
/**
 * @brief Determines if it is checked.
 * @return YES if checked. Otherwise, NO.
 * @note This property has no meaning for the correct answer.
 */
- (BOOL)isChecked;
@end

/**
 * @class MobileRTCPollingQuestionItem
 * @brief Polling question item interface.
 */
@interface MobileRTCPollingQuestionItem : NSObject
/**
 * @brief Gets the polling ID of the question item.
 * @return The polling ID.
 */
- (NSString *_Nullable)getPollingID;
/**
 * @brief Gets the polling question ID.
 * @return The polling question ID.
 */
- (NSString *_Nullable)getPollingQuestionID;
/**
 * @brief Gets the polling question name.
 * @return The polling question name.
 */
- (NSString *_Nullable)getPollingQuestionName;
/**
 * @brief Gets the polling question type.
 * @return The polling question type.
 */
- (MobileRTCPollingQuestionType)getPollingQuestionType;
/**
 * @brief Gets the count of answered questions.
 * @return The count of answered questions.
 */
- (NSInteger)getAnsweredCount;
/**
 * @brief Determines if it is required.
 * @return YES if required. Otherwise, NO.
 */
- (BOOL)isRequired;
/**
 * @brief Gets the list of polling question's subquestion.
 * @return If the function succeeds, it returns an NSArray of MobileRTCPollingQuestionItem objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCPollingQuestionItem *> * _Nullable)getPollingSubQuestionItemList;
/**
 * @brief Gets the list of polling question or subquestion's answer.
 * @return If the function succeeds, it returns an NSArray of MobileRTCPollingAnswerItem objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCPollingAnswerItem *> * _Nullable)getPollingAnswerItemList;
@end

/**
 * @class MobileRTCPollingAnswerResultItem
 * @brief Polling answer result item interface.
 */
@interface MobileRTCPollingAnswerResultItem : NSObject
/**
 * @brief Gets the polling ID of the answer result item.
 * @return The polling ID.
 */
- (NSString *_Nullable)getPollingID;
/**
 * @brief Gets the polling question ID.
 * @return The polling question ID.
 */
- (NSString *_Nullable)getPollingQuestionID;
/**
 * @brief Gets the polling sub-question ID.
 * @return The polling sub-question ID.
 */
- (NSString *_Nullable)getPollingSubQuestionID;
/**
 * @brief Gets the polling answer ID.
 * @return The polling answer ID.
 */
- (NSString *_Nullable)getPollingAnswerID;
/**
 * @brief Gets the polling answer name.
 * @return The polling answer name.
 */
- (NSString *_Nullable)getPollingAnswerName;
/**
 * @brief Queries how many participants selected this answer.
 * @return The selected count.
 */
- (NSInteger)getSelectedCount;
@end


/**
 * @brief Polling  feature of meeting service.
 */
@interface MobileRTCMeetingService (Polling)

#pragma mark - for all users -
/**
 * @brief Determines whether the current meeting can do polling.
 * @return YES if you can do polling. Otherwise, NO.
 */
- (BOOL)canDoPolling;

/**
 * @brief Gets the active poll's ID.
 * @return The shared result or started poll's ID.
 */
- (NSString *_Nullable)getActivePollingID;

/**
 * @brief Gets the list of polling question's subquestion.
 * @param pollingID The question's polling ID.
 * @return If the function succeeds, it returns an NSArray of MobileRTCPollingQuestionItem objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCPollingQuestionItem *> * _Nullable)getPollingQuestionItemList:(NSString *_Nullable)pollingID;

/**
 * @brief Determines if the right answer item list can be allowed to get.
 * @param pollingID The right answer's polling ID.
 * @return YES if can get the right. Otherwise, NO.
 */
- (BOOL)canGetRightAnswerItemList:(NSString *_Nullable)pollingID;

/**
 * @brief Gets the list of polling question or subquestion's right answer.
 * @param pollingID The right answer's polling ID.
 * @return If the function succeeds, it returns an NSArray of MobileRTCPollingAnswerItem objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCPollingAnswerItem *> * _Nullable)getPollingRightAnswerItemList:(NSString *_Nullable)pollingID;

/**
 * @brief Determines if the answer result list can be shown.
 * @param pollingID The right answer's polling ID.
 * @return YES if can show the answer list. Otherwise, NO.
 */
- (BOOL)canShowAnswerResultList:(NSString *_Nullable)pollingID;

/**
 * @brief Gets the list of polling answer result items.
 * @param pollingID The right answer's polling ID.
 * @return If the function succeeds, it returns an NSArray of MobileRTCPollingAnswerResultItem objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCPollingAnswerResultItem *> * _Nullable)getPollingAnswerResultItemList:(NSString *_Nullable)pollingID;

/**
 * @brief Gets the polling item object of the specified polling ID.
 * @param pollingID The polling ID for which you want to get the information.
 * @return If the function succeeds, it returns a MobileRTCPollingItem object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCPollingItem * _Nullable)getPollingItemByID:(NSString *_Nullable)pollingID;

/**
 * @brief Gets the polling question's image path.
 * @param pollingID The answer's polling ID.
 * @param questionID The answer's question ID.
 * @return The question's image path.
 */
- (NSString *_Nullable)getPollingQuestionImagePath:(NSString *_Nullable)pollingID questionID:(NSString *_Nullable)questionID;

/**
 * @brief Gets the polling question's minimum length.
 * @param pollingID The poll's polling ID.
 * @param questionID The question's question ID.
 * @return The integer value of the question's minimum length.
 */
- (NSInteger)getQuestionCharactersMinLen:(NSString*_Nullable)pollingID questionID:(NSString*_Nullable)questionID;

/**
 * @brief Gets the polling question's maximum length.
 * @param pollingID The poll's polling ID.
 * @param questionID The question's question ID.
 * @return The integer value of the question's maximum length.
 */
- (NSInteger)getQuestionCharactersMaxLen:(NSString*_Nullable)pollingID questionID:(NSString*_Nullable)questionID;

/**
 * @brief Determines if the question is case sensitive.
 * @param pollingID The question's polling ID.
 * @param questionID The question's question ID.
 * @return YES if case sensitive. Otherwise, NO. This function can only be used by fill blank questions.
 */
- (BOOL)isQuestionCaseSensitive:(NSString *_Nullable)pollingID questionID:(NSString *_Nullable)questionID;

#pragma mark - for host -

/**
 * @brief Determines if the host can add polling.
 * @return YES if the host can add polling. Otherwise, NO.
 * @warning Only the origin host can add polling.
 */
- (BOOL)canAddPolling;

/**
 * @brief Creates polling in a web browser.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)addPolling;

/**
 * @brief Determines if the host can edit polling.
 * @param pollingID The edit poll's polling ID.
 * @return YES if can edit. Otherwise, NO.
 * @warning Only the origin host can edit polling.
 */
- (BOOL)canEditPolling:(NSString *_Nullable)pollingID;

/**
 * @brief Opens edit polling in a web browser.
 * @param pollingID The edit poll's polling ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)editPolling:(NSString *_Nullable)pollingID;

/**
 * @brief Determines if the host can delete polling.
 * @param pollingID The edit poll's polling ID.
 * @return YES if can delete the polling. Otherwise, NO.
 * @warning Only the origin host can delete polling.
 */
- (BOOL)canDeletePolling:(NSString *_Nullable)pollingID;

/**
 * @brief Deletes the polling.
 * @param pollingID The edit poll's polling ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)deletePolling:(NSString *_Nullable)pollingID;

/**
 * @brief Determines if the host can duplicate polling.
 * @param pollingID The duplicate poll's polling ID.
 * @return YES if can duplicate the polling. Otherwise, NO.
 * @warning Only the origin host can duplicate polling.
 */
- (BOOL)canDuplicatePolling:(NSString *_Nullable)pollingID;

/**
 * @brief Duplicates the polling.
 * @param pollingID The edit poll's polling ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)duplicatePolling:(NSString *_Nullable)pollingID;

/**
 * @brief Determines if the user can view polling results in the browser.
 * @param pollingID The duplicate poll's polling ID.
 * @return YES if can view the polling result. Otherwise, NO.
 */
- (BOOL)canViewPollingResultFromBrowser:(NSString *_Nullable)pollingID;

/**
 * @brief Opens a polling result in the web browser.
 * @param pollingID The edit poll's polling ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)viewPollingResultFromBrowser:(NSString *_Nullable)pollingID;

/**
 * @brief Gets the list of poll items.
 * @return If the function succeeds, it returns an NSArray of MobileRTCPollingItem objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCPollingItem *> * _Nullable)getPollingItemList;

/**
 * @brief Determines if the host or co-host can start the polling.
 * @param pollingID The poll's polling ID.
 * @return YES if can start the poll. Otherwise, NO.
 */
- (BOOL)canStartPolling:(NSString *_Nullable)pollingID;

/**
 * @brief Starts the polling.
 * @param pollingID The edit poll's polling ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)startPolling:(NSString *_Nullable)pollingID;

/**
 * @brief Stops the polling.
 * @param pollingID The edit poll's polling ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)stopPolling:(NSString *_Nullable)pollingID;

/**
 * @brief Determines if the host or co-host can restart the polling.
 * @param pollingID The poll's polling ID.
 * @return YES if can restart the poll. Otherwise, NO.
 */
- (BOOL)canRestartPolling:(NSString *_Nullable)pollingID;

/**
 * @brief Restarts the polling.
 * @param pollingID The edit poll's polling ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)restartPolling:(NSString *_Nullable)pollingID;

/**
 * @brief Determines if the host or co-host can share the poll's result.
 * @param pollingID The poll's polling ID.
 * @return YES if can share the poll result. Otherwise, NO.
 */
- (BOOL)canSharePollingResult:(NSString *_Nullable)pollingID;

/**
 * @brief Shares the poll's result.
 * @param pollingID The edit poll's polling ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)startSharePollingResult:(NSString *_Nullable)pollingID;

/**
 * @brief Stops sharing the poll's result.
 * @param pollingID The edit poll's polling ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)stopSharePollingResult:(NSString *_Nullable)pollingID;

/**
 * @brief Sets to enable showing right answer to participants when sharing quiz's result.
 * @param enable YES to enable. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)enableGetRightAnswerList:(BOOL)enable;

/**
 * @brief Determines if the host can download poll's result from browser.
 * @return YES if can download the poll result. Otherwise, NO.
 */
- (BOOL)canDownloadResult;

/**
 * @brief Downloads all stopped poll's result from browser.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)downLoadResult;

#pragma mark - for attendee -

/**
 * @brief Attendee sets answer's check.
 * @param answerItem The answer item where you want to set check.
 * @param check YES to select the answer. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning This function should only be used by single, matching, rank order, multi, rating scale, or drop down questions.
 */
- (MobileRTCSDKError)setAnswerCheck:(MobileRTCPollingAnswerItem * _Nullable)answerItem check:(BOOL)check;

/**
 * @brief Attendee sets answer's content.
 * @param answerItem The answer item where you want to answer.
 * @param answerText The answer's content you want to reply.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning This function should only be used by fill blank, short answer, and long answer questions.
 */
- (MobileRTCSDKError)setAnswerContent:(MobileRTCPollingAnswerItem * _Nullable)answerItem answerText:(NSString *_Nullable)answerText;

/**
 * @brief Determines if the attendee can submit the polling.
 * @param pollingID The submit poll's polling ID.
 * @return YES if can submit the polling. Otherwise, NO.
 */
- (BOOL)canSubmitPolling:(NSString *_Nullable)pollingID;

/**
 * @brief Attendee submits the polling.
 * @param pollingID The submit poll's polling ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)submitPolling:(NSString *_Nullable)pollingID;
@end


/**
 * @file MobileRTCMeetingService+QA.h
 * @brief Meeting+QA service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>
#import <MobileRTC/MobileRTCQAItem.h>

/**
 * @brief QA of MobileRTCMeetingService
 */
@interface MobileRTCMeetingService (QA)

/**
 * @brief Queries if Q&A is supported in this meeting.
 * @return YES if Q&A is enabled. Otherwise, NO.
 */
- (BOOL)isQAEnabled;

/**
 * @brief Enables or disables meeting QA.
 * @param enable YES to enable. Otherwise, NO to disable.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)enableMeetingQAFeature:(BOOL)enable;

/**
 * @brief Queries if meeting QA is enabled in the current meeting.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)isMeetingQAFeatureOn;

/**
 * @brief Determines if asking questions is allowed by the host or co-host.
 * @return YES if can ask question. Otherwise, NO.
 */
- (BOOL)isAskQuestionEnabled;

/**
 * @brief Sets whether attendee can ask questions.
 * @param enable YES if attendee can ask questions. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)enableAskQuestion:(BOOL)enable;
/**
 * @brief Presents Zoom original Q&A ViewController.
 * @param parentVC The view controller used to present ViewController.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)presentQAViewController:(nonnull UIViewController*)parentVC;
/**
 * @brief Queries if it is allowed to ask questions anonymously in webinar.
 * @return YES if allowed. Otherwise, NO.
 */
- (BOOL)isAllowAskQuestionAnonymously;

/**
 * @brief Sets if it is enabled to ask questions anonymously.
 * @param enable YES to enable. Otherwise, NO to disable.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run this function.
 */
- (BOOL)allowAskQuestionAnonymously:(BOOL)enable;

/**
 * @brief Queries if attendee is allowed to view all questions.
 * @return YES if allowed. Otherwise, NO.
 */
- (BOOL)isAllowAttendeeViewAllQuestion;

/**
 * @brief Allows or disallows attendee to view all questions.
 * @param enable YES to enable. Otherwise, NO to disable.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run this function.
 */
- (BOOL)allowAttendeeViewAllQuestion:(BOOL)enable;

/**
 * @brief Queries if attendee is allowed to upvote questions.
 * @return YES if allowed. Otherwise, NO.
 */
- (BOOL)isAllowAttendeeUpVoteQuestion;

/**
 * @brief Allows or disallows attendee to upvote questions.
 * @param enable YES to allow. Otherwise, NO to disallow.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function.
 */
- (BOOL)allowAttendeeUpVoteQuestion:(BOOL)enable;

/**
 * @brief Queries if attendee is allowed to comment on questions.
 * @return YES if allowed. Otherwise, NO.
 */
- (BOOL)isAllowCommentQuestion;

/**
 * @brief Allows or disallows attendee to comment on questions.
 * @param enable YES to allow. Otherwise, NO to disallow.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function.
 */
- (BOOL)allowCommentQuestion:(BOOL)enable;

/**
 * @brief Gets all questions.
 * @return If the function succeeds, it returns an NSArray of MobileRTCQAItem objects. Otherwise, this function fails and returns nil.
 */
- (nullable NSArray <MobileRTCQAItem *> *)getAllQuestionList;

/**
 * @brief Gets my questions.
 * @return If the function succeeds, it returns an NSArray of MobileRTCQAItem objects. Otherwise, this function fails and returns nil.
 * @warning Only attendee can run the function.
 */
- (nullable NSArray <MobileRTCQAItem *> *)getMyQuestionList;

/**
 * @brief Gets open questions.
 * @return If the function succeeds, it returns an NSArray of MobileRTCQAItem objects. Otherwise, this function fails and returns nil.
 * @warning Only meeting host, co-host, or panelist can run the function.
 */
- (nullable NSArray <MobileRTCQAItem *> *)getOpenQuestionList;

/**
 * @brief Gets dismissed questions.
 * @return If the function succeeds, it returns an NSArray of MobileRTCQAItem objects. Otherwise, this function fails and returns nil.
 * @warning Only meeting host, co-host, or panelist can run the function.
 */
- (nullable NSArray <MobileRTCQAItem *> *)getDismissedQuestionList;

/**
 * @brief Gets answered questions.
 * @return If the function succeeds, it returns an NSArray of MobileRTCQAItem objects. Otherwise, this function fails and returns nil.
 * @warning Only meeting host, co-host, or panelist can run the function.
 */
- (nullable NSArray <MobileRTCQAItem *> *)getAnsweredQuestionList;

/**
 * @brief Gets the amount of all questions.
 * @return The amount of all questions.
 */
- (int)getALLQuestionCount;

/**
 * @brief Gets the amount of my questions.
 * @return The amount of my questions.
 */
- (int)getMyQuestionCount;

/**
 * @brief Gets the amount of open questions.
 * @return The amount of open questions.
 */
- (int)getOpenQuestionCount;

/**
 * @brief Gets the amount of dismissed questions.
 * @return The amount of dismissed questions.
 */
- (int)getDismissedQuestionCount;

/**
 * @brief Gets the amount of answered questions.
 * @return The amount of answered questions.
 */
- (int)getAnsweredQuestionCount;

/**
 * @brief Gets question item by question ID.
 * @param questionID The question ID.
 * @return If the function succeeds, it returns a MobileRTCQAItem object. Otherwise, this function fails and returns nil.
 */
- (nullable MobileRTCQAItem *)getQuestion:(nonnull NSString *)questionID;

/**
 * @brief Gets answer item by answer ID.
 * @param answerID The answer ID.
 * @return If the function succeeds, it returns a MobileRTCQAAnswerItem object. Otherwise, this function fails and returns nil.
 */
- (nullable MobileRTCQAAnswerItem *)getAnswer:(nonnull NSString *)answerID;

/**
 * @brief Adds a question.
 * @param content The question content.
 * @param anonymous YES if anonymously. Otherwise, NO.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only attendee can run the function.
 */
- (BOOL)addQuestion:(nonnull NSString *)content anonymous:(BOOL)anonymous;

/**
 * @brief Answers a question in private.
 * @param questionID The question ID.
 * @param answerContent The answer content.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host, co-host, or panelist can run the function.
 */
- (BOOL)answerQuestionPrivate:(nonnull NSString *)questionID answerContent:(nonnull NSString *)answerContent;

/**
 * @brief Answers a question publicly.
 * @param questionID The question ID.
 * @param answerContent The answer content.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host, co-host, or panelist can run the function.
 */
- (BOOL)answerQuestionPublic:(nonnull NSString *)questionID answerContent:(nonnull NSString *)answerContent;

/**
 * @brief Attendee comments on a question.
 * @param questionID The question ID.
 * @param commentContent The comment content.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting attendee can run the function.
 */
- (BOOL)commentQuestion:(nonnull NSString *)questionID commentContent:(nonnull NSString *)commentContent;

/**
 * @brief Dismisses a question.
 * @param questionID The question ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host, co-host, or panelist can run the function.
 */
- (BOOL)dismissQuestion:(nonnull NSString *)questionID;

/**
 * @brief Reopens a question.
 * @param questionID The question ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host, co-host, or panelist can run the function.
 */
- (BOOL)reopenQuestion:(nonnull NSString *)questionID;

/**
 * @brief Votes up a question.
 * @param questionID The question ID.
 * @param voteup YES to vote up. Otherwise, NO.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host, co-host, or panelist can run the function.
 */
- (BOOL)voteupQuestion:(nonnull NSString *)questionID voteup:(BOOL)voteup;

/**
 * @brief Starts living a question.
 * @param questionID The question ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host, co-host, or panelist can run the function.
 */
- (BOOL)startLiving:(nonnull NSString *)questionID;

/**
 * @brief Ends living a question.
 * @param questionID The question ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host, co-host, or panelist can run the function.
 */
- (BOOL)endLiving:(nonnull NSString *)questionID;

/**
 * @brief Deletes a question.
 * @param questionID The question ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host, co-host, or panelist can run the function.
 */
- (BOOL)deleteQuestion:(nonnull NSString *)questionID;

/**
 * @brief Deletes an answer.
 * @param answerID The answer ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host, co-host, or panelist can run the function.
 */
- (BOOL)deleteAnswer:(nonnull NSString *)answerID;

/**
 * @brief Determines if QA legal notice is available.
 * @return YES if available. Otherwise, NO.
 */
- (BOOL)isQALegalNoticeAvailable;

/**
 * @brief Gets QA legal notices prompt.
 * @return The QA legal notices prompt.
 */
- (NSString *_Nullable)getQALegalNoticesPrompt;

/**
 * @brief Gets QA legal notices explained.
 * @return The QA legal notices explained.
 */
- (NSString *_Nullable)getQALegalNoticesExplained;


@end

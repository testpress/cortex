/**
 * @file MobileRTCQAItem.h
 * @brief Q&A item data structure for meeting Q&A functionality.
 */

#import <Foundation/Foundation.h>

/**
 * @class MobileRTCQAAnswerItem
 * @brief A class that represents a Q&A answer.
 */
@interface MobileRTCQAAnswerItem : NSObject

/**
 * @brief Gets the answer time.
 * @return The answer time.
 */
- (NSDate *_Nullable)getTime;

/**
 * @brief Gets the answer text.
 * @return The answer text.
 */
- (NSString *_Nullable)getText;

/**
 * @brief Gets the sender name.
 * @return The sender name.
 */
- (NSString *_Nullable)getSenderName;

/**
 * @brief Gets the question ID.
 * @return The question ID.
 */
- (NSString *_Nullable)getQuestionId;

/**
 * @brief Gets the answer ID.
 * @return The answer ID.
 */
- (NSString *_Nullable)getAnswerID;

/**
 * @brief Determines if the answer is private.
 * @return YES if the answer is private. Otherwise, NO.
 */
- (BOOL)isPrivate;

/**
 * @brief Determines if the answer is a live answer.
 * @return YES if the answer is a live answer. Otherwise, NO.
 */
- (BOOL)isLiveAnswer;

/**
 * @brief Determines if the sender is myself.
 * @return YES if the sender is myself. Otherwise, NO.
 */
- (BOOL)isSenderMyself;

@end

/**
 * @class MobileRTCQAItem
 * @brief A class that represents a Q&A question.
 */
@interface MobileRTCQAItem : NSObject

/**
 * @brief Gets the question ID.
 * @return The question ID.
 */
- (NSString *_Nullable)getQuestionId;

/**
 * @brief Gets the question time.
 * @return The question time.
 */
- (NSDate *_Nullable)getTime;

/**
 * @brief Gets the question text.
 * @return The question text.
 */
- (NSString *_Nullable)getText;

/**
 * @brief Gets the sender name.
 * @return The sender name.
 */
- (NSString *_Nullable)getSenderName;

/**
 * @brief Determines if the question is anonymous.
 * @return YES if the question is anonymous. Otherwise, NO.
 */
- (BOOL)isAnonymous;

/**
 * @brief Determines if the question is marked as answered.
 * @return YES if the question is marked as answered. Otherwise, NO.
 */
- (BOOL)isMarkedAsAnswered;

/**
 * @brief Determines if the question is marked as dismissed.
 * @return YES if the question is marked as dismissed. Otherwise, NO.
 */
- (BOOL)isMarkedAsDismissed;

/**
 * @brief Gets the upvote number.
 * @return The upvote number.
 */
- (NSUInteger)getUpvoteNumber;

/**
 * @brief Determines if the question has live answers.
 * @return YES if the question has live answers. Otherwise, NO.
 */
- (BOOL)getHasLiveAnswers;

/**
 * @brief Determines if the question has text answers.
 * @return YES if the question has text answers. Otherwise, NO.
 */
- (BOOL)getHasTextAnswers;

/**
 * @brief Determines if I have upvoted the question.
 * @return YES if I have upvoted the question. Otherwise, NO.
 */
- (BOOL)isMySelfUpvoted;

/**
 * @brief Determines if I am live answering the question.
 * @return YES if I am live answering the question. Otherwise, NO.
 */
- (BOOL)amILiveAnswering;

/**
 * @brief Determines if someone is live answering the question.
 * @return YES if someone is live answering the question. Otherwise, NO.
 */
- (BOOL)isLiveAnswering;

/**
 * @brief Gets the live answer name.
 * @return The live answer name.
 */
- (NSString *_Nullable)getLiveAnswerName;

/**
 * @brief Determines if the sender is myself.
 * @return YES if the sender is myself. Otherwise, NO.
 */
- (BOOL)isSenderMyself;

/**
 * @brief Gets the answer list.
 * @return The answer list.
 */
- (nullable NSArray <MobileRTCQAAnswerItem *>*)getAnswerlist;
@end



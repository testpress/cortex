/**
 * @file MobileRTCMeetingChat.h
 * @brief Chat functionality for sending and receiving messages during meetings.
 */

#import <Foundation/Foundation.h>
#import <MobileRTC/MobileRTCConstants.h>

/**
 * @class MobileRTCFileTransferInfo
 * @brief A class that provides information about the status and progress of a file transfer during a Zoom meeting.
 */
@interface MobileRTCFileTransferInfo : NSObject

/**
 * @brief The message ID of the transfer file.
 */
@property(nonatomic, copy, nullable)    NSString *messageId;

/**
 * @brief The status of the file transfer.
 */
@property(nonatomic, assign)            MobileRTCFileTransferStatus transStatus;

/**
 * @brief The timestamp of the file.
 */
@property(nonatomic, strong, nullable)  NSDate *timeStamp;

/**
 * @brief Indicates whether the file is sent to all users in the meeting.
 */
@property(nonatomic, assign)            BOOL isSendToAll;

/**
 * @brief The bytes of transfer file size.
 */
@property(nonatomic, assign)            NSUInteger fileSize;

/**
 * @brief The file name of the transfer file.
 */
@property(nonatomic, copy, nullable)    NSString *fileName;

/**
 * @brief The ratio of the file transfer completed.
 */
@property(nonatomic, assign)            NSUInteger completePercentage;

/**
 * @brief The size of the file transferred so far in bytes.
 */
@property(nonatomic, assign)            NSUInteger completeSize;

/**
 * @brief The speed of the file transfer in bits per second.
 */
@property(nonatomic, assign)            NSUInteger bitPerSecond;
@end

/**
 * @class MobileRTCFileSender
 * @brief A class for file sender.
 */
@interface MobileRTCFileSender : NSObject

/**
 * @brief The basic information of the transfer file.
 */
@property(nonatomic, strong, nullable) MobileRTCFileTransferInfo *transferInfo;

/**
 * @brief Gets the file receiver's user ID.
 * @return The receiver user ID. -1 specifies an internal error getting the user ID. 0 specifies the file is sent to all.
 */
- (NSInteger)getReceiverUserId;

/**
 * @brief Cancels the file send.
 * @return The error type of the cancel action.
 */
- (MobileRTCSDKError)cancelSend;
@end

/**
 * @class MobileRTCFileReceiver
 * @brief A class for file receiver.
 */
@interface MobileRTCFileReceiver : NSObject

/**
 * @brief The basic information of the transfer file.
 */
@property(nonatomic, strong, nullable) MobileRTCFileTransferInfo *transferInfo;

/**
 * @brief Gets the file sender's user ID.
 * @return The sender user ID. -1 specifies an internal error getting the user ID.
 */
- (NSInteger)getSenderUserId;

/**
 * @brief Cancels the file receive.
 * @return The error type of the cancel action.
 */
- (MobileRTCSDKError)cancelReceive;

/**
 * @brief Starts receiving the file.
 * @param path The path to receive the file.
 * @return The error type of the start receive action.
 */
- (MobileRTCSDKError)startReceive:(NSString * _Nullable)path;
@end


@class MobileRTCMeetingChat;
@class MobileRTCBoldAttrs;
@class MobileRTCItalicAttrs;
@class MobileRTCStrikethroughAttrs;
@class MobileRTCBulletedListAttrs;
@class MobileRTCNumberedListAttrs;
@class MobileRTCUnderlineAttrs;
@class MobileRTCQuoteAttrs;
@class MobileRTCInsertLinkAttrs;
@class MobileRTCFontSizeAttrs;
@class MobileRTCFontColorAttrs;
@class MobileRTCBackgroundColorAttrs;
@class MobileRTCParagraphAttrs;
@class MobileRTCIndentAttrs;
/**
 * @class MobileRTCMeetingChatBuilder
 * @brief A chat message builder to create ChatMsgInfo objects.
 * @note If there are duplicate styles, the final appearance is determined by the last applied setting.
 */
@interface MobileRTCMeetingChatBuilder : NSObject

/**
 * @brief Sets chat message content.
 * @param content The chat message's content.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setContent:(NSString * _Nullable)content;

/**
 * @brief Sets who will receive the chat message.
 * @param receiver The user ID to receive the chat message. The message is sent to all participants when the value is zero (0).
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setReceiver:(NSInteger)receiver;

/**
 * @brief Sets the ID of the thread where the message will be posted.
 * @param threadId The thread ID.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setThreadId:(NSString * _Nullable)threadId;

/**
 * @brief Sets the chat message type.
 * @param type The chat message's type.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setMessageType:(MobileRTCChatMessageType)type;

/**
 * @brief Sets the chat message content quote style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setQuotePosition:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Clears the chat message content quote style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)unsetQuotePosition:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Sets the chat message content italic style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setItalic:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Clears the chat message content italic style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)unsetItalic:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Sets the chat message content bold style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setBold:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Clears the chat message content bold style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)unsetBold:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Sets the chat message content strikethrough style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setStrikethrough:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Clears the chat message content strikethrough style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)unsetStrikethrough:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Sets the chat message content bulleted list style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setBulletedList:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Clears the chat message content bulleted list style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)unsetBulletedList:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Sets the chat message content numbered list style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setNumberedList:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Clears the chat message content numbered list style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)unsetNumberedList:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Sets the chat message content underline style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setUnderline:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Clears the chat message content underline style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)unsetUnderline:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Sets the chat message content font size style.
 * @param size The font size attributes.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setFontSize:(MobileRTCFontSizeAttrs * _Nullable)size start:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Clears the chat message content font size style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)unsetFontSize:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Sets the chat message content insert link style.
 * @param link The insert link attributes.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setInsertLink:(MobileRTCInsertLinkAttrs * _Nullable)link start:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Clears the chat message content insert link style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)unsetInsertLink:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Sets the chat message content background color style.
 * @param color The background color attributes.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setBackgroundColor:(MobileRTCBackgroundColorAttrs * _Nullable)color start:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Clears the chat message content background color style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)unsetBackgroundColor:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Sets the chat message content font color style.
 * @param color The font color attributes.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setFontColor:(MobileRTCFontColorAttrs * _Nullable)color start:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Clears the chat message content font color style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)unsetFontColor:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Increases the chat message content indent style.
 * @param indent The indent attributes.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)increaseIndent:(MobileRTCIndentAttrs * _Nullable)indent start:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Decreases the chat message content indent style.
 * @param indent The indent attributes.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)decreaseIndent:(MobileRTCIndentAttrs * _Nullable)indent start:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Sets the chat message content paragraph style.
 * @param paragraph The paragraph attributes.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)setParagraph:(MobileRTCParagraphAttrs * _Nullable)paragraph start:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Clears the chat message content paragraph style.
 * @param start The segment start position.
 * @param end The segment end position.
 * @return If the function succeeds, it returns a MobileRTCMeetingChatBuilder object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChatBuilder * _Nullable)unsetParagraph:(NSInteger)start end:(NSInteger)end;

/**
 * @brief Builds chat message entity.
 * @return If the function succeeds, it returns a MobileRTCMeetingChat object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingChat * _Nullable)build;

@end

/**
 * @brief For rich text solution, the specified rich text offset information.
 * @deprecated This class is deprecated. Use \link MobileRTCSegmentDetails \endlink instead.
 */
__attribute__((deprecated("This class is deprecated, use MobileRTCSegmentDetails instead")))
/**
 * @class MobileRTCRichTextStyleOffset
 * @brief A class that describes the style range and additional metadata of a rich text segment.
 */
@interface MobileRTCRichTextStyleOffset : NSObject

/**
 * @brief Gets a certain rich-text style's start position.
 */
@property (nonatomic, assign) NSInteger positionStart;

/**
 * @brief Gets a certain rich-text style's end position.
 */
@property (nonatomic, assign) NSInteger positionEnd;

/**
 * @brief Gets a certain rich-text style's supplementary information.
 * @note If style is TextStyle_Paragraph, possible return values are as follows: Paragraph_H1, Paragraph_H2, or Paragraph_H3. If the style is TextStyle_FontColor or TextStyle_BackgroundColor, possible return values are hex string representing standard RGB data.
 * @warning If the style is TextStyle_FontSize, possible return values are FontSize_Small, FontSize_Medium, or FontSize_Large.
 */
@property (nonatomic, copy) NSString * _Nullable reserve;
@end

/**
 * @brief For rich text solution, the specified text style information.
 * @deprecated This class is deprecated. Use \link MobileRTCSegmentDetails \endlink instead.
 */
__attribute__((deprecated("This class is deprecated, use MobileRTCSegmentDetails instead")))
/**
 * @class MobileRTCRichTextStyleItem
 * @brief A class that represents a rich-text style and associated style ranges.
 */
@interface MobileRTCRichTextStyleItem : NSObject

/**
 * @brief Gets the rich text type of a portion of the current message.
 */
@property (nonatomic, assign) MobileRTCRichTextStyle textStyle;

/**
 * @brief Gets the current message's rich text position info list of a certain style.
 */
@property (nonatomic, copy) NSArray <MobileRTCRichTextStyleOffset *>* _Nullable textStyleOffsetList;
@end

#pragma mark - new chat -
/**
 * @class MobileRTCSegmentDetails
 * @brief A class that contains information of rich text with style attributes in a chat message content. Here are more detailed structural descriptions.
 */
@interface MobileRTCSegmentDetails : NSObject

/**
 * @brief The segment content value.
 */
@property (nonatomic, copy) NSString * _Nullable content;

/**
 * @brief The segment BoldAttrs value.
 */
@property (nonatomic, strong) MobileRTCBoldAttrs * _Nullable boldAttrs;

/**
 * @brief The segment ItalicAttrs value.
 */
@property (nonatomic, strong) MobileRTCItalicAttrs * _Nullable italicAttrs;

/**
 * @brief The strikethrough attributes content value.
 */
@property (nonatomic, strong) MobileRTCStrikethroughAttrs * _Nullable strikethroughAttrs;

/**
 * @brief The segment BulletedListAttrs value.
 */
@property (nonatomic, strong) MobileRTCBulletedListAttrs * _Nullable bulletedListAttrs;

/**
 * @brief The segment NumberedListAttrs value.
 */
@property (nonatomic, strong) MobileRTCNumberedListAttrs * _Nullable numberedListAttrs;

/**
 * @brief The segment UnderlineAttrs value.
 */
@property (nonatomic, strong) MobileRTCUnderlineAttrs * _Nullable underlineAttrs;

/**
 * @brief The segment QuoteAttrs value.
 */
@property (nonatomic, strong) MobileRTCQuoteAttrs * _Nullable quoteAttrs;
/**
 * @brief The segment InsertLinkAttrs value.
 */
@property (nonatomic, strong) MobileRTCInsertLinkAttrs * _Nullable insertLinkAttrs;

/**
 * @brief The segment FontSizeAttrs value.
 */
@property (nonatomic, strong) MobileRTCFontSizeAttrs * _Nullable fontSizeAttrs;

/**
 * @brief The segment FontColorAttrs value.
 */
@property (nonatomic, strong) MobileRTCFontColorAttrs * _Nullable fontColorAttrs;

/**
 * @brief The segment BackgroundColorAttrs value.
 */
@property (nonatomic, strong) MobileRTCBackgroundColorAttrs * _Nullable backgroundColorAttrs;

/**
 * @brief The segment ParagraphAttrs value.
 */
@property (nonatomic, strong) MobileRTCParagraphAttrs * _Nullable paragraphAttrs;

/**
 * @brief The segment IndentAttrs value.
 */
@property (nonatomic, strong) MobileRTCIndentAttrs * _Nullable indentAttrs;
@end

/**
 * @class MobileRTCBoldAttrs
 * @brief A class that contains bold attributes.
 */
@interface MobileRTCBoldAttrs : NSObject

/**
 * @brief Indicates if the text style is bold. YES if bold, NO otherwise.
 */
@property (nonatomic, assign) BOOL bBold;
@end

/**
 * @class MobileRTCItalicAttrs
 * @brief A class that contains italic attributes.
 */
@interface MobileRTCItalicAttrs : NSObject

/**
 * @brief Indicates if the text style is italic. YES if italic, NO otherwise.
 */
@property (nonatomic, assign) BOOL bItalic;
@end

/**
 * @class MobileRTCStrikethroughAttrs
 * @brief A class that contains strikethrough attributes.
 */
@interface MobileRTCStrikethroughAttrs : NSObject

/**
 * @brief Indicates if the text style is strikethrough. YES if strikethrough, NO otherwise.
 */
@property (nonatomic, assign) BOOL bStrikethrough;
@end

/**
 * @class MobileRTCBulletedListAttrs
 * @brief A class that contains bulleted list attributes.
 */
@interface MobileRTCBulletedListAttrs : NSObject

/**
 * @brief Indicates if the text style is bulleted list. YES if bulleted list, NO otherwise.
 */
@property (nonatomic, assign) BOOL bBulletedList;
@end

/**
 * @class MobileRTCNumberedListAttrs
 * @brief A class that contains numbered list attributes.
 */
@interface MobileRTCNumberedListAttrs : NSObject

/**
 * @brief Indicates if the text style is numbered. YES if numbered, NO otherwise.
 */
@property (nonatomic, assign) BOOL bNumberedList;
@end

/**
 * @class MobileRTCUnderlineAttrs
 * @brief A class that contains underline attributes.
 */
@interface MobileRTCUnderlineAttrs : NSObject

/**
 * @brief Indicates if the text style is underline. YES if underline, NO otherwise.
 */
@property (nonatomic, assign) BOOL bUnderline;
@end

/**
 * @class MobileRTCQuoteAttrs
 * @brief A class that contains quote attributes.
 */
@interface MobileRTCQuoteAttrs : NSObject

/**
 * @brief Indicates if the text style is quote. YES if quote, NO otherwise.
 */
@property (nonatomic, assign) BOOL bQuote;
@end

/**
 * @class MobileRTCInsertLinkAttrs
 * @brief A class that contains insert link attributes.
 */
@interface MobileRTCInsertLinkAttrs : NSObject

/**
 * @brief The insert link URL. If insertLinkUrl is not empty, the text style has an insert link URL.
 */
@property (nonatomic, copy) NSString * _Nullable insertLinkUrl;
@end

/**
 * @brief Font size attributes. Currently supported font size values are as follows.
 */
#define FontSize_Small 8
#define FontSize_Medium 10
#define FontSize_Large 12

/**
 * @class MobileRTCFontSizeAttrs
 * @brief A class that sets font size attributes for a chat message segment.
 */
@interface MobileRTCFontSizeAttrs : NSObject

/**
 * @brief The font size value. The default is FontSize_Medium.
 */
@property (nonatomic, assign) NSInteger fontSize;
@end

/**
 * @brief Font color attributes.
 * @note FontColor_Red: 235,24,7.
 * @note FontColor_Orange: 255,138,0.
 * @note FontColor_Yellow: 248,194,0.
 * @note FontColor_Green: 19,138,0.
 * @note FontColor_Blue: 0,111,250.
 * @note FontColor_Violet: 152,70,255.
 * @note FontColor_Rosered: 226,0,148.
 * @note FontColor_Black: 34,34,48.
 * @warning Currently supported font color combinations.
 */
#define kRichTextColor(r,g,b) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1.]

/**
 * @class MobileRTCFontColorAttrs
 * @brief A class that sets font color attributes for a chat message segment.
 */
@interface MobileRTCFontColorAttrs : NSObject

/**
 * @brief The font color.
 */
@property (nonatomic, strong) UIColor * _Nullable color;
@end

/**
 * @class MobileRTCBackgroundColorAttrs
 * @brief A class that contains background color attributes.
 * @note BackgroundColor_Normal: 255,255,255.
 * @note BackgroundColor_Red: 255,67,67.
 * @note BackgroundColor_Orange: 255,138,0.
 * @note BackgroundColor_Yellow: 255,214,0.
 * @note BackgroundColor_Green: 73,214,30.
 * @note BackgroundColor_Blue: 47,139,255.
 * @note BackgroundColor_Violet: 171,104,255.
 * @note BackgroundColor_Rosered: 255,54,199.
 * @note BackgroundColor_White: 255,255,255.
 * @warning Currently supported background color combinations.
 */
@interface MobileRTCBackgroundColorAttrs : NSObject

/**
 * @brief The background color.
 */
@property (nonatomic, strong) UIColor * _Nullable color;
@end

/**
 * @note The attribute strParagraph can be set with the following values.
 * @note If you need a customized paragraph, fill strParagraph as desired.
 */
#define TextStyle_Paragraph_H1      @"Paragraph_H1"
#define TextStyle_Paragraph_H2      @"Paragraph_H2"
#define TextStyle_Paragraph_H3      @"Paragraph_H3"

/**
 * @class MobileRTCParagraphAttrs
 * @brief A class that contains paragraph attributes.
 */
@interface MobileRTCParagraphAttrs : NSObject

/**
 * @brief The paragraph style. If strParagraph is not empty, the text style has a paragraph style.
 */
@property (nonatomic, copy) NSString * _Nullable strParagraph;
@end

/**
 * @class MobileRTCIndentAttrs
 * @brief A class that contains indent attributes.
 */
@interface MobileRTCIndentAttrs : NSObject

/**
 * @brief The number of times the indentation style is applied.
 */
@property (nonatomic, assign) NSInteger indent;
@end

/**
 * @class MobileRTCMeetingChat
 * @brief A class that retrieves meeting chat data.
 * @warning This function is optional.
 */
@interface MobileRTCMeetingChat : NSObject

/**
 * @brief The message ID.
 */
@property (nonatomic, copy) NSString * _Nullable chatId;

/**
 * @brief The ID of the user who sends the message.
 */
@property (nonatomic, copy) NSString * _Nullable senderId;

/**
 * @brief The screen name of the user who sends the message.
 */
@property (nonatomic, copy) NSString * _Nullable senderName;

/**
 * @brief The ID of the user who receives the message.
 */
@property (nonatomic, copy) NSString * _Nullable receiverId;

/**
 * @brief The screen name of the user who receives the message.
 */
@property (nonatomic, copy) NSString * _Nullable receiverName;

/**
 * @brief The message content.
 */
@property (nonatomic, copy) NSString * _Nullable content;

/**
 * @brief The message timestamp.
 */
@property (nonatomic, retain) NSDate *_Nullable date;

/**
 * @brief The chat message type.
 */
@property (nonatomic, assign) MobileRTCChatMessageType chatMessageType;

/**
 * @brief Indicates whether the message is sent by the user themselves.
 */
@property (nonatomic, assign) BOOL isMyself;

/**
 * @brief Indicates whether the message is private.
 */
@property (nonatomic, assign) BOOL isPrivate;

/**
 * @brief Indicates whether the message is sent to all.
 */
@property (nonatomic, assign) BOOL isChatToAll;

/**
 * @brief Indicates whether the message is sent to all panelists.
 */
@property (nonatomic, assign) BOOL isChatToAllPanelist;

/**
 * @brief Indicates whether the message is sent to the waiting room.
 */
@property (nonatomic, assign) BOOL isChatToWaitingroom;

/**
 * @brief Determines if the current message is a comment replying to another message.
 */
@property (nonatomic, assign) BOOL isComment;

/**
 * @brief Determines if the current message is part of a message thread and can be directly replied to.
 */
@property (nonatomic, assign) BOOL isThread;

/**
 * @brief Gets the current message's chat message font style list.
 * @deprecated Use \link segmentDetails \endlink instead.
 */
@property (nonatomic, copy) NSArray <MobileRTCRichTextStyleItem *>* _Nullable textStyleItemList DEPRECATED_MSG_ATTRIBUTE("Use segmentDetails instead");

/**
 * @brief Gets the chat message segment content and style detail of the current message.
 * @note When receiving rich-text messages, a list of isolated paragraphs is included, each formatted according to its style. Concatenating these paragraphs together forms the complete message text.
 */
@property (nonatomic, copy) NSArray <MobileRTCSegmentDetails *>* _Nullable segmentDetails;
/**
 * @brief Gets the current message's thread ID.
 */
@property (nonatomic, copy) NSString * _Nullable threadID;
@end

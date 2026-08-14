/**
 * @file MobileRTCMeetingActionItem.h
 * @brief Action item data structure for meeting actions and tasks.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * @brief A block for custom invitation action items in the meeting.
 */
typedef void (^MobileRTCMeetingInviteActionItemBlock)(void);

/**
 * @class MobileRTCMeetingInviteActionItem
 * @brief A class for adding custom invitation action items to the meeting.
 */
@interface MobileRTCMeetingInviteActionItem : NSObject

/**
 * @brief The title of the custom invitation item.
 */
@property (nonatomic, retain, readwrite) NSString * _Nullable actionTitle;

/**
 * @brief Callback event when clicking the invitation item.
 */
@property (nonatomic, copy, readwrite) MobileRTCMeetingInviteActionItemBlock _Nullable actionHandler;

/**
 * @brief Creates an item with title and action handler.
 * @param inTitle The title of the item.
 * @param actionHandler The action handler block.
 * @return The created item.
 */
+(id _Nonnull )itemWithTitle:(NSString * _Nullable )inTitle Action:(MobileRTCMeetingInviteActionItemBlock _Nullable )actionHandler;

@end

/**
 * @protocol MobileRTCMeetingShareActionItemDelegate
 * @brief A protocol for adding custom share action items to the meeting.
 */
@protocol MobileRTCMeetingShareActionItemDelegate <NSObject>
@required

/**
 * @brief Callback event when the share item is clicked.
 * @param tag The tag of the share item.
 * @param completion The completion block.
 */
- (void)onShareItemClicked:(NSUInteger)tag completion:(BOOL(^_Nonnull)(UIViewController * _Nonnull shareView))completion;
@end

/**
 * @class MobileRTCMeetingShareActionItem
 * @brief A class for adding custom sharing action items to the meeting.
 */
@interface MobileRTCMeetingShareActionItem : NSObject

/**
 * @brief Icon for simplified toolbar share menu (square 18pt recommended). Optional.
 */
@property (nonatomic, retain, readwrite) UIImage * _Nullable actionIcon;

/**
 * @brief The title of the custom content to share, such as screen, application, photos, etc.
 */
@property (nonatomic, retain, readwrite) NSString * _Nonnull actionTitle;

/**
 * @brief The tag of the share action item.
 */
@property (nonatomic, assign, readwrite) NSUInteger tag;

/**
 * @brief Enables sharing via MobileRTCMeetingShareActionItemDelegate.
 */
@property (nonatomic, assign, readwrite) id<MobileRTCMeetingShareActionItemDelegate> _Nonnull delegate;

/**
 * @brief Creates an item with title and tag.
 * @param inTitle The title of the item.
 * @param tag The tag of the item.
 * @return The created item.
 */
+(id _Nonnull )itemWithTitle:(NSString * _Nonnull)inTitle Tag:(NSUInteger)tag;

/**
 * @brief Creates an item with icon and title and tag.
 * @param actionIcon The icon of the item.
 * @param inTitle The title of the item.
 * @param tag The tag of the item.
 * @return The created item.
 */
+(id _Nonnull )itemWithIcon:(UIImage * _Nullable)actionIcon title:(NSString * _Nonnull)inTitle Tag:(NSUInteger)tag;
@end

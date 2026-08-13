/**
 * @file MobileRTCRemoteControlService.h
 * @brief Remote control functionality during screen sharing.
 */

#import <Foundation/Foundation.h>

@protocol MobileRTCRemoteControlDelegate;

/**
 * @brief MobileRTCRemoteControlInputType An Enumeration of input types when the Enter key or Delete on the keyboard is pressed.
 */
typedef enum
{
    /** Remote control Del. */
    MobileRTCRemoteControl_Del,
    /** Remote control Return. */
    MobileRTCRemoteControl_Return
} MobileRTCRemoteControlInputType;

/**
 * @class MobileRTCRemoteControlService
 * @brief It provides Remote Control Service.
 * @note 1.Be assigned be a remote control(Notify by "remoteControlPrivilegeChanged:" check with "isHaveRemoteControlRight").
 * @note 2.Need to grab the currently control(Call "grabRemoteControl:", check with "isRemoteController").
 * @note 3.Can do the remote action.
 */
@interface MobileRTCRemoteControlService : NSObject
/**
 * @brief The callback event delegate of receiving remote control.
 */
@property (weak, nonatomic) id<MobileRTCRemoteControlDelegate> _Nullable delegate;

/**
 * @brief Queries if the current user has control privilege. You can have this after being assigned to have remote control privilege.
 * @param remoteShareView The remote shared view.
 * @return YES if the user got remote control privilege. Otherwise, NO.
 * @warning In Zoom UI Mode, if remoteShareView is nil, that means the currently active Zoom Subscribe Share View.
 */
- (BOOL)isHaveRemoteControlRight:(MobileRTCActiveShareView * _Nonnull)remoteShareView;

/**
 * @brief Queries if the current user gets remote control privilege.
 * @param remoteShareView The remote shared view.
 * @return YES if the user got remote control privilege. Otherwise, NO.
 * @warning In Zoom UI Mode, if remoteShareView is nil, that means the currently active Zoom Subscribe Share View.
 */
- (BOOL)isRemoteController:(MobileRTCActiveShareView * _Nonnull)remoteShareView;

/**
 * @brief Sets to enable remote control. User should tap the screen icon once received the privilege to control one's screen remotely.
 * @param remoteShareView The remote shared view.
 * @return The result of grabbing the remote control.
 */
- (MobileRTCRemoteControlError)grabRemoteControlView:(MobileRTCActiveShareView * _Nonnull)remoteShareView;

/**
 * @brief Simulates a mouse click with a finger clicking once on the screen.
 * @param point The point where user clicks corresponds to the location of the content.
 * @return The result of the operation.
 */
- (MobileRTCRemoteControlError)remoteControlSingleTap:(CGPoint)point;

/**
 * @brief Simulates a mouse double-click with a finger clicking twice successively on the screen.
 * @param point The point where user clicks corresponds to the location of the content.
 * @return The result of the operation.
 */
- (MobileRTCRemoteControlError)remoteControlDoubleTap:(CGPoint)point;

/**
 * @brief Simulates a mouse right-click with a finger pressing phone screen for more than 3 seconds.
 * @param point The point where user clicks corresponds to the location of the content.
 * @return The result of the operation.
 */
- (MobileRTCRemoteControlError)remoteControlLongPress:(CGPoint)point;

/**
 * @brief Simulates a mouse scroll with two fingers scrolling up and down.
 * @param point It is recommended to pass the arguments: CGPointMake(0, -1) for scrolling up, CGPointMake(0, 1) for scrolling down.
 * @return The result of the operation.
 */
- (MobileRTCRemoteControlError)remoteControlDoubleScroll:(CGPoint)point;

/**
 * @brief Moves remote cursor by dragging mouse icon on phone screen.
 * @param point The point where user clicks corresponds to the location of the content.
 * @return The result of the operation.
 */
- (MobileRTCRemoteControlError)remoteControlSingleMove:(CGPoint)point;

/**
 * @brief Simulates a mouse left-click with a finger pressing phone screen for more than 3 seconds.
 * @param point The point where user clicks corresponds to the location of the content.
 * @return The result of the operation.
 * @note This method is used to simulate a mouse left-click, such as long press on mouse icon.
 */
- (MobileRTCRemoteControlError)remoteControlMouseLeftDown:(CGPoint)point;

/**
 * @brief Simulates releasing the left mouse button.
 * @param point The point where user clicks corresponds to the location of the content.
 * @return The result of the operation.
 */
- (MobileRTCRemoteControlError)remoteControlMouseLeftUp:(CGPoint)point;

/**
 * @brief Simulates a mouse left-click and drag. User clicks the mouse icon on the screen for 3s and drags it.
 * @param point The trajectory of the simulated mouse.
 * @return The result of the operation.
 */
- (MobileRTCRemoteControlError)remoteControlMouseLeftDrag:(CGPoint)point;

/**
 * @brief Simulates a keyboard to input text.
 * @param str The input text from keyboard.
 * @return The result of the operation.
 */
- (MobileRTCRemoteControlError)remoteControlCharInput:(NSString * _Nonnull)str;

/**
 * @brief Simulates Enter key or delete key of the keyboard.
 * @param key A value of the enumeration of MobileRTCRemoteControlInputType.
 * @return The result of the operation.
 */
- (MobileRTCRemoteControlError)remoteControlKeyInput:(MobileRTCRemoteControlInputType)key;
@end

/**
 * @protocol MobileRTCRemoteControlDelegate
 */
@protocol MobileRTCRemoteControlDelegate <NSObject>
@optional
/**
 * @brief Callback event when the privilege of remote control changes.
 * @param isMyControl YES if the current user got the remote control privilege. Otherwise, NO.
 * @deprecated Use \link onRemoteControlPrivilegeChanged: \endlink instead.
 */
- (void)remoteControlPrivilegeChanged:(BOOL)isMyControl DEPRECATED_MSG_ATTRIBUTE("Use onRemoteControlPrivilegeChanged instead");
/**
 * @brief Callback event when the privilege of remote control changes.
 * @param isMyControl YES if the current user got the remote control privilege. Otherwise, NO.
 */
- (void)onRemoteControlPrivilegeChanged:(BOOL)isMyControl;

/**
 * @brief Callback event when remote control starts.
 * @param resultValue A value of MobileRTCRemoteControlError enumeration.
 * @deprecated Use \link onEnterOrLeaveRemoteControllingStatus: \endlink instead.
 */
- (void)startRemoteControlCallBack:(MobileRTCRemoteControlError)resultValue DEPRECATED_MSG_ATTRIBUTE("Use onEnterOrLeaveRemoteControllingStatus instead");

/**
 * @brief Callback event when remote control starts.
 * @param isEnter YES if grabbing Remote Control View succeeds. Otherwise, NO.
 */
- (void)onEnterOrLeaveRemoteControllingStatus:(BOOL)isEnter;

@end


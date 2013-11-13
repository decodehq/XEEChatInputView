//
//  UIBubbleTextView.h
//  UIBubbleTableViewExample
//
//  Created by Andrija Cajic on 10/10/13.
//
//

#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@class XEEChatInputView;

@protocol XEEChatInputViewDelegate <NSObject>

-(void) XEEChatInputView:(XEEChatInputView*)chatInputView submitTextMessage:(NSString*)text;
-(void) XEEChatInputView:(XEEChatInputView*)chatInputView submitImageMessage:(UIImage*)image;
-(void) XEEChatInputView:(XEEChatInputView*)chatInputView presentImagePickerController:(UIImagePickerController*)imagePickerController;

@end

/**
 Input field for entering messages in chat. Class that, along with its dependencies, represents everything necessary for simple implementation of chat text&photo input view.
 */
@interface XEEChatInputView : UIView <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> // UIImagePickerControllerDelegate, UINavigationControllerDelegate are for UIImagePickerController when sending photos over chat

/**
 A UIScrollView that is positioned outside of ChatInputView view hierarchy but is affected by its changes in size.
 ChatInputView on several occasions calls methods on this scroll view (i.e. <code>setContentOffset:</code>, <code>setContentInset:</code>).
 */
@property (nonatomic, weak) UIScrollView* targetScrollView;

/**
 Editable UITextView for typing messages.
 */
@property (nonatomic, strong) UITextView* textView;

/**
 Image view that holds an image inside ChatInputView before it is submitted.
 */
@property (nonatomic, strong) UIImageView* imageView;

/**
 Resizable image that grafically specifies the designated area for textView.
 */
@property (nonatomic, strong) UIImage* containerImage;

/**
 Minimum height for ChatInputView.
 */
@property (nonatomic, assign) CGFloat minHeight;

/**
 Maximum height for ChatInputView.
 */
@property (nonatomic, assign) CGFloat maxHeight;

/**
 Maximum height for imageView while previewing inside ChatInputView.
 */
@property (nonatomic, assign) CGFloat imageMaxHeight;

/**
 Extra height added to the size calculated based on the length of string in textView.
 */
@property (nonatomic, assign) CGFloat fontOffset;

/**
 When calculating size that a textView will require in order to show entire string sometimes in the NSString's method <code>sizeWithFont:constrainedToSize:lineBreakMode:</code> the size argument's width needs to be adjusted to get correct result.
 This valuew is added to textView's frame width in order to get correct height required to display entire string inside textView.
 */
@property (nonatomic, assign) CGFloat tweakResizer;

/**
 Button on the right side of textView.
 */
@property (nonatomic, strong) UIButton* submitButton;

/**
 Button on the left side of textView.
 */
@property (nonatomic, strong) UIButton* photoButton;


/**
 Delegate gets notified when 
 1) ChatInputView would like to present UIImagePickerController;
 2) Text message is submitted
 3) Photo message is submitted
 */
@property (nonatomic, weak) id<XEEChatInputViewDelegate> delegate;


@end

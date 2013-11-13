//
//  UIBubbleTextView.m
//  UIBubbleTableViewExample
//
//  Created by Andrija Cajic on 10/10/13.
//
//

#import "XEEChatInputView.h"
#import "XEEImageManager.h"
#import "UIView+Constraints.h"
#import "UIView+Frame.h"

#define DEFAULT_MIN_HEIGHT 52
#define DEFAULT_MAX_HEIGHT 150
#define DEFAULT_FONT_OFFSET 10
#define DEFAULT_FONT_SIZE 18
#define DEFAULT_TWEAK_RESIZER (-16)
#define DEFAULT_IMAGE_MAX_HEIGHT 100

#define COLOR_BACKGROUND UIColorFromRGB(0xd5d2de)


@implementation XEEChatInputView {
    /**
     View that is immediate parent of textView and imageView. Uses resizable image for a background.
     */
    UIImageView* _containerImageView;
    
    /**
     Insets of view container that holds both textView and imageView.
     */
    UIEdgeInsets _containerImageEdgeInsets;
    /**
     imageView insets
     */
    UIEdgeInsets _imageViewEdgeInsets;
    
    /**
     textView insets
     */
    UIEdgeInsets _textViewEdgeInsets;
    
    /**
     CGSize returned by intrinsicContentSize
     */
    CGSize _intrinsicSize;
    
    /**
     Width constraint for imageView. Exact value determined in the moment an exact UIImage is selected for imageView.
     */
    NSLayoutConstraint* _imageViewWidthConstraint;
    
    /**
     Height constraint for ChatInputView
     */
    NSLayoutConstraint* _constraintHeight;
    
    /**
     Constraints governing horizontal sequential positioning of photoButton, textView and submitButton.
     */
    NSArray* _horizontalConstraints;
    
    /**
     Image selected from UIImagePickerController.
     */
    UIImage* _selectedImage;
    
    /**
     Flag preventing execution of multiple animations that would otherwise cancel each other.
     */
    BOOL _animationPending;
    
    /**
     Gesture recognizer that is used for immitation of <code>scrolEnabled</code> property of UITextView. Using <code>scrolEnabled</code> property on iOS7 causes problems. Details: http://stackoverflow.com/questions/19657851/ios-7-uitextview-layoutsubviews-infinite-loop
    */
    UIPanGestureRecognizer* _scrollDisablerGR;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.minHeight = DEFAULT_MIN_HEIGHT;
        self.maxHeight = DEFAULT_MAX_HEIGHT;
        self.imageMaxHeight = DEFAULT_IMAGE_MAX_HEIGHT;
        self.fontOffset = DEFAULT_FONT_OFFSET;
        self.tweakResizer = DEFAULT_TWEAK_RESIZER;
        
        _imageViewEdgeInsets = UIEdgeInsetsMake(5, 2, 5, 2); // placeholder image for text view dictates what will be insets for textView
        _containerImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ChatInputBackground"] resizableImageWithCapInsets:_imageViewEdgeInsets]];
        _containerImageView.userInteractionEnabled = YES;
        _containerImageView.clipsToBounds = YES;
        
        [self addSubview:_containerImageView];
        
        _textViewEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 0);
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
//        _textView.font = FONT_ProximaNovaRegularOfSize(DEFAULT_FONT_SIZE);
        _textView.font = [UIFont fontWithName:@"Helvetica" size:20];
        _scrollDisablerGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(textViewScrollAction:)];
        [_textView addGestureRecognizer:_scrollDisablerGR];

        _textView.delegate = self;
        [_containerImageView addSubview:_textView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.hidden = YES;
        _imageView.userInteractionEnabled = YES;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        UIButton* removeImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [removeImageButton setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
        [removeImageButton addTarget:self action:@selector(removeImageButtonAction) forControlEvents:UIControlEventTouchDown];
        [_imageView addSubview:removeImageButton];
        
        [_imageView addConstraints:[removeImageButton setViewAlignToSuperviewsTopWithMargin:5.f]];
        [_imageView addConstraints:[removeImageButton setViewAlignToSuperviewsRightWithMargin:5.f]];
        
        [_containerImageView insertSubview:_imageView belowSubview:_textView];
        

        UIButton* submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitButton setTitle:NSLocalizedString(@"Send", @"Title for a button that submits a message in chat.") forState:UIControlStateNormal];
//        submitButton.titleLabel.font = FONT_ProximaNovaBoldOfSize(18);
        [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitButton setBackgroundImage:[[UIImage imageNamed:@"Button-Green"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
        self.submitButton = submitButton;
        
        UIButton* photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [photoButton setImage:[UIImage imageNamed:@"PurplePhoto"] forState:UIControlStateNormal];
        self.photoButton = photoButton;
        
        _containerImageEdgeInsets = UIEdgeInsetsMake(10.f, 0.f, 10.f, 0.f);
        [self addConstraints:[_containerImageView setViewAlignToSuperviewsTopWithMargin:_containerImageEdgeInsets.top]];
        [self addConstraints:[_containerImageView setViewAlignToSuperviewsBottomWithMargin:_containerImageEdgeInsets.bottom]];

        [self addConstraints:[_textView setViewToFillSuperviewWidthWithLeadingMargin:_textViewEdgeInsets.left trailingMargin:_textViewEdgeInsets.right]];
        [self addConstraints:[_textView setViewToFillSuperviewHeightWithTopMargin:_textViewEdgeInsets.top bottomMargin:_textViewEdgeInsets.bottom]];

        [self addConstraints:[_imageView setViewAlignToSuperviewsLeftWithMargin:_imageViewEdgeInsets.left]];
        [self addConstraint:[_imageView setViewHeight:self.imageMaxHeight]];
        _imageViewWidthConstraint = [_imageView setViewWidth:50.f]; // anything but 0
        [self addConstraint:_imageViewWidthConstraint];
        [self addConstraints:[_imageView setViewAlignToSuperviewsTopWithMargin:_imageViewEdgeInsets.top]];
        
        _constraintHeight = [self setViewHeight:self.intrinsicContentSize.height];
        [self addConstraint:_constraintHeight];
        
        NSLayoutConstraint* textViewWidthConstraint = [_textView setViewWidthToWidthOf:self];
        textViewWidthConstraint.priority = UILayoutPriorityDefaultLow - 10; // little weaker than a "Content hugging priority"
        [self addConstraint:textViewWidthConstraint];
        
    }
    return self;
}

-(void) setSubmitButton:(UIButton *)sendButton
{
    [self.submitButton removeFromSuperview];
    
    _submitButton = sendButton;
    [self addSubview:_submitButton];
    [_submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchDown];
    
    [self addConstraints:[_submitButton setViewWidth:59.f height:32.f]];
    [self addConstraints:[_submitButton setViewAlignToSuperviewsBottomWithMargin:10.f]];
    
    [self recreateHorizontalConstraints];
    
}


-(void) setPhotoButton:(UIButton *)photoButton
{
    [self.photoButton removeFromSuperview];
    
    _photoButton = photoButton;
    [self addSubview:_photoButton];
    [_photoButton addTarget:self action:@selector(photoButtonAction) forControlEvents:UIControlEventTouchDown];
    
    [self addConstraints:[_photoButton setViewWidth:26 height:30]];
    
    [self addConstraints:[_photoButton setViewAlignToSuperviewsBottomWithMargin:8.f]];
    
    [self recreateHorizontalConstraints];
}

-(void) recreateHorizontalConstraints
{
    if (_horizontalConstraints) {
        [self removeConstraints:_horizontalConstraints];
    }
    
    
    NSMutableArray* views = [NSMutableArray array];
    if (self.photoButton) {
        [views addObject:self.photoButton];
    }
    if (_containerImageView) {
        [views addObject:_containerImageView];
    }
    if (self.submitButton) {
        [views addObject:self.submitButton];
    }
    
    _horizontalConstraints = [UIView setViewsConsecutiveHorizontally:views alignToStart:YES paddingFromStart:10.f alignToEnd:YES paddingToEnd:10.f paddingInBetween:10.f];
    
    [self addConstraints:_horizontalConstraints];
}

-(void) setContainerImage:(UIImage *)containerImage
{
    _containerImageView.image = containerImage;
}
    
-(CGSize) intrinsicContentSize
{
    if (_textView.text.length == 0) {
        NSString* testString = @"Placeholder";
        
        CGSize size;
        if ([testString respondsToSelector:@selector(sizeWithAttributes:)]) {
            size = [testString sizeWithAttributes:@{NSFontAttributeName : _textView.font}];
        } else {
            size = [testString sizeWithFont:_textView.font];
        }
        _intrinsicSize = CGSizeMake(UIViewNoIntrinsicMetric, [self heightBasedOnTextViewHeight:size.height]);
    }
    return _intrinsicSize;
}


#pragma mark - UITextViewDelegate

-(void) textViewScrollAction:(UIPanGestureRecognizer*)panGestureRecognizer
{
    // this is simulating .scrollEnabled = NO
    // on textView
    // leave this blank
}
    
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString* newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    CGSize size = [self sizeForText:newString];
    
    CGFloat height = [self heightBasedOnTextViewHeight:size.height];
    
    if (height == self.maxHeight) {
        [self.textView removeGestureRecognizer:_scrollDisablerGR];
    } else {
        if (!_scrollDisablerGR.view) {
            [self.textView addGestureRecognizer:_scrollDisablerGR];
        }
    }

    if (self.frame.size.height != height) {
        CGFloat difference = height - self.frame.size.height;
        CGRect currentFrame = self.frame;
        [UIView animateWithDuration:0.1f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _intrinsicSize = CGSizeMake(UIViewNoIntrinsicMetric, currentFrame.size.height + difference);
            _constraintHeight.constant = _intrinsicSize.height;
            [self.superview layoutIfNeeded];
            
            if ([self.targetScrollView respondsToSelector:@selector(setContentOffset:animated:)]) {
                self.targetScrollView.contentInset = UIEdgeInsetsMake(self.targetScrollView.contentInset.top, self.targetScrollView.contentInset.left, self.targetScrollView.contentInset.bottom + difference, self.targetScrollView.contentInset.right);
                
                if (difference > 0) {
                    [self.targetScrollView setContentOffset:CGPointMake(0, self.targetScrollView.contentOffset.y + difference) animated:YES];
                }
                
                self.targetScrollView.scrollIndicatorInsets = self.targetScrollView.contentInset;
            }
    
        } completion:^(BOOL finished) {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                [self goToRange:range text:newString];
            }
        }];
    } else {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            [self goToRange:range text:newString];
        }
    }
    
    return YES;
}

-(CGSize) sizeForText:(NSString*)text
{
    if (text.length == 0) {
        text = @"Placeholder"; // will not be displayed, just a text that will be used for sizing in case textView is blank
    }
    
    if ([text hasSuffix:@"\n"]) {
        text = [text stringByAppendingString:@"o"]; // when calculating the size required for some text, usually trailing whitespaces are ignored. This is why here (just for calculation purposes) we insert one additional letter in the end of the string.
    }
    
    return [text sizeWithFont:self.textView.font constrainedToSize:CGSizeMake(self.textView.frame.size.width -self.textView.contentInset.left - self.textView.contentInset.right + self.tweakResizer, self.maxHeight + 1000) lineBreakMode:NSLineBreakByWordWrapping];
}

-(CGFloat) heightBasedOnTextViewHeight:(CGFloat)textViewHeight
{
    return MIN(self.maxHeight, MAX(textViewHeight + _textViewEdgeInsets.top + _textViewEdgeInsets.bottom + _containerImageEdgeInsets.top + _containerImageEdgeInsets.bottom + self.fontOffset, self.minHeight));
}

-(void) goToRange:(NSRange)range text:(NSString*)text
{
    NSString* behindCursorString = [text substringWithRange:NSMakeRange(0, range.location)];
    CGSize behindCursorSize = [self sizeForText:behindCursorString];
    
    float diff = behindCursorSize.height - self.textView.contentOffset.y;
    if (diff < 0 || diff > self.textView.height) {
        if (diff > self.textView.height) {
            diff -= self.textView.height;
        }
        if (!_animationPending) {
            _animationPending = YES;
            double delayInSeconds = 0.1f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.textView setContentOffset:CGPointMake(0, MIN(self.textView.contentSize.height, MAX(0, self.textView.contentOffset.y + diff))) animated:YES];
                double delayInSeconds1 = 0.5f;
                dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
                dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                    _animationPending = NO;
                });
            });
        }
    }
}

#pragma mark - button actions

-(void) submitButtonAction
{
    if (_selectedImage) {
        if ([self.delegate respondsToSelector:@selector(XEEChatInputView:submitImageMessage:)]) {
            [self.delegate XEEChatInputView:self submitImageMessage:_selectedImage];
        }
        
        [self configureMessageWithImage:nil];
        [self textView:_textView shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@""]; // this fixes contentInset and contentOffset of targetScrollView
    } else {
        NSString* text = _textView.text;
        _textView.text = @"";
        [self textView:_textView shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@""]; // this fixes contentInset and contentOffset of targetScrollView
        
        if (text.length > 0) {
            if ([self.delegate respondsToSelector:@selector(XEEChatInputView:submitTextMessage:)]) {
                [self.delegate XEEChatInputView:self submitTextMessage:text];
            }
        }
    }
}

-(void) photoButtonAction
{
    [[XEEImageManager sharedManager] showPromptSheetInView:self getImagePickerController:^(UIImagePickerController *picker) {
        picker.delegate = self;
                
        if ([self.delegate respondsToSelector:@selector(XEEChatInputView:presentImagePickerController:)]) {
            [_textView endEditing:YES];
            [self.delegate XEEChatInputView:self presentImagePickerController:picker];
        }
    }];
}

-(void) removeImageButtonAction
{
    [self configureMessageWithImage:nil];
}

-(void) configureMessageWithImage:(UIImage*)image
{
    _selectedImage = image;
    
    if (image == nil) {
        _imageView.hidden = YES;
        _textView.editable = YES;
        _textView.hidden = NO;
        
        
        _imageView.image = nil;
        _constraintHeight.constant = self.intrinsicContentSize.height;
        CGSize textViewSize = _textView.bounds.size;
        
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_textView scrollRectToVisible:CGRectMake(0, _textView.contentSize.height - textViewSize.height, _textView.width, _textView.height) animated:YES];
        });
        
        [self textView:_textView shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@""]; // this fixes contentInset and contentOffset of targetScrollView
    } else {
        _textView.editable = NO;
        _textView.hidden = YES;
        _imageView.hidden = NO;
        
        _imageView.image = image;
        
        CGFloat width = MIN(image.size.width * self.imageMaxHeight/image.size.height, _textView.width - _imageViewEdgeInsets.left - _imageViewEdgeInsets.right);
        _imageViewWidthConstraint.constant = width;
        
        _constraintHeight.constant = self.imageMaxHeight + _imageViewEdgeInsets.top + _imageViewEdgeInsets.bottom + _containerImageEdgeInsets.top + _containerImageEdgeInsets .bottom;
        
        float heightDiff = _constraintHeight.constant - self.height;
        [UIView animateWithDuration:0.2f animations:^{
            self.targetScrollView.contentInset = UIEdgeInsetsMake(self.targetScrollView.contentInset.top, self.targetScrollView.contentInset.left, self.targetScrollView.contentInset.bottom + heightDiff, self.targetScrollView.contentInset.right);
            [self.targetScrollView setContentOffset:CGPointMake(0, self.targetScrollView.contentOffset.y + heightDiff) animated:YES];
            
            self.targetScrollView.scrollIndicatorInsets = self.targetScrollView.contentInset;
            
            [self.superview layoutIfNeeded];
        }];
        
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* selectedImage = [info valueForKey:UIImagePickerControllerEditedImage];
    
    if (!selectedImage) {
        return;
    }
    
    [self configureMessageWithImage:selectedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end

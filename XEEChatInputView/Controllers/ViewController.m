//
//  ViewController.m
//  ChatInputView
//
//  Created by Andrija Cajic on 13/11/13.
//  Copyright (c) 2013 Andrija Cajic. All rights reserved.
//

#import "ViewController.h"
#import "XEEChatInputView.h"
#import "UIView+Constraints.h"
#import "UIView+Frame.h"
#import "ChatMessageCell.h"
#import "ChatMessage.h"

#define W_WIDTH (IS_IPAD?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width)
#define W_HEIGHT (IS_IPAD?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height)


@implementation ViewController {
    UITableView* _tableView;
    XEEChatInputView* _chatInputView;
    
    NSLayoutConstraint* _chatInputViewBottomConstraint;
    BOOL _isKeyboardShowing;
    
    NSMutableArray* _messages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    _messages = [NSMutableArray array];
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _chatInputView = [[XEEChatInputView alloc] init];
    _chatInputView.delegate = self;
    _chatInputView.targetScrollView = _tableView;
    [self.view addSubview:_chatInputView];
    
    [self.view addConstraints:[_tableView setViewToFillSuperview]];
    
    [self.view addConstraints:[_chatInputView setViewToFillSuperviewWidth]];
    _chatInputViewBottomConstraint = [_chatInputView setViewBottomToBottomOf:self.view withMargin:0.f];
    [self.view addConstraint:_chatInputViewBottomConstraint];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        _tableView.contentOffset = CGPointMake(0, INT_MAX);
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _tableView.contentInset = UIEdgeInsetsMake(_tableView.contentInset.top, _tableView.contentInset.left, _chatInputView.height + 5, _tableView.contentInset.right);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    if (_tableView.contentSize.height > _tableView.height) {
        _tableView.contentOffset = CGPointMake(0, _tableView.contentSize.height - _tableView.height + _tableView.contentInset.bottom);
    }
    
    _chatInputView.textView.contentOffset = CGPointMake(0, (_chatInputView.textView.contentSize.height - _chatInputView.textView.height) / 2);
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat keyboardHeight = MIN(kbSize.height, kbSize.width); // supporting both orientations
    int curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    float duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration delay:0.f options:curve animations:^{
        _chatInputViewBottomConstraint.constant = -keyboardHeight;
        [self.view layoutIfNeeded];
        _tableView.contentInset = UIEdgeInsetsMake(_tableView.contentInset.top, _tableView.contentInset.left, _chatInputView.height + keyboardHeight, _tableView.contentInset.right);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        if (_tableView.contentSize.height > _tableView.height-keyboardHeight) {
            [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height - _tableView.height + _tableView.contentInset.bottom) animated:NO];
        }
    } completion:^(BOOL finished) {
        
    }];
    
    
}

-(void) keyboardWillHide:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    //    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    int curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    float duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration delay:0.f options:curve animations:^{
        _chatInputViewBottomConstraint.constant = 0.f;
        [self.view layoutIfNeeded];
        _tableView.contentInset = UIEdgeInsetsMake(_tableView.contentInset.top, _tableView.contentInset.left, _chatInputView.height, _tableView.contentInset.right);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - ChatInputView delegate

-(void) XEEChatInputView:(XEEChatInputView *)chatInputView presentImagePickerController:(UIImagePickerController *)imagePickerController
{
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

-(void)XEEChatInputView:(XEEChatInputView *)chatInputView submitImageMessage:(UIImage *)image
{
    NSLog(@"User submitted image: %@", image);
    ChatMessage* chatMessage = [[ChatMessage alloc] init];
    chatMessage.text = nil;
    chatMessage.image = image;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:_messages.count inSection:0];
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [_messages addObject:chatMessage];
    [_tableView endUpdates];
    
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void) XEEChatInputView:(XEEChatInputView *)chatInputView submitTextMessage:(NSString *)text
{
    NSLog(@"User submitted text: %@", text);
    ChatMessage* chatMessage = [[ChatMessage alloc] init];
    chatMessage.text = text;
    chatMessage.image = nil;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:_messages.count inSection:0];
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [_messages addObject:chatMessage];
    [_tableView endUpdates];
    
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UITableViewDataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChatMessageCell class])];
    
    if (!cell) {
        cell = [[ChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ChatMessageCell class])];
    }
    
    ChatMessage* chatMessage = [_messages objectAtIndex:indexPath.row];
    
    [cell configureWithText:chatMessage.text image:chatMessage.image];
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

@end

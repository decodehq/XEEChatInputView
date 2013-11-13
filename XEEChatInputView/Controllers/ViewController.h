//
//  ViewController.h
//  ChatInputView
//
//  Created by Andrija Cajic on 13/11/13.
//  Copyright (c) 2013 Andrija Cajic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XEEChatInputView.h"

/**
 App's root view controller. Only for example purposes.
 */
@interface ViewController : UIViewController <XEEChatInputViewDelegate, UITableViewDataSource, UITableViewDelegate>

@end

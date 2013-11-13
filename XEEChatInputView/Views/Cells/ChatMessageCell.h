//
//  ChatMessageCell.h
//  ChatInputView
//
//  Created by Andrija Cajic on 13/11/13.
//  Copyright (c) 2013 Andrija Cajic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageCell : UITableViewCell

-(void) configureWithText:(NSString*)text image:(UIImage*)image;

@end

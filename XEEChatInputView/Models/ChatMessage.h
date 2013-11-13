//
//  ChatMessage.h
//  ChatInputView
//
//  Created by Andrija Cajic on 13/11/13.
//  Copyright (c) 2013 Andrija Cajic. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Dummy model for chat message.
 */
@interface ChatMessage : NSObject

@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) UIImage* image;

@end

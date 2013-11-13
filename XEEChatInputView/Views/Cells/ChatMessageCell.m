//
//  ChatMessageCell.m
//  ChatInputView
//
//  Created by Andrija Cajic on 13/11/13.
//  Copyright (c) 2013 Andrija Cajic. All rights reserved.
//

#import "ChatMessageCell.h"
#import "UIView+Frame.h"

@implementation ChatMessageCell {
    UILabel* _textLabel;
    UIImageView* _imageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor yellowColor];
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_textLabel];
    }
    return self;
}

-(void) configureWithText:(NSString*)text image:(UIImage*)image
{
    if (text) {
        _textLabel.text = text;
        [_textLabel sizeToFit];
        _textLabel.x = 5;
        _textLabel.y = 5;
    } else {
        _textLabel.text = nil;
    }
    
    if (image) {
        _imageView.image = image;
        _imageView.frame = CGRectMake(5, 5, 50, 50);
    } else {
        _imageView.image = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end

//
//  UIView+Constraints.m
//  UIBubbleTableViewExample
//
//  Created by Andrija Cajic on 10/11/13.
//
//

#import "UIView+Constraints.h"

@implementation UIView (XEEConstraints)


// if views are aligned to both begin and to the end, they will stretch/compress to fill superview
+(NSArray*) setViewsConsecutiveHorizontally:(NSArray*)views alignToStart:(BOOL)alignToStart alignToEnd:(BOOL)alignToEnd
{
    return [[self class] setViewsConsecutiveHorizontally:views alignToStart:alignToStart paddingFromStart:0 alignToEnd:alignToEnd paddingToEnd:0 paddingInBetween:0];
}

+(NSArray*) setViewsConsecutiveHorizontally:(NSArray*)views alignToStart:(BOOL)alignToStart paddingFromStart:(CGFloat)paddingStart alignToEnd:(BOOL)alignToEnd paddingToEnd:(CGFloat)paddingEnd paddingInBetween:(CGFloat)paddingBetween
{
    NSMutableArray* constraints = [NSMutableArray array];
    
    UIView* view;
    for (int i = 0; i < views.count; i++) {
        view = [views objectAtIndex:i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (i == 0) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeLeading multiplier:1.f constant:paddingStart]];
        } else {
            UIView* previousView = [views objectAtIndex:i-1];
            
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:paddingBetween]];
        }
    }
    
    if (alignToEnd) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-paddingEnd]];
    }
    
    return constraints;
}

+(NSArray*) setViewsConsecutiveVertically:(NSArray*)views alignToStart:(BOOL)alignToStart alignToEnd:(BOOL)alignToEnd
{
    return [[self class] setViewsConsecutiveVertically:views alignToStart:alignToStart paddingFromStart:0 alignToEnd:alignToEnd paddingToEnd:0 paddingInBetween:0];
}

+(NSArray*) setViewsConsecutiveVertically:(NSArray*)views alignToStart:(BOOL)alignToStart paddingFromStart:(CGFloat)paddingStart alignToEnd:(BOOL)alignToEnd paddingToEnd:(CGFloat)paddingEnd paddingInBetween:(CGFloat)paddingBetween
{
    NSMutableArray* constraints = [NSMutableArray array];
    
    UIView* view;
    for (int i = 0; i < views.count; i++) {
        view = [views objectAtIndex:i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (i == 0) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeTop multiplier:1.f constant:paddingStart]];
        } else {
            UIView* previousView = [views objectAtIndex:i-1];
            
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1.f constant:paddingBetween]];
        }
    }
    
    if (alignToEnd) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeBottom multiplier:1.f constant:-paddingEnd]];
    }
    
    return constraints;
}

    
-(NSArray*) setViewToFillSuperview
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray* constraints = [NSMutableArray array];
    
    NSDictionary* viewDictionary = NSDictionaryOfVariableBindings(self);
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:viewDictionary]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:nil views:viewDictionary]];
    
    return constraints;
}

-(NSArray*) setViewToFillSuperviewWidth
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view" : self}];
}

-(NSArray*) setViewToFillSuperviewWidthWithLeadingMargin:(CGFloat)leadingMargin trailingMargin:(CGFloat)trailingMargin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leadingMargin)-[view]-(trailingMargin)-|" options:0 metrics:@{@"leadingMargin" : @(leadingMargin), @"trailingMargin" : @(trailingMargin)} views:@{@"view" : self}];
}

-(NSArray*) setViewToFillSuperviewHeight
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view" : self}];
}

-(NSArray*) setViewToFillSuperviewHeightWithTopMargin:(CGFloat)topMargin bottomMargin:(CGFloat)bottomMargin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topMargin)-[view]-(bottomMargin)-|" options:0 metrics:@{@"topMargin" : @(topMargin), @"bottomMargin" : @(bottomMargin)} views:@{@"view" : self}];
}
    
        // careful! Maybe you need "setViewToFillSuperview"
-(NSArray*) setViewToMatchSizeOf:(UIView*)otherView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray* constraints = [NSMutableArray array];

    [constraints addObject:[self setViewWidthToWidthOf:otherView]];
    [constraints addObject:[self setViewHeightToHeightOf:otherView]];
    
    return constraints;
}

// aspectRatio is width/height like 16/9 or 4/3
-(NSLayoutConstraint*) setViewAspectRatio:(CGFloat)aspectRatio
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:aspectRatio constant:0];
}


-(NSArray*) setViewSizeToSizeOf:(UIView*)otherView
{
    NSMutableArray* constraints = [NSMutableArray array];
    [constraints addObject:[self setViewWidthToWidthOf:otherView]];
    [constraints addObject:[self setViewHeightToHeightOf:otherView]];
    return constraints;
}

-(NSLayoutConstraint*) setViewHeightToHeightOf:(UIView*)otherView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
//    otherView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeHeight multiplier:1.f constant:0.f];
}

-(NSLayoutConstraint*) setViewWidthToWidthOf:(UIView*)otherView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
//    otherView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeWidth multiplier:1.f constant:0.f];
}

-(NSArray*) setViewAlignToSuperviewsRightWithMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-margin-|" options:0 metrics:@{@"margin" : @(margin)} views:@{@"view" : self}];
}

-(NSArray*) setViewAlignToSuperviewsLeftWithMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[view]" options:0 metrics:@{@"margin" : @(margin)} views:@{@"view" : self}];
}


-(NSArray*) setViewAlignToSuperviewsBottomWithMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-margin-|" options:0 metrics:@{@"margin" : @(margin)} views:@{@"view" : self}];
}

-(NSArray*) setViewAlignToSuperviewsTopWithMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[view]" options:0 metrics:@{@"margin" : @(margin)} views:@{@"view" : self}];
}
    
-(NSArray*) setViewAlignToSuperviewsCenter
{
    NSMutableArray* constraints = [NSMutableArray array];
    [constraints addObject:[self setViewCenterXToCenterXOf:self.superview withMargin:0.f]];
    [constraints addObject:[self setViewCenterYToCenterYOf:self.superview withMargin:0.f]];
    
    return constraints;
}
    
-(NSLayoutConstraint*) setViewAlignToSuperviewsHorizontalCenter
{
    return [self setViewCenterXToCenterXOf:self.superview withMargin:0.f];
}
    
-(NSLayoutConstraint*) setViewAlignToSuperviewsVerticalCenter
{
    return [self setViewCenterYToCenterYOf:self.superview withMargin:0.f];
}

-(NSLayoutConstraint*) setViewBottomToBottomOf:(UIView*)otherView withMargin:(CGFloat)bottomMargin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-bottomMargin];
}

-(NSLayoutConstraint*) setViewBottomToCenterOf:(UIView*)otherView withMargin:(CGFloat)bottomMargin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-bottomMargin];
}

-(NSLayoutConstraint*) setViewBottomToTopOf:(UIView*)otherView withMargin:(CGFloat)bottomMargin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeTop multiplier:1.f constant:-bottomMargin];
}

-(NSLayoutConstraint*) setViewTopToBottomOf:(UIView*)otherView withMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeBottom multiplier:1.f constant:margin];
}

-(NSLayoutConstraint*) setViewTopToTopOf:(UIView*)otherView withMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeTop multiplier:1.f constant:margin];
}


-(NSLayoutConstraint*) setViewRightToRightSideOf:(UIView*)otherView withMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeRight multiplier:1.f constant:-margin];
}

-(NSLayoutConstraint*) setViewRightToCenterXOf:(UIView*)otherView withMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:margin];
}

- (NSLayoutConstraint*)setViewLeftToCenterXOf:(UIView*)otherView withMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:margin];
}

-(NSLayoutConstraint*) setViewRightToLeftSideOf:(UIView*)otherView withMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeLeft multiplier:1.f constant:-margin];
}

-(NSLayoutConstraint*) setViewLeftToLeftSideOf:(UIView*)otherView withMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeLeft multiplier:1.f constant:margin];
}

-(NSLayoutConstraint*) setViewLeftToRightSideOf:(UIView*)otherView withMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeRight multiplier:1.f constant:margin];
}

-(NSArray*) setViewCenterToCenterOf:(UIView*)otherView
{
    NSMutableArray* constraints = [NSMutableArray array];
    
    [constraints addObject:[self setViewCenterXToCenterXOf:otherView withMargin:0.f]];
    [constraints addObject:[self setViewCenterYToCenterYOf:otherView withMargin:0.f]];
    
    return constraints;
}

-(NSLayoutConstraint*) setViewCenterYToCenterYOf:(UIView*)otherView withMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:margin];
}

-(NSLayoutConstraint*) setViewCenterXToCenterXOf:(UIView*)otherView withMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:margin];
}

-(NSArray*) setViewCenter:(CGPoint)center
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* centerX = [self setViewCenterX:center.x];
    NSLayoutConstraint* centerY = [self setViewCenterY:center.y];
    
    return @[centerX, centerY];
}

-(NSLayoutConstraint*) setViewCenterX:(CGFloat)centerX
{
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeCenterX multiplier:0.f constant:centerX];
}

-(NSLayoutConstraint*) setViewCenterY:(CGFloat)centerY
{
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:Nil attribute:NSLayoutAttributeCenterY multiplier:0.f constant:centerY];
}


-(NSArray*) setViewWidth:(CGFloat)width height:(CGFloat)height
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary* viewDictionary = NSDictionaryOfVariableBindings(self);
    
    NSMutableArray* constraints = [NSMutableArray array];
    if (width > 0) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self(width)]" options:0 metrics:@{@"width" : @(width)} views:viewDictionary]];
    }
    if (height > 0) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(height)]" options:0 metrics:@{@"height" : @(height)} views:viewDictionary]];
    }
    
    return constraints;
}

-(NSLayoutConstraint*) setViewWidth:(CGFloat)width
{
    return [self setViewWidth:width height:0].lastObject;
}

-(NSLayoutConstraint*) setViewHeight:(CGFloat)height
{
    return [self setViewWidth:0 height:height].lastObject;
}
    
-(NSArray*) setViewMinimumSize:(CGSize)minimumSize maximumSize:(CGSize)maximumSize
{
    NSMutableArray* constraints = [NSMutableArray array];
    if (minimumSize.width > 0) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.f constant:minimumSize.width]];
    }
    if (minimumSize.height > 0) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.f constant:minimumSize.height]];
    }
    if (maximumSize.width > 0) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.f constant:maximumSize.width]];
    }
    if (maximumSize.height > 0) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.f constant:maximumSize.width]];
    }
    
    return constraints;
}

-(NSArray*) setViewMinimumSize:(CGSize)minimumSize
{
    return [self setViewMinimumSize:minimumSize maximumSize:CGSizeZero];
}

-(NSArray*) setViewMaximumSize:(CGSize)maximumSize
{
    return [self setViewMinimumSize:CGSizeZero maximumSize:maximumSize];
}

-(NSLayoutConstraint*) setViewMinimumWidth:(CGFloat)minimumWidth
{
    return [self setViewMinimumSize:CGSizeMake(minimumWidth, 0)].lastObject;
}
    
-(NSLayoutConstraint*) setViewMinimumHeight:(CGFloat)minimumHeight
{
    return [self setViewMinimumSize:CGSizeMake(0, minimumHeight)].lastObject;
}
    
-(NSLayoutConstraint*) setViewMaximumWidth:(CGFloat)maximumWidth
{
    return [self setViewMaximumSize:CGSizeMake(maximumWidth, 0)].lastObject;
}
    
-(NSLayoutConstraint*) setViewMaximumHeight:(CGFloat)maximumHeight
{
    return [self setViewMaximumSize:CGSizeMake(0, maximumHeight)].lastObject;
}
    
-(NSLayoutConstraint*) setViewHeightToPercentageOfSuperviewHeight:(CGFloat)percentageOfSuperviewHeight
{
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeHeight multiplier:percentageOfSuperviewHeight constant:0.f];
}

-(NSLayoutConstraint*) setViewWidthToPercentageOfSuperviewWidth:(CGFloat)percentageOfSuperviewWidth
{
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeWidth multiplier:percentageOfSuperviewWidth constant:0.f];
}

-(NSArray*) setViewToFillScrollViewPageHorizontally:(UIScrollView*)scrollView leadingMargin:(CGFloat)leadingMargin trailingMargin:(CGFloat)trailingMargin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray* constraints = [NSMutableArray array];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeLeading multiplier:1.f constant:leadingMargin]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-trailingMargin]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeWidth multiplier:1.f constant:-leadingMargin-trailingMargin]];
    
    return constraints;
}

-(NSArray*) setViewToFillScrollViewPageVertically:(UIScrollView*)scrollView leadingMargin:(CGFloat)leadingMargin trailingMargin:(CGFloat)trailingMargin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray* constraints = [NSMutableArray array];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTop multiplier:1.f constant:leadingMargin]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-trailingMargin]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeHeight multiplier:1.f constant:-leadingMargin-trailingMargin]];
    
    return constraints;
}

-(NSArray*) setViewToFillScrollViewPage:(UIScrollView*)scrollView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary* viewDictionary = NSDictionaryOfVariableBindings(self, scrollView);
    
    NSMutableArray* constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self(==scrollView)]|" options:0 metrics:nil views:viewDictionary]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self(==scrollView)]|" options:0 metrics:nil views:viewDictionary]];
    
    return constraints;
}


@end

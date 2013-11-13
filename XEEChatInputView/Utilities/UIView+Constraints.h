//
//  UIView+Constraints.h
//  UIBubbleTableViewExample
//
//  Created by Andrija Cajic on 10/11/13.
//
//

#import <UIKit/UIKit.h>

/**
 Helper category for simplification of constraint generation.
 */
@interface UIView (Constraints)


// if views are aligned to both begin and to the end, they will stretch/compress to fill superview
+(NSArray*) setViewsConsecutiveHorizontally:(NSArray*)views alignToStart:(BOOL)alignToStart alignToEnd:(BOOL)alignToEnd;

+(NSArray*) setViewsConsecutiveHorizontally:(NSArray*)views alignToStart:(BOOL)alignToStart paddingFromStart:(CGFloat)paddingStart alignToEnd:(BOOL)alignToEnd paddingToEnd:(CGFloat)paddingEnd paddingInBetween:(CGFloat)paddingBetween;

+(NSArray*) setViewsConsecutiveVertically:(NSArray*)views alignToStart:(BOOL)alignToStart alignToEnd:(BOOL)alignToEnd;

+(NSArray*) setViewsConsecutiveVertically:(NSArray*)views alignToStart:(BOOL)alignToStart paddingFromStart:(CGFloat)paddingStart alignToEnd:(BOOL)alignToEnd paddingToEnd:(CGFloat)paddingEnd paddingInBetween:(CGFloat)paddingBetween;

-(NSArray*) setViewToFillSuperview;

-(NSArray*) setViewToFillSuperviewWidth;

-(NSArray*) setViewToFillSuperviewWidthWithLeadingMargin:(CGFloat)leadingMargin trailingMargin:(CGFloat)trailingMargin;

-(NSArray*) setViewToFillSuperviewHeight;

-(NSArray*) setViewToFillSuperviewHeightWithTopMargin:(CGFloat)topMargin bottomMargin:(CGFloat)bottomMargin;

-(NSArray*) setViewToMatchSizeOf:(UIView*)otherView;

-(NSLayoutConstraint*) setViewAspectRatio:(CGFloat)aspectRatio;

-(NSArray*) setViewSizeToSizeOf:(UIView*)otherView;

-(NSLayoutConstraint*) setViewHeightToHeightOf:(UIView*)otherView;

-(NSLayoutConstraint*) setViewWidthToWidthOf:(UIView*)otherView;

-(NSArray*) setViewAlignToSuperviewsRightWithMargin:(CGFloat)margin;

-(NSArray*) setViewAlignToSuperviewsLeftWithMargin:(CGFloat)margin;

-(NSArray*) setViewAlignToSuperviewsBottomWithMargin:(CGFloat)margin;

-(NSArray*) setViewAlignToSuperviewsTopWithMargin:(CGFloat)margin;

-(NSArray*) setViewAlignToSuperviewsCenter;

-(NSLayoutConstraint*) setViewAlignToSuperviewsHorizontalCenter;
    
-(NSLayoutConstraint*) setViewAlignToSuperviewsVerticalCenter;

-(NSLayoutConstraint*) setViewBottomToBottomOf:(UIView*)otherView withMargin:(CGFloat)bottomMargin;

-(NSLayoutConstraint*) setViewBottomToCenterOf:(UIView*)otherView withMargin:(CGFloat)bottomMargin;

-(NSLayoutConstraint*) setViewBottomToTopOf:(UIView*)otherView withMargin:(CGFloat)bottomMargin;

-(NSLayoutConstraint*) setViewTopToBottomOf:(UIView*)otherView withMargin:(CGFloat)margin;

-(NSLayoutConstraint*) setViewTopToTopOf:(UIView*)otherView withMargin:(CGFloat)margin;

-(NSLayoutConstraint*) setViewRightToRightSideOf:(UIView*)otherView withMargin:(CGFloat)margin;

-(NSLayoutConstraint*) setViewRightToCenterXOf:(UIView*)otherView withMargin:(CGFloat)margin;

- (NSLayoutConstraint*)setViewLeftToCenterXOf:(UIView*)otherView withMargin:(CGFloat)margin;

-(NSLayoutConstraint*) setViewRightToLeftSideOf:(UIView*)otherView withMargin:(CGFloat)margin;

-(NSLayoutConstraint*) setViewLeftToLeftSideOf:(UIView*)otherView withMargin:(CGFloat)margin;

-(NSLayoutConstraint*) setViewLeftToRightSideOf:(UIView*)otherView withMargin:(CGFloat)margin;

-(NSArray*) setViewCenterToCenterOf:(UIView*)otherView;

-(NSLayoutConstraint*) setViewCenterYToCenterYOf:(UIView*)otherView withMargin:(CGFloat)margin;

-(NSLayoutConstraint*) setViewCenterXToCenterXOf:(UIView*)otherView withMargin:(CGFloat)margin;

-(NSArray*) setViewCenter:(CGPoint)center;

-(NSLayoutConstraint*) setViewCenterX:(CGFloat)centerX;

-(NSLayoutConstraint*) setViewCenterY:(CGFloat)centerY;

-(NSArray*) setViewWidth:(CGFloat)width height:(CGFloat)height;

-(NSLayoutConstraint*) setViewWidth:(CGFloat)width;

-(NSLayoutConstraint*) setViewHeight:(CGFloat)height;
    
-(NSArray*) setViewMinimumSize:(CGSize)minimumSize maximumSize:(CGSize)maximumSize;
    
-(NSArray*) setViewMinimumSize:(CGSize)minimumSize;
    
-(NSArray*) setViewMaximumSize:(CGSize)maximumSize;
    
-(NSLayoutConstraint*) setViewMinimumWidth:(CGFloat)minimumWidth;
    
-(NSLayoutConstraint*) setViewMinimumHeight:(CGFloat)minimumHeight;
    
-(NSLayoutConstraint*) setViewMaximumWidth:(CGFloat)maximumWidth;
    
-(NSLayoutConstraint*) setViewMaximumHeight:(CGFloat)maximumHeight;

-(NSLayoutConstraint*) setViewHeightToPercentageOfSuperviewHeight:(CGFloat)percentageOfSuperviewHeight;

-(NSLayoutConstraint*) setViewWidthToPercentageOfSuperviewWidth:(CGFloat)percentageOfSuperviewWidth;

-(NSArray*) setViewToFillScrollViewPageHorizontally:(UIScrollView*)scrollView leadingMargin:(CGFloat)leadingMargin trailingMargin:(CGFloat)trailingMargin;

-(NSArray*) setViewToFillScrollViewPageVertically:(UIScrollView*)scrollView leadingMargin:(CGFloat)leadingMargin trailingMargin:(CGFloat)trailingMargin;

-(NSArray*) setViewToFillScrollViewPage:(UIScrollView*)scrollView;

@end

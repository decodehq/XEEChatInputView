//
//  ImageManager.h
//  Vasizubi
//
//  Created by Andrija Cajic on 6/17/13.
//  Copyright (c) 2013 Andrija Cajic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ResultImagePickerVC) (UIImagePickerController* picker);

/**
 Singleton class that allows quick implementation of photo picker.
 */
@interface XEEImageManager : NSObject <UIActionSheetDelegate> {
    ResultImagePickerVC _resultBlock;
    UIImagePickerController* _picker;
}

+(instancetype) sharedManager;

-(void)showPromptSheetInView:(UIView*)view getImagePickerController:(ResultImagePickerVC)result;

@end

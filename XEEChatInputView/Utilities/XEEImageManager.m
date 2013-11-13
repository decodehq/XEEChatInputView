//
//  ImageManager.m
//  Vasizubi
//
//  Created by Andrija Cajic on 6/17/13.
//  Copyright (c) 2013 Andrija Cajic. All rights reserved.
//

#import "XEEImageManager.h"

#define BUTTON_TITLE_LIBRARY NSLocalizedString(@"Library", @"'Photo library' option when choosing source for photo")
#define BUTTON_TITLE_CAMERA NSLocalizedString(@"Camera", @"'Camera roll' option when choosing source for photo")

@implementation XEEImageManager

static XEEImageManager* imageManager;

+(instancetype) sharedManager {
    if (!imageManager) {
        imageManager = [[XEEImageManager alloc] init];
    }
    return imageManager;
}

-(id)init
{
    if (self = [super init]) {
    }
    return self;
}

-(void)showPromptSheetInView:(UIView*)view getImagePickerController:(ResultImagePickerVC)result
{
    _resultBlock = result;
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [menu addButtonWithTitle:BUTTON_TITLE_LIBRARY];
    }
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] ||
        [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        [menu addButtonWithTitle:BUTTON_TITLE_CAMERA];
    }
    
    [menu addButtonWithTitle:NSLocalizedString(@"Cancel", @"Option when you wish to cancel your current course of actions.")];
    menu.cancelButtonIndex = menu.numberOfButtons-1;
    [menu showInView:view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        [_picker setAllowsEditing:YES];
    }
    
    NSString* buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:BUTTON_TITLE_LIBRARY]) {
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if ([buttonTitle isEqualToString:BUTTON_TITLE_CAMERA]) {
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        return;
    }

    _resultBlock(_picker);
}

@end

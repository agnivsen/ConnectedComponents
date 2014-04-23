//
//  galleryViewController.h
//  ConnectedComponents
//
//  Created by agniva on 16/04/14.
//  Copyright (c) 2014 agniva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectedComponentLabelling.h"


@interface galleryViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    
    IBOutlet UIButton *thresholdPickerBtn;
    IBOutlet UIButton *saveToGalleryBtn;
    IBOutlet UIButton *cclBtn;
    IBOutlet UIButton *galleryBtn;
    IBOutlet UIButton *colorPickerDone;
    IBOutlet UILabel *labelCount;
    IBOutlet UIImageView *baseView;
    
    
    UIColor *colorThreshold;
}
- (IBAction)saveToGallery:(id)sender;
- (IBAction)launchColorPicker:(id)sender;
- (IBAction)colorPickerDoneAction:(id)sender;

- (IBAction)deployImagePicker:(id)sender;
- (IBAction)labelConnectedComponents:(id)sender;
@end

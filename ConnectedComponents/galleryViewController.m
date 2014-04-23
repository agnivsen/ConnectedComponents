//
//  galleryViewController.m
//  ConnectedComponents
//
//  Created by agniva on 16/04/14.
//  Copyright (c) 2014 agniva. All rights reserved.
//

#import "galleryViewController.h"

@interface galleryViewController ()

@end

@implementation galleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    labelCount.text = @"";
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    colorPickerDone.hidden = YES;
    colorThreshold = [[[UIColor alloc] init] retain];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveToGallery:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(baseView.image, Nil, Nil, Nil);
}

- (IBAction)launchColorPicker:(id)sender
{

    baseView.alpha = 0.1;
    cclBtn.alpha = 0.1;
    galleryBtn.alpha = 0.1;
    saveToGalleryBtn.alpha = 0.1;
    thresholdPickerBtn.alpha = 0.1;
    cclBtn.userInteractionEnabled = NO;
    galleryBtn.userInteractionEnabled = NO;
    saveToGalleryBtn.userInteractionEnabled = NO;
    thresholdPickerBtn.userInteractionEnabled = NO;
    
    colorPickerDone.hidden = NO;
    
    //Add color picker to your view
    
}

- (IBAction)colorPickerDoneAction:(id)sender
{
    baseView.alpha = 1.0;
    cclBtn.alpha = 1.0;
    galleryBtn.alpha = 1.0;
    saveToGalleryBtn.alpha = 1.0;
    thresholdPickerBtn.alpha = 1.0;
    cclBtn.userInteractionEnabled = YES;
    galleryBtn.userInteractionEnabled = YES;
    saveToGalleryBtn.userInteractionEnabled = YES;
    thresholdPickerBtn.userInteractionEnabled = YES;
    
    colorPickerDone.hidden = YES;
    
}

- (IBAction)deployImagePicker:(id)sender
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"errore accessing photo library"
                                                        message:@"device does not support photo library"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)labelConnectedComponents:(id)sender
{
    if(baseView.image == Nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No image selected"
                                                        message:@"Please load an image from gallery first"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        ConnectedComponentLabelling *ccl = [[ConnectedComponentLabelling alloc] init];
        baseView.image = [ccl twoPassCCL :baseView.image :[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:255.0]];
        labelCount.text = [NSString stringWithFormat:@"%d total unique elements",[ccl getUniqueElementCount]];
        [ccl release];
    }
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
   // NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage;
    
    originalImage = (UIImage *) [info objectForKey:
                                 UIImagePickerControllerOriginalImage]; //hope you haven't selected a video instead
    baseView.image = originalImage;
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    labelCount.text = @"";
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //[picker release];
}
@end

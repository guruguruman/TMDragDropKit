//
//  TMDragDropSampleViewController.m
//  TMDragDropSample
//
//  Created by Tomoyuki Kato on 11/04/29.
//  Copyright 2011 Tomoyuki Kato All rights reserved.
//

#import "TMDragDropSampleViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation TMDragDropSampleViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIView *dragLabelArea = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 200, 700)];
  dragLabelArea.backgroundColor = [UIColor grayColor];
  [self.view addSubview:dragLabelArea];
  
  UILabel *dragLabelRed = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
	dragLabelRed.text = @"Red";
  dragLabelRed.textColor = [UIColor whiteColor];
  dragLabelRed.backgroundColor = [UIColor redColor];
  dragLabelRed.layer.borderWidth = 2.;
  dragLabelRed.layer.borderColor = [UIColor lightGrayColor].CGColor;
  dragLabelRed.layer.cornerRadius = 0.5;
  dragLabelRed.textAlignment = UITextAlignmentCenter;
	
	[DDInstance registerDragItem:dragLabelRed
                           key:@"RedTest"
                       manager:self
                    withObject:nil];
	
	[dragLabelArea addSubview:dragLabelRed];
  [dragLabelRed release];
  UILabel *dragLabelBlue = [[UILabel alloc] initWithFrame:CGRectMake(50, 300, 100, 100)];
	dragLabelBlue.text = @"Blue";
  dragLabelBlue.textColor = [UIColor whiteColor];
  dragLabelBlue.backgroundColor = [UIColor blueColor];
  dragLabelBlue.layer.borderWidth = 2.;
  dragLabelBlue.layer.borderColor = [UIColor lightGrayColor].CGColor;
  dragLabelBlue.textAlignment = UITextAlignmentCenter;
  
	[DDInstance registerDragItem:dragLabelBlue
                           key:@"BlueTest"
                       manager:self
                    withObject:nil];
	
	[dragLabelArea addSubview:dragLabelBlue];
  [dragLabelBlue release];
  UILabel *dragLabelGreen = [[UILabel alloc] initWithFrame:CGRectMake(50, 550, 100, 100)];
	dragLabelGreen.text = @"Green";
  dragLabelGreen.textColor = [UIColor whiteColor];
  dragLabelGreen.backgroundColor = [UIColor greenColor];
  dragLabelGreen.layer.borderWidth = 2.;
  dragLabelGreen.layer.borderColor = [UIColor lightGrayColor].CGColor;
  dragLabelGreen.textAlignment = UITextAlignmentCenter;
	
	[DDInstance registerDragItem:dragLabelGreen
                           key:@"GreenTest"
                       manager:self
                    withObject:nil];
	
	[dragLabelArea addSubview:dragLabelGreen];
  [dragLabelGreen release];
  
	
	UIView *dropViewRed = [[UIView alloc] initWithFrame:CGRectMake(300, 100, 400, 200)];
	dropViewRed.backgroundColor = [UIColor redColor];
	
  [DDInstance registerDropItem:dropViewRed
                           key:@"RedTest" 
                       manager:self];
  
	[self.view addSubview:dropViewRed];
	UIView *dropViewBlue = [[UIView alloc] initWithFrame:CGRectMake(300, 350, 400, 200)];
	dropViewBlue.backgroundColor = [UIColor blueColor];
	
  [DDInstance registerDropItem:dropViewBlue
                           key:@"BlueTest" 
                       manager:self];
  
	[self.view addSubview:dropViewBlue];
  UIView *dropViewGreen = [[UIView alloc] initWithFrame:CGRectMake(300, 600, 400, 200)];
	dropViewGreen.backgroundColor = [UIColor greenColor];
  [DDInstance registerDropItem:dropViewGreen
                           key:@"GreenTest" 
                       manager:self];
  
	[self.view addSubview:dropViewGreen];

  [dropViewRed release];
  [dropViewBlue release];
  [dropViewGreen release];
  
  UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 850, 650, 100)];
	descriptionLabel.text = @"NOTE:\nYou can drag each box colored on left dark gray area, and drop same colored box on right.\nBut you cannot drop different colored box.";
  descriptionLabel.backgroundColor = [UIColor darkGrayColor];
  descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
  descriptionLabel.numberOfLines = 0;
  [self.view addSubview:descriptionLabel];
  [descriptionLabel release];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end

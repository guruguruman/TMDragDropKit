//
//  UIImage+DD.m
//  TMDragDrop
//
//  Created by Tomoyuki Kato on 11/04/28.
//  Copyright 2011 Tomoyuki Kato. All rights reserved.
//

#import "UIImage+DD.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (DD) 
+ (UIImage *)viewAsImage:(UIView *)aView {
  if (!aView) {
    return nil;
  }
  UIGraphicsBeginImageContext(aView.bounds.size);
	[aView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *aViewAsImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	return aViewAsImage;
}
@end

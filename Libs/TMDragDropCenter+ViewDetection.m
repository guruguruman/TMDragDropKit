//
//  TMDragDropCenter+Detection.m
//  TMDragDrop
//
//  Created by Tomoyuki Kato on 11/04/28.
//  Copyright 2011 Tomoyuki Kato. All rights reserved.
//

#import "TMDragDropCenter.h"
#import "TMDrag.h"
#import "TMDrop.h"


@implementation TMDragDropCenter (Detection)
- (TMDrag *)detectedDragItemAt:(CGPoint)aPoint {
	UIView *detectedView = [[[UIApplication sharedApplication] keyWindow] hitTest:aPoint withEvent:nil];
  
  UIView *dumpedSuperView = detectedView;
  while (dumpedSuperView) {
    for (TMDrag *aDrag in self.dragItems) {
      if (dumpedSuperView == [aDrag dragView]) {
        return aDrag;
      }
      dumpedSuperView = nil;
      dumpedSuperView = [dumpedSuperView superview];
    }
  }
  for (UIView *subView in detectedView.subviews) {
    for (TMDrag *aDrag in self.dragItems) {
      CGRect theSubViewFrameOnKeyWindow = [[[aDrag dragView] superview] convertRect:[[aDrag dragView] frame] 
                                                                             toView:[[UIApplication sharedApplication] keyWindow]];
      if (CGRectContainsPoint(theSubViewFrameOnKeyWindow, aPoint) &&
          subView == [aDrag dragView]) {
        return aDrag;
      }
    }
  }
	return nil;
}

- (TMDrop *)detectedDropItemWithCurrentDragItem:(TMDrag *)aDrag atPoint:(CGPoint)aPoint {
	for (TMDrop *aDrop in self.dropItems) {
    if ([aDrop.dragDropIdentifier isEqualToString:aDrag.dragDropIdentifier]) {
      CGRect theDropViewFrameOnKeyWindow = [[[aDrop dropView] superview] convertRect:[[aDrop dropView] frame] toView:[[UIApplication sharedApplication] keyWindow]];
      if (CGRectContainsPoint(theDropViewFrameOnKeyWindow, aPoint)) {
        return aDrop;
      }
    }
	}
	return nil;
}
@end

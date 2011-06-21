//
//  TMDragDropCenter.m
//  TMDragDropKit
//
//  Created by Tomoyuki Kato on 11/04/23.
//  Copyright 2011 Tomoyuki Kato. All rights reserved.
//

#import "SynthesizeSingleton.h"
#import "TMDragDropCenter.h"
#import "TMDragDropCenter+ViewDetection.m"
#import "TMDrag.h"
#import "TMDrop.h"
#import "TMDragField.h"
#import "TMDragDelegate.h"
#import "TMDropDelegate.h"

#import "UIImage+DD.h"

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface TMDragDropCenter ()

- (void)animateCurrentDropView:(TMDrop *)aCurrentDrop detected:(BOOL)highlighted;
- (void)displayCursorViewFrom:(TMDrag *)aDrag atPoint:(CGPoint)aPoint;
- (void)moveCursorViewToTouchPoint:(CGPoint)point;
- (void)removeCursorViewWithSuccessAnimation:(TMDrag *)aDragItem;
- (void)removeCursorViewWithCancelAnimation:(TMDrag *)aDragItem toOrginalPoint:(CGPoint)aLoc;
- (void)clearCurrentObjects;

@property (nonatomic, readwrite, retain) NSMutableArray *dragItems;
@property (nonatomic, readwrite, retain) NSMutableArray *dropItems;
@property (nonatomic, readwrite, retain) NSMutableArray *draggableFields;
@property (nonatomic, readwrite, assign) TMDrag         *currentDragItem;
@property (nonatomic, readwrite, assign) TMDrop         *currentDropItem;
@property (nonatomic, readwrite, assign) CGPoint         previousTouchPoint;
@end


@implementation TMDragDropCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(TMDragDropCenter);
@synthesize cursorView          = cursorView_;
@synthesize dropItems           = dropItems_;
@synthesize dragItems           = dragItems_;
@synthesize draggableFields     = draggableFields_;
@synthesize currentDragItem     = currentDragItem_;
@synthesize currentDropItem     = currentDropItem_;
@synthesize previousTouchPoint  = previousTouchPoint_;

//-------------------------------------------------------------------------------------//
#pragma mark -- Initialize (Singleton) --
//-------------------------------------------------------------------------------------//

- (id)init
{
  if ((self = [super init])){
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    self.dragItems = [NSMutableArray array];
    self.dropItems = [NSMutableArray array];
    self.draggableFields = [NSMutableArray array];
	}
  return self;
}


- (void)dealloc {	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
  self.dropItems = nil;
  self.dragItems = nil;
  self.draggableFields = nil;
  self.currentDragItem = nil;
  self.currentDropItem = nil;
  self.cursorView = nil;
  self.previousTouchPoint = CGPointZero;
  [super dealloc];
}

//-------------------------------------------------------------------------------------//
#pragma mark -- Register objects -- 
//-------------------------------------------------------------------------------------//


- (void)applicationDidBecomeActive:(NSNotification *)notification {	
  
	UILongPressGestureRecognizer *aRecognizer = [[UILongPressGestureRecognizer alloc] 
																							 initWithTarget:self 
																							 action:@selector(GRHandler:)];
	aRecognizer.minimumPressDuration = 0.2;
	
	[[[UIApplication sharedApplication] keyWindow] addGestureRecognizer:aRecognizer];
	[aRecognizer release];
}

//TODO:
//I use keywindow for test, so rewrite to enable detection 
//any field.
- (void)registerDragField:(UIView *)aDragFieldView
                  withKey:(NSString *)aDragDropKey 
{
  TMDragField *aDragField = [[[TMDragField alloc] initWithView:aDragFieldView 
                                                           key:aDragDropKey] autorelease];
  UILongPressGestureRecognizer *aRecognizer = [[UILongPressGestureRecognizer alloc] 
																							 initWithTarget:self 
																							 action:@selector(GRHandler:)];
	aRecognizer.minimumPressDuration = 0.2;
	
	[aDragFieldView addGestureRecognizer:aRecognizer];
	[aRecognizer release];
  [self.draggableFields addObject:aDragField];
}

- (void)registerDragItem:(UIView *)aDragView 
                     key:(NSString *)aDropDragKey
                 manager:(NSObject <TMDragDelegate> *)aManager
              withObject:(id)anObject {
  TMDrag *aDrag = [[[TMDrag alloc] initWithView:aDragView
                                            key:aDropDragKey
                                        manager:aManager
                                      andObject:anObject] autorelease];
  [self.dragItems addObject:aDrag];
}

- (void)registerDropItem:(UIView *)aDropView
                     key:(NSString *)aDropDragKey
                 manager:(NSObject <TMDropDelegate> *)aManager {
  TMDrop *aDrop = [[[TMDrop alloc] initWithView:aDropView
                                            key:aDropDragKey
                                        manager:aManager] autorelease];
	[self.dropItems addObject:aDrop];
}


//-------------------------------------------------------------------------------------//
#pragma mark -- Handling gestures. -- 
//-------------------------------------------------------------------------------------//

- (void)GRHandler:(UIGestureRecognizer *)sender {
  
	CGPoint thePoint = [sender locationInView:[[UIApplication sharedApplication] keyWindow]];
  NSLog(@"Touched point in window = %@",NSStringFromCGPoint(thePoint));
  self.previousTouchPoint = thePoint;
  TMDrag *theDrag = nil;
	
	switch ([sender state]) {
		case UIGestureRecognizerStateBegan:{
			theDrag = [self detectedDragItemAt:thePoint];			
			if (nil == theDrag) {
				[sender setState:UIGestureRecognizerStateFailed];
        [self clearCurrentObjects];
				return;
			}
			self.currentDragItem = theDrag;
			if ([[self.currentDragItem manager] respondsToSelector:@selector(dragStartedForDrag:andDropTargets:)]) {
				[[self.currentDragItem manager] dragStartedForDrag:self.currentDragItem andDropTargets:self.dropItems];
			}
			[self displayCursorViewFrom:theDrag atPoint:thePoint];	
    }
			break;
		case UIGestureRecognizerStateChanged:{
			[self moveCursorViewToTouchPoint:thePoint];
      
      TMDrop *theDrop = [self detectedDropItemWithCurrentDragItem:[self currentDragItem] 
                                                          atPoint:thePoint];
      
      if (!theDrop && self.currentDropItem) {
        [self animateCurrentDropView:self.currentDropItem detected:NO];
				if ([[self.currentDropItem manager] respondsToSelector:@selector(dragItemDidLeaveFromDropItemForDrop:withDragItem:)]) {
					[[self.currentDropItem manager] dragItemDidLeaveFromDropItemForDrop:theDrop withDragItem:self.currentDragItem];
        }
				if ([[self.currentDragItem manager] respondsToSelector:@selector(dragItemDidLeaveFromDropItemForDrag:withDragItem:)]) {
					[[self.currentDragItem manager] dragItemDidLeaveFromDropItemForDrag:theDrop withDragItem:self.currentDragItem];
				}
        self.currentDropItem = nil;
      } else if (theDrop && !self.currentDragItem) {
        [self animateCurrentDropView:self.currentDropItem detected:YES];
        self.currentDropItem = theDrop;
				if ([[self.currentDropItem manager] respondsToSelector:@selector(dragItemDidEnterToDropItemForDrop:withDragItem:)]) {
					[[self.currentDropItem manager] dragItemDidEnterToDropItemForDrop:theDrop withDragItem:self.currentDragItem];
        }
				if ([[self.currentDragItem manager] respondsToSelector:@selector(dragItemDidEnterToDropItemForDrag:withDragItem:)]) {
					[[self.currentDragItem manager] dragItemDidEnterToDropItemForDrag:theDrop withDragItem:self.currentDragItem];
				}
      } else {
          //DO NOTHING.
      }
    }
			break;
		case UIGestureRecognizerStateEnded:{
      TMDrop *theDrop = [self detectedDropItemWithCurrentDragItem:self.currentDragItem 
                                                          atPoint:self.previousTouchPoint];			
			if (theDrop) {
				self.currentDropItem = theDrop;
				if ([[self.currentDropItem manager] respondsToSelector:@selector(dragItemDidCompletedOnDropItemForDrop:withDragItem:)]) {
					[[self.currentDropItem manager] dragItemDidCompletedOnDropItemForDrop:theDrop withDragItem:self.currentDragItem];
        }
				if ([[self.currentDragItem manager] respondsToSelector:@selector(dragItemDidCompletedOnDropItemForDrag:withDragItem:)]) {
					[[self.currentDragItem manager] dragItemDidCompletedOnDropItemForDrag:theDrop withDragItem:self.currentDragItem];
				}
				[self removeCursorViewWithSuccessAnimation:self.currentDragItem];
        [self animateCurrentDropView:self.currentDropItem detected:NO];
			} else {
        CGPoint orignalLoc = [[self.currentDragItem.dragView superview] 
                              convertPoint:self.currentDragItem.dragView.center 
                              toView:[[UIApplication sharedApplication] keyWindow]];
				[self removeCursorViewWithCancelAnimation:self.currentDragItem toOrginalPoint:orignalLoc];
				if ([[self.currentDropItem manager] respondsToSelector:@selector(dragItemDidCancelDropItemForDrop:withDragItem:)]) {
					[[self.currentDropItem manager] dragItemDidCancelDropItemForDrop:theDrop withDragItem:self.currentDragItem];
				}
				if ([[self.currentDragItem manager] respondsToSelector:@selector(dragItemDidCancelDropItemForDrag:withDragItem:)]) {
					[[self.currentDragItem manager] dragItemDidCancelDropItemForDrag:theDrop withDragItem:self.currentDragItem];
				}
			} 
      [self clearCurrentObjects];
    }
			break;
    case UIGestureRecognizerStateFailed:
		case UIGestureRecognizerStateCancelled:{
      CGPoint orignalLoc = [[self.currentDragItem.dragView superview] 
                            convertPoint:self.currentDragItem.dragView.center 
                            toView:[[UIApplication sharedApplication] keyWindow]];
      [self removeCursorViewWithCancelAnimation:self.currentDragItem toOrginalPoint:orignalLoc];
			if ([[self.currentDropItem manager] respondsToSelector:@selector(dragItemDidCancelDropItemForDrop:withDragItem:)]) {
				[[self.currentDropItem manager] dragItemDidCancelDropItemForDrop:self.currentDropItem withDragItem:self.currentDragItem];
			}
			if ([[self.currentDragItem manager] respondsToSelector:@selector(dragItemDidCancelDropItemForDrag:withDragItem:)]) {
				[[self.currentDragItem manager] dragItemDidCancelDropItemForDrag:self.currentDropItem withDragItem:self.currentDragItem];
			}			
			[self clearCurrentObjects];
    }
			break;
		default:{
        //DO NOTHING.
    }
			break;
	}
}


//-------------------------------------------------------------------------------------//
#pragma mark -- DropView operations. -- 
//-------------------------------------------------------------------------------------//

- (void)animateCurrentDropView:(TMDrop *)aCurrentDrop 
                      detected:(BOOL)detedced {
    //TODO:Write animation code for drag target.
}


//-------------------------------------------------------------------------------------//
#pragma mark -- CursorView operations. --
//-------------------------------------------------------------------------------------//

- (void)displayCursorViewFrom:(TMDrag *)aDrag atPoint:(CGPoint)aPoint {
  
	if (!self.cursorView) {
    //TODO:Fix the cursor view size and adjust thumb size to cursor view.
    //TODO:Write more better animation.
    UIImage *dragThumb = [UIImage viewAsImage:[aDrag dragView]];
		self.cursorView = [[[UIView alloc] initWithFrame:CGRectMake(aPoint.x,aPoint.y,dragThumb.size.width,dragThumb.size.height)] autorelease];
		UIImageView *dragThumbView = [[UIImageView alloc] initWithFrame:self.cursorView.bounds];
		dragThumbView.image = dragThumb;
		[self.cursorView addSubview:dragThumbView];		
		[dragThumbView release];
		
		[[[UIApplication sharedApplication] keyWindow] addSubview:self.cursorView];
    self.cursorView.transform = CGAffineTransformScale(self.cursorView.transform, 1./100., 1./100.);
    self.cursorView.alpha = .0;
    
    [UIView 
     animateWithDuration:0.2 
     delay:0 
     options:UIViewAnimationCurveEaseIn 
     animations:^{
       self.cursorView.transform = CGAffineTransformIdentity;
       self.cursorView.alpha = 1.;
     } 
     completion:^(BOOL finished){
         //DO NOTHING.
     }];
	}
}

- (void)moveCursorViewToTouchPoint:(CGPoint)point {
	self.cursorView.frame = CGRectMake(point.x,point.y,self.cursorView.frame.size.width,self.cursorView.frame.size.height);
}

- (void)removeCursorViewWithSuccessAnimation:(TMDrag *)aDragItem {
  //TODO:Write more better animation.
  [UIView 
   animateWithDuration:0.4 
   delay:0 
   options:UIViewAnimationCurveEaseInOut 
   animations:^{
     self.cursorView.transform = CGAffineTransformMakeScale(0.001, 0.001);
     self.cursorView.alpha = 0.0;
   } 
   completion:^(BOOL finished){
     [self.cursorView removeFromSuperview],self.cursorView = nil;
   }];
}

- (void)removeCursorViewWithCancelAnimation:(TMDrag *)aDragItem 
                             toOrginalPoint:(CGPoint)aLoc {
  //TODO:Write more better animation.
  [UIView 
   animateWithDuration:0.4 
   delay:0 
   options:UIViewAnimationCurveEaseInOut 
   animations:^{
     self.cursorView.center = aLoc;
     self.cursorView.alpha = 0.5;
   } 
   completion:^(BOOL finished){
     [self.cursorView removeFromSuperview],self.cursorView = nil;
   }];
}

//-------------------------------------------------------------------------------------//
#pragma mark -- Clear objects. --
//-------------------------------------------------------------------------------------//

- (void)clearCurrentObjects {
  self.currentDragItem = nil;
  self.currentDropItem = nil;
  self.previousTouchPoint = CGPointZero;
}

@end

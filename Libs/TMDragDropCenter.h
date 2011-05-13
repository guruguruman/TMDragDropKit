//
//  TMDragDropCenter.h
//  TMDragDropKit
//
//  Created by Tomoyuki Kato on 11/04/23.
//  Copyright 2011 Tomoyuki Kato. All rights reserved.
//

#define DDInstance [TMDragDropCenter sharedCenter]

@class TMDrag,TMDrop;
@protocol TMDragDelegate,TMDropDelegate;
@interface TMDragDropCenter : NSObject {
@private
  NSMutableArray  *dragItems_;
  NSMutableArray  *draggableFields_;
  NSMutableArray  *dropItems_;
  TMDrag          *currentDragItem_;
  TMDrop          *currentDropItem_;
  UIView          *cursorView_;
  CGPoint         previousTouchPoint_;
}

//-------------------------------------------------------------------------------------//
#pragma mark -- Initialize (Singleton) --
//-------------------------------------------------------------------------------------//
+ (TMDragDropCenter *)sharedCenter;

//-------------------------------------------------------------------------------------//
#pragma mark -- Register objects -- 
//-------------------------------------------------------------------------------------//
- (void)registerDragItem:(UIView *)aDragView 
                     key:(NSString *)aDropDragKey
                 manager:(id <TMDragDelegate>)aManager
              withObject:(id)anObject;
- (void)registerDropItem:(UIView *)aDropView
                     key:(NSString *)aDropDragKey
                 manager:(id <TMDropDelegate>)aManager;
- (void)registerDragField:(UIView *)aDragFieldView
                  withKey:(NSString *)aDragDropKey;

@property (nonatomic, readonly, retain) NSMutableArray *dragItems;
@property (nonatomic, readonly, retain) NSMutableArray *draggableFields;
@property (nonatomic, readonly, retain) NSMutableArray *dropItems;
@property (nonatomic, readonly, assign) TMDrag         *currentDragItem;
@property (nonatomic, readonly, assign) TMDrop         *currentDropItem;
@property (nonatomic, retain)           UIView         *cursorView;
@property (nonatomic, readonly, assign) CGPoint         previousTouchPoint;
@end

@interface TMDragDropCenter (ViewDetection)
//-------------------------------------------------------------------------------------//
#pragma mark -- View detection. -- 
//-------------------------------------------------------------------------------------//
- (TMDrag *)detectedDragItemAt:(CGPoint)aPoint;
- (TMDrop *)detectedDropItemWithCurrentDragItem:(TMDrag *)aDrag atPoint:(CGPoint)aPoint;
@end


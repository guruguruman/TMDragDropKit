//
//  TMDragDelegate.h
//  TMDragDropKit
//
//  Created by Tomoyuki Kato on 11/04/23.
//  Copyright 2011 Tomoyuki Kato. All rights reserved.
//

@class TMDrop,TMDrag;
@protocol TMDragDelegate
@optional
- (void)dragStartedForDrag:(TMDrag *)theDrag andDropTargets:(NSMutableArray *)dropItems;
- (void)dragItemDidEnterToDropItemForDrag:(TMDrop *)theDrop withDragItem:(TMDrag *)theDrag;
- (void)dragItemDidLeaveFromDropItemForDrag:(TMDrop *)theDrop withDragItem:(TMDrag *)theDrag;
- (void)dragItemDidCompletedOnDropItemForDrag:(TMDrop *)theDrop withDragItem:(TMDrag *)theDrag;
- (void)dragItemDidCancelDropItemForDrag:(TMDrop *)theDrop withDragItem:(TMDrag *)theDrag;
@end

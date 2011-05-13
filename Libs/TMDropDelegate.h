//
//  TMDropDelegate.h
//  TMDragDropKit
//
//  Created by Tomoyuki Kato on 11/04/23.
//  Copyright 2011 Tomoyuki Kato. All rights reserved.
//

@class TMDrop,TMDrag;
@protocol TMDropDelegate
@optional
- (void)dragItemDidEnterToDropItemForDrop:(TMDrop *)theDrop withDragItem:(TMDrag *)theDrag;
- (void)dragItemDidLeaveFromDropItemForDrop:(TMDrop *)theDrop withDragItem:(TMDrag *)theDrag;
- (void)dragItemDidCompletedOnDropItemForDrop:(TMDrop *)theDrop withDragItem:(TMDrag *)theDrag;
- (void)dragItemDidCancelDropItemForDrop:(TMDrop *)theDrop withDragItem:(TMDrag *)theDrag;
@end

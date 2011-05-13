//
//  TMDrag.m
//  Drag
//
//  Created by Tomoyuki Kato on 11/04/23.
//  Copyright 2011 Tomoyuki Kato. All rights reserved.
//

#import "TMDrag.h"
#import "TMDragDelegate.h"


@implementation TMDrag
@synthesize dragView = dragView_;
@synthesize dragDropIdentifier = dragDropIdentifier_;
@synthesize manager = manager_;
@synthesize dataObject = dataObject_;

- (id)initWithView:(UIView *)aView
               key:(NSString *)aDragDropKey
           manager:(NSObject<TMDragDelegate> *)aManager
         andObject:(id)anObject {
  if (self = [super init]) {
		self.dragView = aView;
    self.dragDropIdentifier = aDragDropKey;
    self.manager = aManager;
    self.dataObject = anObject;
  }
  return self;
}

- (void)dealloc {
  self.dragView = nil;
  self.dragDropIdentifier = nil;
  self.manager = nil;
  self.dataObject = nil;
  [super dealloc];
}

@end

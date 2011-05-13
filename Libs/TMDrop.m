//
//  TMDrop.m
//  Drag
//
//  Created by Tomoyuki Kato on 11/04/23.
//  Copyright 2011 Tomoyuki Kato All rights reserved.
//

#import "TMDrop.h"
#import "TMDropDelegate.h"


@implementation TMDrop
@synthesize dropView = dropView_;
@synthesize dragDropIdentifier = dragDropIdentifier_;
@synthesize manager = manager_;
- (id)initWithView:(UIView *)aView
               key:(NSString *)aDragDropKey
           manager:(NSObject<TMDropDelegate> *)aManager {
  if (self = [super init]) {
    self.dropView = aView;
    self.dragDropIdentifier = aDragDropKey;
    self.manager = aManager;
  }
  return self;
}

- (void)dealloc {
  self.dropView = nil;
  self.dragDropIdentifier = nil;
  self.manager = nil;
  [super dealloc];
}

@end

//
//  TMDragField.m
//  TMDragDropSample
//
//  Created by Tomoyuki Kato on 11/05/10.
//  Copyright 2011 Tomoyuki Kato. All rights reserved.
//

#import "TMDragField.h"


@implementation TMDragField
@synthesize dragView = dragView_;
@synthesize dragDropIdentifier = dragDropIdentifier_;

- (id)initWithView:(UIView *)aView
               key:(NSString *)aDragDropKey {
  if (self = [super init]) {
		self.dragView = aView;
    self.dragDropIdentifier = aDragDropKey;
  }
  return self;
}

- (void)dealloc {
  self.dragView = nil;
  self.dragDropIdentifier = nil;
  [super dealloc];
}

@end
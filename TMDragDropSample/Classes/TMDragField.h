//
//  TMDragField.h
//  TMDragDropSample
//
//  Created by Tomoyuki Kato on 11/05/10.
//  Copyright 2011 Tomoyuki Kato. All rights reserved.
//

@interface TMDragField : NSObject {
	UIView                  *dragField_;
  NSString                *dragDropIdentifier_;
}
@property (nonatomic, assign) UIView                  *dragView;
@property (nonatomic, assign) NSString                *dragDropIdentifier;

- (id)initWithView:(UIView *)aView
               key:(NSString *)aDragDropKey;
@end

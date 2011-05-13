//
//  TMDrag.h
//  Drag
//
//  Created by Tomoyuki Kato on 11/04/23.
//  Copyright 2011 Tomoyuki Kato. All rights reserved.
//

@protocol TMDragDelegate;
@interface TMDrag : NSObject {
	UIView                  *dragView_;
  NSString                *dragDropIdentifier_;
  NSObject<TMDragDelegate> *manager_;
  id                      dataObject_;
}
@property (nonatomic, assign) UIView                  *dragView;
@property (nonatomic, assign) NSString                *dragDropIdentifier;
@property (nonatomic, assign) NSObject<TMDragDelegate> *manager;
@property (nonatomic, assign) id                      dataObject;

- (id)initWithView:(UIView *)aView
               key:(NSString *)aDragDropKey
           manager:(NSObject<TMDragDelegate> *)aManager
         andObject:(id)anObject;
@end

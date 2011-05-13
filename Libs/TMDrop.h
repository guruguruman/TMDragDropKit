//
//  TMDrop.h
//  Drag
//
//  Created by Tomoyuki Kato on 11/04/23.
//  Copyright 2011 Tomoyuki Kato All rights reserved.
//

@protocol TMDropDelegate;
@interface TMDrop : NSObject {
  UIView                      *dropView_;
  NSString                    *dragDropIdentifier_;
  NSObject <TMDropDelegate>   *manager_;
}
@property (nonatomic, assign) UIView                    *dropView;
@property (nonatomic, assign) NSString                  *dragDropIdentifier;
@property (nonatomic, assign) NSObject<TMDropDelegate>  *manager;
- (id)initWithView:(UIView *)aView
               key:(NSString *)aDragDropKey
           manager:(NSObject<TMDropDelegate> *)aManager;
@end

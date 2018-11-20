//
//  UIButton+EnlargeTouchArea.h
//  MaggieDating
//
//  Created by 包曙源 on 2018/4/12.
//  Copyright © 2018年 com.maggie.social.maggieDating. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

- (void)setEnlargeEdge:(CGFloat) size;
@end

//
//  UIView+FormScroll.m
//  NeXTTY
//
//  Created by Sem Voigtländer on 30/01/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (FormScroll)

-(void)scrollToY:(float)y;
-(void)scrollToView:(UIView *)view fromView:(UIView *)viewin;
-(void)scrollElement:(UIView *)view toPoint:(float)y;

@end

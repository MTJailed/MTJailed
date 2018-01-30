#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+FormScroll.h"


@implementation UIView (FormScroll)


-(void)scrollToY:(float)y
{
    
    [UIView beginAnimations:@"registerScroll" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    self.transform = CGAffineTransformMakeTranslation(0, y);
    [UIView commitAnimations];
    
}

-(void)scrollToView:(UIView *)view fromView:(UIView* )viewin
{
    CGRect oldFrame = viewin.frame;
    CGRect theFrame = view.frame;
    float y = theFrame.origin.y;
    y -= (y/1.7);
    printf("%f",-y+oldFrame.origin.y);
    [self scrollToY:-y+oldFrame.origin.y];
}


-(void)scrollElement:(UIView *)view toPoint:(float)y
{
    CGRect theFrame = view.frame;
    float orig_y = theFrame.origin.y;
    float diff = y - orig_y;
    if (diff < 0) {
        [self scrollToY:diff];
    }
    else {
        [self scrollToY:0];
    }
    
}

@end

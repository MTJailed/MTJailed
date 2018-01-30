//
//  DemoVC.m
//  NeXTTY
//
//  Created by Sem Voigtländer on 21/01/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#import "DemoVC.h"
#import "ConsoleViewController.h"
@interface DemoVC()
{
    
}
@end

@implementation DemoVC
- (UIViewController*) topMostController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}
- (void)viewDidLoad {
    self.Title.text = self.demoTitle;
    self.Title.textColor = self.ForegroundColor;
    self.Description.text = self.demoDescription;
    self.Description.textColor = self.ForegroundColor;
    self.Icon.image = self.demoIcon;
    self.view.backgroundColor = self.BackgroundColor;
    [super viewDidLoad];
}
@end

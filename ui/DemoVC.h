//
//  DemoVC.h
//  NeXTTY
//
//  Created by Sem Voigtländer on 21/01/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define HYPER_LOG
#import "NSLog+stdout.h"
@interface DemoVC : UIViewController
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) NSString *demoTitle;
@property (weak, nonatomic) NSString *demoDescription;
@property (weak, nonatomic) UIImage *demoIcon;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UITextView *Description;
@property (weak, nonatomic) IBOutlet UIImageView *Icon;
@property (strong, nonatomic) UIColor* BackgroundColor;
@property (strong, nonatomic) UIColor* ForegroundColor;
@end



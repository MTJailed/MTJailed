//
//  ViewController.m
//  NeXTTY
//
//  Created by Sem Voigtländer on 21/01/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#import "ConsoleViewController.h"
#import "APIManager.h"
#import "IOEnumerator.h"
#import "IOKitLib.h"
#import "ADV_CMDS.h"
#import "UIView+FormScroll.h"
#import <mach/mach.h>
#import <netdb.h>

#define COMMAND(str) [_argv[0] isEqualToString:str]
#define NSCARRAY(arr) [self CARRAY:arr];
@interface ConsoleViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property NSString* stdoutBuffer;
@property NSString* inputBuffer;
@property NSString* interpreter;
@property UIAlertController* ConsoleAlertView;
@property NSArray* argv;
@end

@implementation ConsoleViewController

- (char*)CARRAY:(NSArray*)arr {
    char* cArray[[arr count]];
    int i = 0;
    for(id item in arr)
    {
        cArray[i++] = (char*)[item UTF8String];
    }
    return *cArray;
}

- (void) printf:(NSString*)str
{
    _stdoutBuffer = [_stdoutBuffer stringByAppendingString:[@"" stringByAppendingString:str]];
    _textView.text = _stdoutBuffer;
    _inputBuffer = @"";
}

- (void)parseCommand:(NSString*)line {
    _argv = [line componentsSeparatedByString:@" "];
    _stdoutBuffer = [_stdoutBuffer stringByAppendingString:@"\n"];
    if(_argv==nil || _argv.count == 0)
    {
        [self printf:@""];
        return;
    }
    if(COMMAND(@"help"))
    {
        [self printf:@"NeXTTY version 0.1-prerelease arm64_v7\n"];
        [self printf:@"These commands are defined internally.\nType 'help' to see this list.\n"];
        [self printf:@"Type man 'name' to find out more about the function 'name'.\n"];
        [self printf:@"Use info 'NeXTTY' to find out more about the shell in general.\n\n"];
    }
    else if(COMMAND(@"ls"))
    {
        NSArray* ls_arguments = [NSArray array];
        if(_argv.count > 1)
        {
            for(int key = 1; key < _argv.count; key++)
            {
                ls_arguments = [ls_arguments arrayByAddingObject:_argv[key]];
            }
            NSString* output = ls(ls_arguments);
            [self printf:[output stringByAppendingString:@"\n"]];
        } else {
            [self printf:@""];
        }
    } else if(COMMAND(@"iotest"))
    {
        NSString* sandboxedClasses = [[IOEnumerator enumerate] componentsJoinedByString:@"\n"];
        [self printf:@"IOKit Sandbox Accessible Components: \n\n"];
        [self printf:sandboxedClasses];
        [self printf:@"\n\n"];
    }
    else if(COMMAND(@"uptime"))
    {
        [self printf:uptime()];
        [self printf:@"\n"];
    }
    else if(COMMAND(@"hostname"))
    {
        [self printf:[NSString stringWithUTF8String:ADVCMDS_GETHOSTNAME()]];
        [self printf:@"\n"];
    }
    else if(COMMAND(@"whoami"))
    {
        [self printf:whoami()];
        [self printf:@"\n"];
    }
    else if(COMMAND(@"clear"))
    {
        _textView.text = @"";
        _stdoutBuffer = _textView.text;
    }
    else {
        [self printf:@"Command not found.\n"];
    }
    _stdoutBuffer = [_textView.text stringByAppendingString:_interpreter];
    _textView.text = _stdoutBuffer;
    _textView.selectedRange = NSMakeRange(_textView.text.length + 100, 0);
    [_textView scrollRangeToVisible:NSMakeRange([_textView.text length] + 100, 1)];
    [_scrollview setScrollsToTop:YES];
}


-(void)viewDidLoad {
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"setupComplete"])
    {
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"DEMO"] animated:NO completion:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"setupComplete"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    _textView.delegate = self;
    [_textView setTintColor:[UIColor grayColor]];
    _interpreter = [NSString stringWithFormat: @"%s:~ %s$ ", ADVCMDS_GETHOSTNAME(), getlogin()];
    _textView.text = _interpreter;
    _stdoutBuffer = _textView.text;
    _inputBuffer = @"";
    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://c2.staticflickr.com/8/7567/16287443705_f0ed6e7c77_b.jpg"]];
    UIImage* image = [UIImage imageWithData:imageData];
    
    CGRect scaledImageRect = CGRectZero;
    CGSize newSize = self.view.frame.size;
    scaledImageRect.size.width = newSize.width;
    scaledImageRect.size.height = newSize.height;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;
    UIGraphicsBeginImageContextWithOptions( newSize, NO, 0 );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:scaledImage];
    [super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated {
    [self.view snapshotViewAfterScreenUpdates:YES];
    [_textView becomeFirstResponder];
    [super viewDidAppear:animated];
}




-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *resultString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSString* prefixString = _stdoutBuffer;
    NSRange prefixStringRange = [resultString rangeOfString:prefixString];
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        _stdoutBuffer = _textView.text;
        NSString* args = _inputBuffer;
        [self parseCommand:args];
        if (prefixStringRange.location == 0) {
            return YES;
        }
    }
    if (prefixStringRange.location == 0) {
        // prefix found at the beginning of result string
        _inputBuffer = [resultString stringByReplacingCharactersInRange:prefixStringRange withString:@""];
        return YES;
    }
    return NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

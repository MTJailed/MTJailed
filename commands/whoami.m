//
//  whoami.m
//  NeXTTY
//
//  Created by Sem Voigtländer on 30/01/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADV_CMDS.h"
#import <unistd.h>
#import <pwd.h>
#import <stdlib.h>
#import <stdio.h>
#import "whoami.h"
NSString* whoami()
{
    uid_t uid = geteuid();
    struct passwd *pw = getpwuid(uid);
    if (pw)
    {
        return [NSString stringWithUTF8String:pw->pw_name];
    } else
    {
        return @"unknown";
    }
    
}

//
//  whoami.m
//  NeXTTY
//
//  Created by Sem Voigtländer on 30/01/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

/*
 * Whoami is a UNIX standard command that comes shipped on most UNIX based systems.
 * Whoami: function for returning the effective username
 * Whoami can be used to examin the priviliges in a context
 * Whoami takes no parameters.
*/


#import <Foundation/Foundation.h>
#import "ADV_CMDS.h"
#import <unistd.h>
#import <pwd.h>
#import <stdlib.h>
#import <stdio.h>
#import "whoami.h"

NSString* whoami()
{
    uid_t uid = geteuid(); //Get the effective user ID
    struct passwd *pw = getpwuid(uid); //Get the information including the username belonging to the effective uid.
   
    //Here we check if we were able to get information about the effective user ID.
    if (pw)
    {
        return [NSString stringWithUTF8String:pw->pw_name]; //return the username belonging to the effective user id.
    } else
    {
        return @"unknown"; //When were unable to determine the current user's name we return unknown.
    }
    
}

//
//  uptime.m
//  NeXTTY
//
//  Created by Sem Voigtländer on 30/01/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <grp.h>
#import "uptime.h"
NSString* uptime()
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    int days, hours, mins;
    int uptime = (int)t.tv_sec;
    days = uptime / 86400;
    hours = (uptime / 3600) - (days * 24);
    mins = (uptime / 60) - (days * 1440) - (hours * 60);
    return [NSString stringWithFormat:@"Uptime: %ddays, %dhours, %dminutes, %dseconds ", days, hours, mins, uptime % 60];
}

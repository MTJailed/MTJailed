//
//  hostname.c
//  NeXTTY
//
//  Created by Sem Voigtländer on 23/01/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#include "hostname.h"
char* ADVCMDS_GETHOSTNAME()
{
    static char hostname[_POSIX_HOST_NAME_MAX]; //we won't overflow as the we take the maximum hostname size as buffer size
    gethostname(hostname, _POSIX_HOST_NAME_MAX); //store the hostname in the buffer (gethostname comes down to a sysctl call)
    return hostname;
}



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
    static char hostname[_POSIX_HOST_NAME_MAX];
    gethostname(hostname, _POSIX_HOST_NAME_MAX);
    return hostname;
}



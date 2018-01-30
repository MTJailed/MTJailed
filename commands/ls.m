//
//  ls.c
//  NeXTTY
//
//  Created by Sem Voigtländer on 23/01/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#include "ls.h"
#define LABEL_PREFIX ".label"
#define ADD_LS_MODE(str) modes = [modes arrayByAddingObject:str]
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NSString* ls(NSArray* args)
{
    NSFileManager *fman = [NSFileManager defaultManager];
    NSArray* modes = [NSArray array];
    NSString* file = [args lastObject];
    for(NSString* i in args)
    {
        if([i isEqualToString:@"-l"])
            ADD_LS_MODE(@"LIST");
        if([i isEqualToString:@"-a"])
            ADD_LS_MODE(@"HIDDEN");
        if([i isEqualToString:@"-t"])
            ADD_LS_MODE(@"PERMISSIONS");
        if([i isEqualToString:@"-r"])
            ADD_LS_MODE(@"ORDERBYOLD");
        if([i isEqualToString:@"-s"])
            ADD_LS_MODE(@"SIZE");
    }
    BOOL isDir = NO;
    BOOL exists = [fman fileExistsAtPath:file isDirectory:&isDir];
    if(exists)
    {
        if([fman isReadableFileAtPath:file])
        {
            if(modes.count > 0)
            {
                NSString* output = @"";
                id files;
                if(isDir)
                {
                    NSError *err = nil;
                    files = [fman contentsOfDirectoryAtPath:file error:&err];
                } else {
                    files = file;
                }
                if([modes containsObject:@"LIST"])
                {
                    output = [output stringByAppendingString:[files componentsJoinedByString:@"\n"]];
                    return output;
                } else
                {
                    return [output stringByAppendingString:[files componentsJoinedByString:@""]];
                }
                
            } else if(isDir){
                NSError* e = nil;
                return [[fman contentsOfDirectoryAtPath:file error:&e] componentsJoinedByString:@" "];
            } else
            {
                return file;
            }
        } else
        {
            return [NSString stringWithFormat:@"ls: %@: Permission denied.", file];
        }
    } else {
        return [NSString stringWithFormat:@"ls: %@: No such file or directory.", file];
    }
}

int
ends_with (const char *str, const char *suffix)
{
    if (!str || !suffix)
        return 0;
    
    size_t lenstr = strlen(str);
    size_t lensuffix = strlen(suffix);
    
    if (lensuffix >  lenstr)
        return 0;
    
    return strncmp(str + lenstr - lensuffix, suffix, lensuffix) == 0;
}

char* ADVCMDS_LS(int argc, char **argv)
{
    char *lookup_dir;
    int as_list = 0;
    
    if (argc == 2)
        if (strcmp(*(argv + 1), "-l") == 0) {
            as_list = 1;
            lookup_dir = ".";
        }
        else
            lookup_dir = *(argv + 1);
        else if (argc == 3 && strcmp(*(argv + 1), "-l") == 0) {
            as_list = 1;
            lookup_dir = *(argv + 2);
        }
        else
            lookup_dir = ".";
    
    DIR *dp;
    struct dirent *ep;
    char *result = "";
    dp = opendir (lookup_dir);
    if (dp != NULL) {
        while ((ep = readdir (dp))) {
            if (ep->d_type == DT_DIR) {
                char current_path[strlen(lookup_dir) + strlen(ep->d_name) + 1];
                strcpy(current_path, lookup_dir);
                strcat(current_path, "/");
                strcat(current_path, ep->d_name);
                if (as_list)
                    asprintf(&result, "%s%s\n", result, ep->d_name);
                else
                    asprintf(&result, "%s | %s\n", result, ep->d_name);
            }
        }
        if (!as_list)
            asprintf(&result, "%s\n", result);
        (void) closedir (dp);
    }
    else
        asprintf(&result, "%s\n", "Couldn't open the directory.");
    return result;
}

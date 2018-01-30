//
//  PreferenceManager.m
//  NeXTTY
//
//  Created by Sem Voigtländer on 30/01/2018.
//  Copyright © 2018 Jailed Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
void OpenTTYPreferences()
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:[NSDictionary dictionary] completionHandler:^(BOOL success){
        
    }];
}

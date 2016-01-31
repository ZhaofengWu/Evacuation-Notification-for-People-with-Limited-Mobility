//
//  Information.m
//  Emercuate
//
//  Created by 吴肇锋 on 1/30/16.
//  Copyright © 2016 RescueBots. All rights reserved.
//

#import "Information.h"

@interface Information ()

@end

@implementation Information

static NSMutableDictionary *info;
static NSString *chosenAdd;

+ (void)initialize {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    info = [userDefaults objectForKey:@"info"];
    if (!info) {
        info = [NSMutableDictionary
                       dictionaryWithDictionary:@{@"Name": @"John",
                                                  @"Address": [NSMutableDictionary
                                                               dictionaryWithDictionary: @{
                                                               @"Home": @[@"X street", @"X room"],
                                                               @"Work": @[@"Y street", @"Y room"]}],
                                                  @"Condition": @"Blind",
                                                  @"Medical ID": @"1234567",
                                                  @"Comments": @"N/A"}];
    }
    info = [NSMutableDictionary dictionaryWithDictionary:info];
    [info setObject:[NSMutableDictionary dictionaryWithDictionary:[info objectForKey:@"Address"]] forKey:@"Address"];
    chosenAdd = [userDefaults objectForKey:@"chosenAdd"];
    if (!chosenAdd) {
        chosenAdd = [[info objectForKey:@"Address"] allKeys][0];
    }
}
+ (int)count {
    return info.count;
}

+ (int)addressCount {
    return [[[info valueForKey:@"Address"] allKeys] count];
}

+ (NSArray *)entries {
    // TODO: make this cleaner
    return @[@"Name", @"Address", @"Condition", @"Medical ID",
             @"Comments"];
}

+ (NSDictionary *)information {
    return info;
}

+ (void)setValue:(id)value forEntry:(NSString *)entry {
    [info setValue:value forKey:entry];
}

+ (id)valueForEntry:(NSString *)entry {
    return [info valueForKey:entry];
}

+ (void)chooseAddress:(NSString *)name {
    chosenAdd = name;
}

+ (NSString *)chosenAddressName {
    return chosenAdd;
}

+ (void)addAddressByName:(NSString *)name street:(NSString *)street room:(NSString *)room {
    [[info valueForKey:@"Address"] setValue:@[street, room] forKey:name];
}

+ (void)save {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"info"]) {
        [userDefaults removeObjectForKey:@"info"];
    }
    NSLog(@"info: %@", info);
    [userDefaults setObject:info forKey:@"info"];
    if ([userDefaults objectForKey:@"chosenAdd"]) {
        [userDefaults removeObjectForKey:@"chosenAdd"];
    }
    [userDefaults setObject:chosenAdd forKey:@"chosenAdd"];
    [userDefaults synchronize];
}

@end

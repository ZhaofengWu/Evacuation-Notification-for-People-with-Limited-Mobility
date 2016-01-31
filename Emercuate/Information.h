//
//  Information.h
//  Emercuate
//
//  Created by 吴肇锋 on 1/30/16.
//  Copyright © 2016 RescueBots. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Information : NSObject

+ (int)count;
+ (int)addressCount;
+ (NSArray *)entries;
+ (NSDictionary *)information;
+ (void)setValue:(id)value forEntry:(NSString *)entry;
+ (id)valueForEntry:(NSString *)entry;
+ (void)chooseAddress:(NSString *)name;
+ (NSString *)chosenAddressName;
+ (void)addAddressByName:(NSString *)name street:(NSString *)street room:(NSString *)room;
+ (void)save;

@end

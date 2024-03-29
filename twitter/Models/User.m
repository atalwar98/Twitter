//
//  User.m
//  twitter
//
//  Created by atalwar98 on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        NSString *prefix = @"@";
        NSString *name = dictionary[@"screen_name"];
        self.screenName = [prefix stringByAppendingString:name];
        self.profileUrl = dictionary[@"profile_image_url_https"];
    }
    return self;
}
@end

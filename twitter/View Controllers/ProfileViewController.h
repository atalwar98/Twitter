//
//  ProfileViewController.h
//  twitter
//
//  Created by atalwar98 on 7/6/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *filteredTweets;
@end

NS_ASSUME_NONNULL_END

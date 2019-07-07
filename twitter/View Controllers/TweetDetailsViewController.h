//
//  TweetDetailsViewController.h
//  twitter
//
//  Created by atalwar98 on 7/6/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetDetailsViewController : UIViewController
@property (strong, nonatomic) Tweet *prevTweet;
@property (weak, nonatomic) IBOutlet UIButton *tweetDetailsFav;
@property (weak, nonatomic) IBOutlet UIButton *tweetDetailsRetweet;
@end

NS_ASSUME_NONNULL_END

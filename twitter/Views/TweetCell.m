//
//  TweetCell.m
//  twitter
//
//  Created by atalwar98 on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)refreshData{
    NSString *fav = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.favCount.text = fav;
    NSString *retweeted = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.retweetedCount.text = retweeted;
}

- (void)handleUnFavoriting{
    self.tweet.favoriteCount = self.tweet.favoriteCount - 1;
    self.tweet.favorited = NO;
    [self refreshData];
    [self.favButton setSelected:NO];
}

- (void)handleFavoriting{
    self.tweet.favoriteCount = self.tweet.favoriteCount + 1;
    self.tweet.favorited = YES;
    [self refreshData];
    [self.favButton setSelected:YES];
}

- (IBAction)didTapFavorite:(UIButton *)sender {
    if(self.tweet.favorited){
        [self handleUnFavoriting];
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else{
        [self handleFavoriting];
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (void)handleUnRetweeting{
    self.tweet.retweetCount = self.tweet.retweetCount - 1;
    self.tweet.retweeted = NO;
    [self refreshData];
    [self.retweetButton setSelected:NO];
}

- (void)handleRetweeting{
    self.tweet.retweetCount = self.tweet.retweetCount + 1;
    self.tweet.retweeted = YES;
    [self refreshData];
    [self.retweetButton setSelected:YES];
}

- (IBAction)didTapRetweet:(UIButton *)sender {
    if(self.tweet.retweeted){
        [self handleUnRetweeting];
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    } else{
        [self handleRetweeting];
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}
@end

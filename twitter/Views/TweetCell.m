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

- (IBAction)didTapFavorite:(UIButton *)sender {
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            self.tweet.favorited = YES;
            self.tweet.favoriteCount = self.tweet.favoriteCount + 1;
        }
        [self refreshData];
        
    }];
}

- (void) refreshData{
    NSString *fav = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.favCount.text = fav;
}

@end

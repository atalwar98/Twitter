//
//  TweetCell.m
//  twitter
//
//  Created by atalwar98 on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"

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
    self.tweet.favoriteCount = self.tweet.favoriteCount + 1;
    self.tweet.favorited = YES;
    
}
@end

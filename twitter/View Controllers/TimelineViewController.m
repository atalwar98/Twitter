//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//


#import "APIManager.h"
#import "AppDelegate.h"
#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"

#import "UIImageView+AFNetworking.h"
#import "TimelineViewController.h"
#import "TweetCell.h"
#import "TweetDetailsViewController.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tweetView;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (nonatomic, strong) NSMutableArray *tweets;
@end

@implementation TimelineViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //step 3 - view controller becomes datasource and delegate
    self.tweetView.dataSource = self;
    self.tweetView.delegate = self;
    //initializing pull to refresh control feature
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tweetView insertSubview:refreshControl atIndex:0];
    [self fetchTweets];
}

- (void)fetchTweets {
    //first time "shared" is called you are instantiating an APIManager instance:
    //step 4 - make an API request
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            //step 6 - view controller stores data passed into completion handler
            self.tweets = [NSMutableArray arrayWithArray:tweets];
            for (Tweet *tweetObj in tweets) {
                NSString *text = tweetObj.text;
                NSLog(@"%@", text);
            }
            //table view asks its datasource for numbersOfRows and cellForRowAt
            //step 7 - reload table view & step 8 because reload fxn calls numberOfRows and cellForRowAt
            [self.tweetView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//step 9 - returns number of items returned from API
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweets.count;
}

//step 10 - returns an instance of the custom cell with that reuse identifier
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *post = self.tweets[indexPath.row];
    User *user = post.user;
    tweetCell.tweet = post;
    tweetCell.tweetAuthor.text = user.name;
    tweetCell.tweetBody.text = post.text;
    tweetCell.tweetScreenName.text = user.screenName;
    tweetCell.tweetDate.text = post.createdAtString;
    NSString* retweetToString = [NSString stringWithFormat:@"%i", post.retweetCount];
    tweetCell.retweetedCount.text = retweetToString;
    NSString* favToString = [NSString stringWithFormat:@"%i", post.favoriteCount];
    tweetCell.favCount.text = favToString;
    NSString *profileUrl = user.profileUrl;
    NSURL *url = [NSURL URLWithString:profileUrl];
    [tweetCell.tweetImage setImageWithURL:url];
    return tweetCell;
}

// Makes a network request to get updated data, Updates the tableView with the new data, Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchTweets];
    [refreshControl endRefreshing];
}

- (void)didTweet:(Tweet *)tweet{
    [self.tweets insertObject:tweet atIndex:0];
    [self.tweetView reloadData];
}

- (IBAction)tapLogout:(UIBarButtonItem *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

 #pragma mark - Navigation

- (void)tweetDetailsSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    TweetCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tweetView indexPathForCell:tappedCell];
    Tweet *selectedTweet = self.tweets[indexPath.row];
    [self.tweetView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailsViewController *detailsController = [segue destinationViewController];
    detailsController.prevTweet = selectedTweet;
}

- (void)composeTweetSegue:(UIStoryboardSegue *)segue{
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
}

- (void)personalTweetsSegue:(UIStoryboardSegue *)segue{
    UINavigationController *navController = [segue destinationViewController];
    ProfileViewController *profileController = (ProfileViewController*)navController.topViewController;
    profileController.filteredTweets = [[NSMutableArray alloc] init];
    for(Tweet *tweetObj in self.tweets){
        NSString *userName = tweetObj.user.name;
        if ([userName isEqualToString:@"Anika Talwar"]){
            [profileController.filteredTweets addObject:tweetObj];
        }
    }
    for(Tweet *tweetObj in self.tweets){
        BOOL retweet = tweetObj.retweeted;
        if(retweet){
            [profileController.filteredTweets insertObject:tweetObj atIndex:0];
        }
    }
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if([segue.identifier  isEqual: @"tweetDetails"]){
         [self tweetDetailsSegue:segue sender:sender];
     } else if ([segue.identifier  isEqual: @"composeTweet"]){
         [self composeTweetSegue:segue];
     } else if ([segue.identifier  isEqual: @"personalTweets"]){
         [self personalTweetsSegue:segue];
     }
 }

@end

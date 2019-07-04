//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "User.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

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
    self.tweetView.rowHeight = 150;
    
    //initializing pull to refresh control feature
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
     [self.tweetView insertSubview:refreshControl atIndex:0];
    
    [self fetchTweets];
    
}

- (void) fetchTweets {
    // Get timeline
    //first time shared is called you are instantiating an APIManager instance:
    //step 4 - make an API request
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            //step 6 - view controller stores data passed into completion handler
            self.tweets = [NSMutableArray arrayWithArray:tweets];
            NSLog(@"set tweets successfully");
            for (Tweet *tweetObj in tweets) {
                NSString *text = tweetObj.text;
                NSLog(@"%@", text);
            }
            //table view asks its datasource for numbersOfRows and cellForRowAt
            //step 7 - reload table view
            //also step 8 because reload fxn calls numberOfRows and cellForRowAt
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
    tweetCell.tweetAuthor.text = user.name;
    tweetCell.tweetBody.text = post.text;
    tweetCell.tweetScreenName.text = user.screenName;
    tweetCell.tweetDate.text = post.createdAtString;
    NSString* retweetToString = [NSString stringWithFormat:@"%i", post.retweetCount];
    tweetCell.retweetCount.text = retweetToString;
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

-(void)loadMoreData{
    
    self.isMoreDataLoading = false;
    
    // ... Use the new data to update the data source ...
    [self fetchTweets];
    
    // Reload the tableView now that there is new data
    [self.tweetView reloadData];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Handle scroll behavior here
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tweetView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tweetView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tweetView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
        }
    }
}

- (void)didTweet:(Tweet *)tweet{
    [self.tweets addObject:tweet];
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
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     UINavigationController *navigationController = [segue destinationViewController];
     ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
     composeController.delegate = self;
 }

@end

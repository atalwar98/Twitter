//
//  ComposeViewController.m
//  twitter
//
//  Created by atalwar98 on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *composedTweet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *constructTweet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closingTweet;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.composedTweet.text = @"test4";
    // Do any additional setup after loading the view.
}

- (IBAction)closeTweet:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)newTweet:(UIBarButtonItem *)sender {
    [[APIManager shared] postStatusWithText:self.composedTweet.text completion:^(Tweet *tweet, NSError *error) {
        if (error){
            NSLog(@"Error with POST Request %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
        }
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

    




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

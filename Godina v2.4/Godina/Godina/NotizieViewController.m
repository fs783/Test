//
//  NotizieViewController.m
//  Godina
//
//  Created by Fabio on 14/09/12.
//  Copyright (c) 2012 Fabio. All rights reserved.
//

#import "NotizieViewController.h"
#import "DejalActivityView.h" // <= caricamento
//#import "ODRefreshControl.h"
#import "GANTracker.h"

@interface NotizieViewController ()

@end

@implementation NotizieViewController

@synthesize webNotizie;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
    webNotizie.delegate = self;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    [prefs setObject:nil forKey:@"nnl"];
    
    [prefs synchronize];
    
    [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
    
    NSError *err;
    
    [[GANTracker sharedTracker] trackPageview:@"/notizie" withError: &err];
    
    [[GANTracker sharedTracker] dispatch];

    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
    NSLog(@"View NOTIZIE CARICAMENTO ULTIMATO");
    [DejalBezelActivityView removeViewAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Caricamento"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:nil forKey:@"nnl"];
    
    [prefs synchronize];
    
    [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
    
    NSString *indirizzo = @"http://app.godina.it/newsios6/framework";
	//crea un oggetto URL
	NSURL *url = [NSURL URLWithString:indirizzo];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	// visualizza la pagina nella UIWebView
	[webNotizie loadRequest:requestObj];
    
    NSLog(@"View NOTIZIE ricaricata, leggo: %@", indirizzo);
    
//    [[self navigationController] tabBarItem].badgeValue = @"3";

    NSError *err;
    
    [[GANTracker sharedTracker] trackPageview:@"/notizie" withError: &err];
    
    [[GANTracker sharedTracker] dispatch];

    
}

@end

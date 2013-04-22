//
//  AltroViewController.m
//  Godina
//
//  Created by Fabio on 17/09/12.
//  Copyright (c) 2012 Fabio. All rights reserved.
//

#import "AltroViewController.h"
#import "DejalActivityView.h"
#import "GANTracker.h"

@interface AltroViewController ()

@end

@implementation AltroViewController

@synthesize altro;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    altro.delegate = self;
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Caricamento"];
      
    
    NSString *indirizzo = @"http://blog.godina.it";
	//crea un oggetto URL
	NSURL *url = [NSURL URLWithString:indirizzo];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	// visualizza la pagina nella UIWebView
	[altro loadRequest:requestObj];
       
    
    NSLog(@"Sto aprendo il seguente indizzo = %@", indirizzo);
    
    NSError *err;
    
    [[GANTracker sharedTracker] trackPageview:@"/blog" withError: &err];
    
    [[GANTracker sharedTracker] dispatch];

}



- (void)viewWillAppear:(BOOL)animated
{
    //DUPLICO IL CODICE PER POTER ottenere l'aggiornamento
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Caricamento"];
        
    NSString *indirizzo = @"http://blog.godina.it";
	//crea un oggetto URL
	NSURL *url = [NSURL URLWithString:indirizzo];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	// visualizza la pagina nella UIWebView
	[altro loadRequest:requestObj];
    
    
    NSLog(@"Sto aprendo il seguente indizzo = %@", indirizzo);
    
    NSError *err;
    
    [[GANTracker sharedTracker] trackPageview:@"/blog" withError: &err];
    
    [[GANTracker sharedTracker] dispatch];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
    NSLog(@"View ALTRO CARICAMENTO ULTIMATO");
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

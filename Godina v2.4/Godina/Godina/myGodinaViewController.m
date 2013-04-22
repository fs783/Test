//
//  myGodinaViewController.m
//  Godina
//
//  Created by Fabio on 14/09/12.
//  Copyright (c) 2012 Fabio. All rights reserved.
//

#import "myGodinaViewController.h"
#import "DejalActivityView.h"
#import "Reachability.h"
#import "GANTracker.h"


@interface myGodinaViewController ()

@end

@implementation myGodinaViewController

@synthesize ilMioGodina;



//- (void)webViewDidStartLoad:(UIWebView *)ilMioGodina {
//    [activityIndicator startAnimating];
//    // myLabel.hidden = FALSE;
//}



- (void)viewDidLoad
{


    [super viewDidLoad];
    
    ilMioGodina.delegate = self;

    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Caricamento"];
   
    NSString *indirizzo = @"http://www.godina.it";
	//crea un oggetto URL
	NSURL *url = [NSURL URLWithString:indirizzo];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
	// visualizza la pagina nella UIWebView
	[ilMioGodina loadRequest:requestObj];
    

    
    NSLog(@"Sto aprendo il seguente indizzo = %@", indirizzo);
    
    NSError *err;
    
    [[GANTracker sharedTracker] trackPageview:@"/il_mio_godina" withError: &err];
    
    [[GANTracker sharedTracker] dispatch];

}


- (void)viewWillAppear:(BOOL)animated
{
    //DUPLICO IL CODICE PER POTER ottenere l'aggiornamento

    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Caricamento"];
    NSString *indirizzo = @"http://www.godina.it";
	//crea un oggetto URL
	NSURL *url = [NSURL URLWithString:indirizzo];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	// visualizza la pagina nella UIWebView
	[ilMioGodina loadRequest:requestObj];
    
    NSLog(@"View NEGOZIO ricaricata, leggo: %@", indirizzo);
    
    NSError *err;
    
    [[GANTracker sharedTracker] trackPageview:@"/il_mio_godina" withError: &err];
    
    [[GANTracker sharedTracker] dispatch];

}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
    NSLog(@"View NEGOZIO CARICAMENTO ULTIMATO");
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

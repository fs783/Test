//
//  FirstViewController.m
//  Godina
//
//  Created by Fabio on 13/09/12.
//  Copyright (c) 2012 Fabio. All rights reserved.
//

#import "FirstViewController.h"
#import "Reachability.h"
#import "GANTracker.h"

@interface FirstViewController ()

@end


@implementation FirstViewController

@synthesize webView;


-(void)checkInternetConnection
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.godina.it"];
    NSInteger internetStatus = [r currentReachabilityStatus];
    if ((internetStatus == ReachableViaWiFi) | (internetStatus == ReachableViaWWAN))
    {
        [self checkNews];
              
        return;
    }
    
     if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        webView.hidden = YES;
        
        UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Connessione"   message:@" La connessione Internet sembra essere offline."delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil];
                [myAlert show];
                [myAlert release];

    }
}

-(void)carica_home  {
    
    NSString *indirizzo = @"http://app.godina.it/homeios6";
	//crea un oggetto URL
	NSURL *url = [NSURL URLWithString:indirizzo];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	// visualizza la pagina nella UIWebView
	[webView loadRequest:requestObj];
    NSLog(@"CARICO HOMEPAGE");
    
    NSError *err;
    
    [[GANTracker sharedTracker] trackPageview:@"/home" withError: &err];
    
    [[GANTracker sharedTracker] dispatch];

    
}

-(void)checkNews    {
    webView.hidden = FALSE;
    
  
    [self carica_home];
    
    NSURL *urlServerJSON = [NSURL URLWithString:@"http://app.godina.it/news/progressivo.php"];
    
    
    NSData *datiJSON = [NSData dataWithContentsOfURL:urlServerJSON];
    
    
    NSError* error;
    [NSJSONSerialization JSONObjectWithData:datiJSON options:kNilOptions error: &error];
    
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:datiJSON options:kNilOptions error:&jsonError];
    
    NSLog(@"Sto aprendo il seguente indizzo = %@",urlServerJSON);
    if (jsonObject) {
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            // Stiamo trattando un array
            NSArray *jsonArray = (NSArray *)jsonObject;
            NSLog(@"Array = %@",jsonArray);
            // Elaboro quindi le informazioni
        }
        else {
            // Stiamo trattando un dictionary
            NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            // CONTROLLO ULTIMO VALORE NEWS DISPONIBILE
            
            NSString *ultima_news_remota = [jsonDictionary objectForKey:@"num_news"];
            
            // ULTIMA NEWS MEMORIZZATA LOCALMENTE
            
            NSString *ultima_news_locale = [prefs stringForKey:@"ultima_notizia" ];
            
            NSString *notizie_non_lette = [prefs stringForKey:@"nnl" ];

            
            // trasformo i valori in interi
            NSInteger unr = [ultima_news_remota intValue];
            NSInteger unl = [ultima_news_locale intValue];
            NSInteger nnl = [notizie_non_lette intValue];

            NSInteger totNews = unr - unl + nnl;
            
            NSLog(@"valore ultima news database  -> %i", unr);
            
            NSLog(@"valore ultima news locale  -> %i", unl);
            
            NSLog(@"News non lette  -> %i", totNews);
            
            // CONVERTO INTERO IN STRINGA
            
            NSString *intString = [NSString stringWithFormat:@"%d", totNews];
            
            //MEMORIZZO IL NUOVO VALORE IN LOCALE
            
            [prefs setObject:[jsonDictionary objectForKey:@"num_news"] forKey:@"ultima_notizia"];
            
            //MEMORIZZO IL NUMERO DI NUOVE NEWS DA LEGGERE DA POTER USARE COME BADGE QUANDO L'APP
            // ENTRA IN BACKGROUND
            
            [prefs setObject:intString forKey:@"nnl"];
            
            [prefs synchronize];
            
            NSLog(@"NUOVO VALORE NEWS= %@", ultima_news_locale);
            
            // SE IL TOTALE È ZERO LO ANNULLO PER NON MOSTRARE BADGE
            
            
            if (totNews == 0)  {
                
                [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                
            } else {
                
                [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = intString;
                
            }

        }
    }

  
}


-(void)checkNewNews:(NSNotification *) notification  {
    
    // FUNZIONE CHE VIENE ATTUATA QUANDO VIENE CHIAMATA CHECKNEWNEWS DAL CENTRO NOTIFICHE
    
    [self checkInternetConnection];

}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//	[self carica_home];
//    NSLog(@"View NOTIZIE CARICAMENTO ULTIMATO");
//   
//}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNewNews:) name:@"checkNewNews" object:nil];
    
    webView.delegate=self;
    
    NSError *err;
    
    [[GANTracker sharedTracker] trackPageview:@"/home" withError: &err];
    
    [[GANTracker sharedTracker] dispatch];
    
    [self carica_home];

}

- (void)viewWillAppear:(BOOL)animated
{
//    [self checkInternetConnection];
   
    NSError *err;
    
    [[GANTracker sharedTracker] trackPageview:@"/home" withError: &err];
    
    [[GANTracker sharedTracker] dispatch];
    
}
                  
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

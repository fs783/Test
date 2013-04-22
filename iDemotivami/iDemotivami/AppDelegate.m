//
//  AppDelegate.m
//  iDemotivami
//
//  Created by FabioS on 16/04/13.
//  Copyright (c) 2013 Fabio Simi. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"

@implementation AppDelegate

@synthesize window;

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [splashView removeFromSuperview];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
     application.applicationSupportsShakeToEdit = YES;
    
    // controllare connessione internet
    // la stessa funzione ha al suo interno la funzione per l'aggiornamento del database delle frasi qual ora fosse obsoleto

    [self checkVersion];
    
    [self checkInternetConnection];
    
    
    //splah screen in movimento
    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
    splashView.image = [UIImage imageNamed:@"Default.png"];
    [window addSubview:splashView];
    [window bringSubviewToFront:splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:5.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 0.0;
    splashView.frame = CGRectMake(-60, -85, 440, 635);
    [UIView commitAnimations];
    
    // fine splash
        
    
    //percorso file su cartella documents
//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDir = [documentPaths objectAtIndex:0];
//    NSString *path = [documentsDir stringByAppendingPathComponent:@"elencoFrasi.plist"];
//	
//    //controllo se il file esiste
//    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
//    {
//        //se non esiste lo copio nella cartella dosuments
//		NSString *pathLocale=[[NSBundle mainBundle] pathForResource:@"elencoFrasi" ofType:@"plist"];
//		if ([[NSFileManager defaultManager] copyItemAtPath:pathLocale toPath:path error:nil] == YES)
//		{
//			NSLog(@"copia eseguita");
//		}
//    }
    
    
 //   [self checkInternetConnection];
    
    
    // controllo che la versione salvata sia la più aggiornata a disposizione
    
  
    
    
    
    return YES;
}

- (void)checkVersion {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *versione_locale =  [prefs stringForKey:@"versione_locale"];
    
    NSLog(@"Versione locale: %@", versione_locale);
    
    // PRIMO LANCIO APP, se la versione è nulla setta a 1.0
    if (versione_locale == NULL)
    {
        
        [prefs setObject:@"1" forKey:@"versione_locale"];
        
    }

    
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)checkInternetConnection
{
 Reachability *r = [Reachability reachabilityWithHostname:@"www.google.com"];
    NSInteger internetStatus = [r currentReachabilityStatus];
    if ((internetStatus == ReachableViaWiFi) | (internetStatus == ReachableViaWWAN))
    {
    
    [self checkFrasiVersione];
    
       
        //return;
    }
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        
        UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Connessione"   message:@" La connessione Internet sembra essere offline."delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil];
        [myAlert show];
        
    }
}

-(void)downloadPlist{
    

        // FUNZIONA PERFETTAMENTE
 
    NSString *stringURL = @"http://www.fabiosimi.com/idemotivami/elencoFrasi.plist";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
        {
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        NSString *path = [documentsDir stringByAppendingPathComponent:@"elencoFrasi.plist"];
      
        [urlData writeToFile:path atomically:YES];
        }
    
    

    
}


-(void)checkFrasiVersione   {

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    NSNumber *versione_locale = [NSNumber numberWithInt:[[prefs stringForKey:@"versione_locale"] intValue]];
    
    // nuovo thread asincrono per non bloccare l'app e verifcare la presenza di aggiornamenti
    
        //     dispatch_async(dispatch_get_main_queue(), ^{
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://fabiosimi.com/idemotivami/settings.json"]];
        
        NSError* error;
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        NSLog(@"Versione Plist Remoto -> %@",[json objectForKey:@"versione"]);
        
        
        NSNumber *remote_version = [NSNumber numberWithInt:[[json objectForKey:@"versione"] intValue]];
           
            

            if (versione_locale < remote_version)
            {
           
                NSLog(@"VERSIONE LOCALE MINORE....AGGIORNO I DATI!");
                
                //AGGIORNO VALORE LOCALE
                
               [prefs setObject:[json objectForKey:@"versione"] forKey:@"versione_locale"];
                
                
                // SCARICHIAMO IL NUOVO FILE PLIST E POSIZIONIAMOLO NELLA CARTELLA DOCUMENT SOVRASCRIVENDO IL PRECEDENTE
                
                [self downloadPlist];
                
            }
            
    if (versione_locale == remote_version)             {
    
            NSLog(@"STAI UTILIZZANDO L'ULTIMA VERSIONE DISPONIBILE");
    
    }
                // });
    
    
}



@end

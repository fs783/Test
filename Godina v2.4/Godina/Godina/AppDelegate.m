//
//  AppDelegate.m
//  Godina
//
//  Created by Fabio on 13/09/12.
//  Copyright (c) 2012 Fabio. All rights reserved.
//

#import "AppDelegate.h"
#import "GANTracker.h"

static const NSInteger kGANDispatchPeriodSec = 10;

@implementation AppDelegate

@synthesize window;

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [splashView removeFromSuperview];
    [splashView release];
}

//@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UIImage *navigationBarBackground = [UIImage imageNamed:@"godina_navbar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];

   
    // COLORIAMO LA TABBAR DI BIANCO  14-09-2012:18:17

    
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    
    // 12-04-2013 - 16:42
    
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        UITabBar *tabBar = tabBarController.tabBar;
        UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    
        [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"icona_home.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icona_home_white.png"]];

    
    
    NSLog(@"Registering for push notifications...");
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];

    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    
    // Make this interesting.
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
    splashView.image = [UIImage imageNamed:@"Default.png"];
    [window addSubview:splashView];
    [window bringSubviewToFront:splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 0.0;
    splashView.frame = CGRectMake(-60, -85, 440, 635);
    [UIView commitAnimations];

    
    // **************************************************************************
    // PLEASE REPLACE WITH YOUR ACCOUNT DETAILS.
    // **************************************************************************
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-36161057-1"
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
    
    NSError *error;
    if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1
                                                         name:@"iPhone1"
                                                        value:@"iv1"
                                                    withError:&error]) {
        // Handle error here
    }
    
    if (![[GANTracker sharedTracker] trackEvent:@"my_category"
                                         action:@"my_action"
                                          label:@"my_label"
                                          value:-1
                                      withError:&error]) {
        // Handle error here
    }
    
//    if (![[GANTracker sharedTracker] trackPageview:@"/app_entry_point"
//                                         withError:&error]) {
//        // Handle error here
//    }

    
    
    
    return YES;
    
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    

}


// PUSH NOTIFICATION

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *str =
    [NSString stringWithFormat:@"Device Token=%@",deviceToken];
    NSLog(@"%@", str);
    
    //18-09-2012:15:28 nuova registrazione token senza l'ausilio di librerie esterne
    
    NSDate *currentDateTime = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
   // NSLog(@"DATA&ORA: %@", dateInStringFormated);
    
    
    NSString *host = @"app.godina.it/apns";
    NSString *URLString = @"/apns-insert.php?token=";
    
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"< >;"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    URLString = [URLString stringByAppendingString:dt];

    NSString *firm_ver = [[UIDevice currentDevice] systemVersion];
    NSString *model =  [[UIDevice currentDevice] model];
    NSString *app_version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
       
    URLString = [URLString stringByAppendingString:@"&firmware="];
    URLString = [URLString stringByAppendingString:firm_ver];
    
    URLString = [URLString stringByAppendingString:@"&modello="];
    URLString = [URLString stringByAppendingString:model];
    
    URLString = [URLString stringByAppendingString:@"&app_version="];
    URLString = [URLString stringByAppendingString:app_version];
    
    URLString = [URLString stringByAppendingString:@"&ultima_visita="];
    URLString = [URLString stringByAppendingString:dateInStringFormated];

    
   

    
//    URLString = [URLString stringByAppendingString:dt];
    
    NSURL *url = [[[NSURL alloc] initWithScheme:@"http" host:host path:URLString] autorelease];
    
    NSLog(@"FullURL=%@", url);
    
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url] autorelease];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@", str);
    
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{

    //QUANDO L'APPLICAZIONE SI RISVEGLIA DALLO STATO DI BACKGROUND
//    AppDelegate *ad = ((AppDelegate *)([[UIApplication sharedApplication] delegate]));
//     UITabBar *tabBar = ad.tabBarController.tabBar;
//    
//    UITabBarItem *tbi = [ad.tabBar.items objectAtIndex:2];
//    tbi.badgeValue = @"ciao";
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *iconBadge = [prefs stringForKey:@"nnl"];
    
    NSLog(@"Notizie non lette: %@" , iconBadge);
           
    NSInteger icon = [iconBadge intValue];
   
    [UIApplication sharedApplication].applicationIconBadgeNumber = icon;


    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    NSLog(@"APPLICAZIONE RISVEGLIATA");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"checkNewNews" object:nil];


}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

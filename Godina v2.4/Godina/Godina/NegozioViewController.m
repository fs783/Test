//
//  NegozioViewController.m
//  Godina
//
//  Created by Fabio Simi on 15/09/12.
//  Copyright (c) 2012 Fabio. All rights reserved.
//

#import "NegozioViewController.h"
#import "MapAnnotation.h"
#import "Reachability.h"
#import "GANTracker.h"


@interface NegozioViewController ()

@end

@implementation NegozioViewController

@synthesize mappa;

-(void)checkInternetConnection
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.godina.it"];
    NSInteger internetStatus = [r currentReachabilityStatus];
    if ((internetStatus == ReachableViaWiFi) | (internetStatus == ReachableViaWWAN))
    {
        [self checkOrario];
        
        return;
    }
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        
        UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Connessione"   message:@" La connessione Internet sembra essere offline."delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil];
        [myAlert show];
        [myAlert release];
        
    }
}

-(void)mappaiOS6    {
    
    CLLocationCoordinate2D location;
    location.latitude = (double) 45.6526234;
    location.longitude = (double) 13.7766133;
    
    //CLLocationCoordinate2D coord = {latitude: 45.6526234, longitude: 13.7766133};
    MKCoordinateSpan span;
    span.latitudeDelta= (double) 0.007435;
    span.longitudeDelta= (double) 0.003130;
    
    
    MKPlacemark* p = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil];
    MKMapItem* item =  [[MKMapItem alloc] initWithPlacemark:p];
    item.name = @"Giuseppe Godina";
    item.phoneNumber = @"040 370444 ";
    item.url = [NSURL URLWithString:@"http://www.godina.it"];
    
    [item openInMapsWithLaunchOptions:@{ MKLaunchOptionsMapSpanKey : [NSValue valueWithMKCoordinateSpan:span] }];
    [p release];
    [item release];
    
    
}

-(void)mappaiOS5    {
    //  QUI LA FUNZIONE PER APRIRE LA MAPPA IN IOS5
    
    CLLocationCoordinate2D location;
    location.latitude = (double) 45.6526234;
    location.longitude = (double) 13.7766133;
    
    NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=Posizione+attuale&daddr=%f,%f", location.latitude, location.longitude];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    
    NSLog(@"GOOGLE: %@", url);
}

-(IBAction)bottone_telefono:(id)sender  {

    NSString *phoneNumber = [[[NSString alloc] initWithString:@"tel:040370444"] autorelease];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
    NSLog(@"Chiamo Godina");
}

-(IBAction)mappa_ios:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vuoi uscire dall'applicazione Godina per ottenere indicazioni?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
    [alert show];
    [alert release];
    
}

// TROVA LA VERSIONE DI iOS IN USO




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    NSLog(@" Stai usando la seguente versione di iOS= %f", version);

    
    if (buttonIndex == 0) {
		//do nothing
	}
	else
    {
        // SE HAI PREMUTO SI ED HAI UNA VERSIONE DEL FIRMWARE INFERIORE ALLA 6 USA GOOGLE MAPS
        
        if( buttonIndex == 1 & version <= 5.1)
        {
            [self mappaiOS5];
        
        } else  {
         
            [self mappaiOS6];
        
        }
        
        
	}
    
}



- (void)loadView
{
    [super loadView];
	mappa.delegate = self;
	mappa.showsUserLocation = YES;
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_iphone.jpg"]];
    CLLocationCoordinate2D location;
	location.latitude = (double) 45.6526234;
	location.longitude = (double) 13.7766133;
    
//    CLLocationCoordinate2D coord = {latitude: 45.6526234, longitude: 13.7766133};
    MKCoordinateSpan span;
    span.latitudeDelta= (double) 0.007435;
    span.longitudeDelta= (double) 0.003130;
    MKCoordinateRegion region = {location, span};
   
//    NSLog(@"Coordinate = %1.6f", location.latitude);


    [mappa setRegion:region];
    [mappa addAnnotation:[[[MapAnnotation alloc] init] autorelease]];

     
	}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *err;
    
    [[GANTracker sharedTracker] trackPageview:@"/negozio" withError: &err];
    
    [[GANTracker sharedTracker] dispatch];

}

- (void) viewDidAppear:(BOOL)animated   {
   
    NSError *err;
    
    [[GANTracker sharedTracker] trackPageview:@"/negozio" withError: &err];
    
    [[GANTracker sharedTracker] dispatch];
}


// Metodo che viene chiamato quando dobbiamo creare la view di una annotation.
// Se vogliamo usare quella di default usiamo come valore di ritorno nil
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	// Se dobbiamo creare l'annotation view relativa alla posizione dell'utente usiamo quella di default (il puntino blu)
	if (annotation == mapView.userLocation) {
		return nil;
	}

	
    // Altrimenti usiamo come annotation view un'immagine con un disclosure button sulla destra del callout

    
    MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"] autorelease];
	annotationView.image = [UIImage imageNamed:@"godina_marker.png"];
	annotationView.canShowCallout = YES;
	annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    annotationView.leftCalloutAccessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mappa.png"]] autorelease];
	return annotationView;

}

// Questo metodo viene invocato quando si preme un bottone presente nel callout
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	[self performSegueWithIdentifier:@"chi_siamo" sender:self];

}

- (void)caricaDati  {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://app.godina.it/orario_json.php"]];
        [self performSelectorOnMainThread:@selector(checkOrario:)
                               withObject:data waitUntilDone:YES]; });
    
}



  
-(void)checkOrario {
//    NSURL *urlServerJSON = [NSURL URLWithString:@"http://app.godina.it/orario_json.php"];
//    
//    NSData* datiJSON = [NSData dataWithContentsOfURL:urlServerJSON];
//    
//    NSError* error;
//    [NSJSONSerialization JSONObjectWithData:datiJSON options:kNilOptions error: &error];
//    
//    NSError *jsonError = nil;
//    
//    id jsonObject = [NSJSONSerialization JSONObjectWithData:datiJSON options:kNilOptions error:&jsonError];

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    dispatch_async(dispatch_get_main_queue(), ^{

    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://app.godina.it/orario_json.php"]];

    NSError* error;
        
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    //NSLog(@"Sto aprendo il seguente indizzo = %@",urlServerJSON);
    
//    if (jsonObject) {
//        if ([jsonObject isKindOfClass:[NSArray class]]) {
//            // Stiamo trattando un array
//            NSArray *jsonArray = (NSArray *)jsonObject;
//            NSLog(@"Array = %@",jsonArray);
//            // Elaboro quindi le informazioni
//        }
//        else {
//            // Stiamo trattando un dictionary
//            NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
        
            NSLog(@"ORARIO NEGOZIO -> :%@",[json objectForKey:@"orario"]);
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:[json objectForKey:@"orario"] forKey:@"orario_negozio"];
            
            [prefs stringForKey:@"orario_negozio"];
            
            NSString *orario_parse = [json objectForKey:@"orario"];
            
            jsonSummary.text = [[[NSString alloc] initWithString:orario_parse] autorelease];
        
    });
    
    orario_negozio.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"test_label.png"]];
    
    tel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"test_label.png"]];
    
    
    NSDate *currentDateTime = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];

    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
    NSLog(@"DATA&ORA: %@", dateInStringFormated);
    
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [self checkInternetConnection];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

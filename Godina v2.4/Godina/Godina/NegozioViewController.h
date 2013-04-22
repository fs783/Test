//
//  NegozioViewController.h
//  Godina
//
//  Created by Fabio Simi on 15/09/12.
//  Copyright (c) 2012 Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NegozioViewController : UIViewController <MKMapViewDelegate>   {
    MKMapView *mappa;
    IBOutlet UILabel* jsonSummary;
    IBOutlet UILabel* tel;
    IBOutlet UILabel* orario_negozio;
}

//-(IBAction)vediPercorso:(id)sender;
//- (IBAction) lanciaMappa:(id) sender;
-(IBAction)bottone_telefono:(id)sender;
-(IBAction)mappa_ios:(id)sender;

@property (strong, nonatomic) IBOutlet MKMapView *mappa;

@end

//
//  FirstViewController.m
//  iDemotivami
//
//  Created by FabioSimi783 on 16/04/13.
//  Copyright (c) 2013 Fabio Simi. All rights reserved.
//

#import "Home.h"

@interface Home ()

@end

@implementation Home

@synthesize textArea;

//necessario per rilevare shake

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.view setNeedsDisplay];
//    });
	// Do any additional setup after loading the view, typically from a nib.
    
        //controllo se la versione locale è impostata ad 1
    NSString* primaVersione = @"1";
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *versione_locale =  [prefs stringForKey:@"versione_locale"];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [path stringByAppendingPathComponent:@"elencoFrasi.plist"];
    
        // controllo valido solo se non c'è connessione e la versione dell'applicazione è la prima, quindi appena eseguito il
        // download...improbabile quindi, ma non per questo trascurabile
    
    if ([versione_locale isEqualToString:primaVersione] ) {
            
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"elencoFrasi" ofType:@"plist"];
     
            elencoFrasi = [[NSArray alloc] initWithContentsOfFile:filePath];
    }
    
    else {
    
        elencoFrasi = [[NSArray alloc] initWithContentsOfFile:finalPath];
        
    }
       
    
	srand (time(NULL));
	fraseCorrente = -1;
    [textArea setFont:[UIFont fontWithName: @"Museo-700" size:56]];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// FUNZIONE PER FAR RICONOSCERE LO SHAKE

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
		//[self showAlert];
        [self showNextAdvice:nil];
    }
}


-(void) showAlert {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vuoi uscire dall'applicazione Godina per ottenere indicazioni?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si", nil];
    [alert show];
    
    NSLog(@"GESTO SHAKE RILEVATO");

}

- (IBAction)showNextAdvice:(id)sender {
	int r;
	int maxIndex = [elencoFrasi count] - 1;
	if (fraseCorrente == -1) {
		r = rand() % maxIndex;
	}
	else {
		r = rand() % (maxIndex - 1);
		if (r == fraseCorrente) {
			r = maxIndex;
		}
		
	}
	fraseCorrente = r;
    [textArea setFont:[UIFont fontWithName: @"Museo-700" size:30]];
	[textArea setText:[elencoFrasi objectAtIndex:r]];
    NSLog(@"GESTO SHAKE RILEVATO:%@", [elencoFrasi objectAtIndex:r]);

}

@end

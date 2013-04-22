//
//  MapAnnotation.h
//  Godina
//
//  Created by Fabio Simi on 17/09/12.
//  Copyright (c) 2012 Fabio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MapAnnotation : NSObject <MKAnnotation>  {
	CLLocationCoordinate2D coordinate;
} 
@end

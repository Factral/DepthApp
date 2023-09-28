//
//  PngEncoder.h
//  DepthEstimation
//
//  Created by Hoover Rueda on 26/09/23.
//

#ifndef PngEncoder_h
#define PngEncoder_h
#include <Foundation/Foundation.h>

@interface PngEncoder : NSObject

- (instancetype) initWithDepth:(float *)content width:(int)width height:(int)height;
- (NSData*) fileContents;

@end
#endif

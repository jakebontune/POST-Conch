//
//  JVExtendedNSLogFuntionality.h
//  Health Bit
//
//  Created by Chef Cthulu on 1/11/15.
//  Copyright (c) 2015 JoeyVaughan. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define NSLog(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
#define NSLog(x...)
#endif

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

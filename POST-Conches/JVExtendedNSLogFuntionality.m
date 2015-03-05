//
//  JVExtendedNSLogFuntionality.m
//  Health Bit
//
//  Created by Chef Cthulu on 1/11/15.
//  Copyright (c) 2015 JoeyVaughan. All rights reserved.
//

#import "JVExtendedNSLogFuntionality.h"

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...) {
    // Type to hold information about variable arguments.
    va_list ap;
    
    // Initialize a variable argument list.
    va_start (ap, format);
    
    // NSLog only adds a newline to the end of the NSLog format if
    // one is not already there.
    // Here we are utilizing this feature of NSLog()
    if (![format hasSuffix: @"\n"]) {
        format = [format stringByAppendingString: @"\n"];
    }
    
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    
    // End using variable argument list.
    va_end (ap);
    
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    fprintf(stderr, "========================BEGIN LOG==========================\n(%s) (%s:%d) %s========================END LOG============================\n", functionName, [fileName UTF8String], lineNumber, [body UTF8String]);
}

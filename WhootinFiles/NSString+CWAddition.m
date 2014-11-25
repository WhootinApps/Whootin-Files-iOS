//
//  NSString+ CWAddition.m
//  OAuthSample
//
//  Created by Senthilkumar R on 24/09/12.
//  Copyright (c) 2012 Manthan Systems. All rights reserved.
//

@implementation NSString (NSAddition)

-(NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;   
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
			targetRange.length = endRange.location - targetRange.location;
			return [self substringWithRange:targetRange];
        }
    }
    return nil;
}
@end
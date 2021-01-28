//
//  main.m
//  Demo_CMD
//
//  Created by liudukun on 2021/1/28.
//  CURRENT_PROJECT_VERSION = 3;

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"tool for pbx file add build version; athor by liudukun \n");
        NSLog(@"build version add \n");
//        NSLog(@"%@ %@",argv[0],argv[1],argv[2]);
        NSString *path = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        NSError *error;
        NSMutableString *pText = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"error path , make parameter right");
            return 0;
        }
        NSLog(@"%@",path);
        NSRegularExpression *expression = [[NSRegularExpression alloc]initWithPattern:@"CURRENT_PROJECT_VERSION = [0-9]{1,};" options:0 error:&error];
        NSTextCheckingResult *cversion = [expression firstMatchInString:pText options:0 range:NSMakeRange(0, pText.length)];
        if(!cversion.numberOfRanges){
            NSLog(@"not found version , error path");
        }
        NSString *r2 = [pText substringWithRange: NSMakeRange(cversion.range.location, cversion.range.length)];
        
        NSRegularExpression *expression2 = [[NSRegularExpression alloc]initWithPattern:@"[0-9]{1,}" options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *nowVersion = [expression2 firstMatchInString:r2 options:NSMatchingReportCompletion range:NSMakeRange(0, r2.length)];
        if(!nowVersion.numberOfRanges){
            NSLog(@"not found version , error path");
        }
        NSString *r3 = [r2 substringWithRange: NSMakeRange(nowVersion.range.location, nowVersion.range.length)];
        NSLog(@"replace version: %@ + 1",r3);

        NSString *rs = [NSString stringWithFormat:@"CURRENT_PROJECT_VERSION = %i;",r3.intValue + 1];
        
        NSUInteger x =[expression replaceMatchesInString:pText options:0 range:NSMakeRange(0, pText.length) withTemplate:rs];
        NSLog(@"replace times: %@ , times = (target count * configure count) ,not contains pod targets",@(x));
        [pText writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"upadte pbx fail, not permission");
        }
        NSLog(@"build version add completed\n");

    }
    return 0;
}

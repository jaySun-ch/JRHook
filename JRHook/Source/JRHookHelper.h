//
//  JRHookHelper.h
//  JRHook
//
//  Created by sunzhixiong on 2023/8/17.
//

#ifndef JRHookHelper_h
#define JRHookHelper_h

#import <Foundation/Foundation.h>

#define JRHookLogError(...) do { NSLog(__VA_ARGS__); }while(0)

typedef NS_OPTIONS(NSUInteger,JRHookOption){
    JRHookBefore,
    JRHookAfter,
    JRHookReplace,
    JRHookWithCondition
};


extern NSMethodSignature * JRBlockGetMethodSignature(id block,NSError **error);

extern NSString *const JRHookErrorDomain;


#endif /* JRHookHelper_h */

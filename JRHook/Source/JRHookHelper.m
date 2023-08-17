//
//  JRHookHelper.m
//  JRHook
//
//  Created by sunzhixiong on 2023/8/17.
//
#import "JRHookHelper.h"

#import "JRBlock.h"

NSString *const JRHookErrorDomain = @"JRHookErrorDomain";

#define JRHookError(errorCode, errorDescription) do { \
JRHookLogError(@"JRHook: %@", errorDescription); \
if (error) { *error = [NSError errorWithDomain:JRHookErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey: errorDescription}]; }}while(0)

NSMethodSignature * JRBlockGetMethodSignature(id block,NSError **error){
    JRBlock hookBlock = (__bridge void *)block;
    if(!(hookBlock->flags & JRBlockHasSignature)){
        JRHookLogError(@"this block don't have signature");
        return nil;
    }
    JRBlockDescriptor desc = hookBlock->descriptor;
    const char *signature = desc->signature;
    if(!signature){
        JRHookLogError(@"this block don't have signature");
        return nil;
    }
    return [NSMethodSignature signatureWithObjCTypes:signature];
}



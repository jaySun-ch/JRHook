//
//  NSObject+JRHook.h
//  JRHook
//
//  Created by sunzhixiong on 2023/8/17.
//

#import <Foundation/Foundation.h>
#import "JRHookHelper.h"

typedef NSString * JRSelName;



NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JRHook)

- (void)JRHookWithSEL:(SEL)sel
                block:(id)block
               option:(JRHookOption)option
                error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END

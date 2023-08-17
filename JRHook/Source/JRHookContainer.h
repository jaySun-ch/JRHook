//
//  JRHookContainer.h
//  JRHook
//
//  Created by sunzhixiong on 2023/8/17.
//

#ifndef JRHookContainer_h
#define JRHookContainer_h

#import <Foundation/Foundation.h>
#import "JRHookIdentifier.h"
#import "JRBlock.h"

@interface JRHookContainer : NSObject

- (void)addHook:(JRHookIdentifier *)hookId;

- (void)removeHook:(JRHookIdentifier *)hookId;

- (void)removeAll;

@property (nonatomic,copy) NSArray *beforeHookBlock;
@property (nonatomic,copy) NSArray *afterHookBlock;
@property (nonatomic,copy) NSArray *replaceHookBlock;

@end


#endif /* JRHookContainer_h */

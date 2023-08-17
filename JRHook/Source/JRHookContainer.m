//
//  JRHookContainer.m
//  JRHook
//
//  Created by sunzhixiong on 2023/8/17.
//
#import "JRHookContainer.h"

@implementation JRHookContainer


- (void)addHook:(JRHookIdentifier *)hookId{
    NSParameterAssert(hookId);
    switch (hookId.option) {
        case JRHookBefore:
            self.beforeHookBlock = [(self.beforeHookBlock ? : @[]) arrayByAddingObject:hookId];
            break;
        case JRHookAfter:
            self.afterHookBlock = [(self.afterHookBlock ? : @[]) arrayByAddingObject:hookId];
            break;
        case JRHookReplace:
            self.replaceHookBlock = [(self.replaceHookBlock ? : @[]) arrayByAddingObject:hookId];
            break;
        case JRHookWithCondition:
            break;
    }
}

- (void)removeHook:(JRHookIdentifier *)hookId{
    NSParameterAssert(hookId);
    NSMutableArray *array;
    void(^removeBlock)(NSArray *blockArray) = ^(NSArray *blockArray){
        blockArray = [array copy];
    };
    switch (hookId.option) {
        case JRHookBefore:
            if(self.beforeHookBlock.count == 0){
                return;
            }
            array = [NSMutableArray arrayWithArray:self.beforeHookBlock];
            [array removeObject:hookId];
            removeBlock(self.beforeHookBlock);
            break;
        case JRHookAfter:
            if(self.afterHookBlock.count == 0){
                return;
            }
            array = [NSMutableArray arrayWithArray:self.afterHookBlock];
            [array removeObject:hookId];
//            removeBlock(self.afterHookBlock);
            break;
        case JRHookReplace:
            if(self.replaceHookBlock.count == 0){
                return;
            }
            array = [NSMutableArray arrayWithArray:self.replaceHookBlock];
            [array removeObject:hookId];
            removeBlock(self.replaceHookBlock);
            break;
        case JRHookWithCondition:
            break;
    }
}

- (void)removeAll{
    self.beforeHookBlock = [NSArray array];
    self.afterHookBlock = [NSArray array];
    self.replaceHookBlock = [NSArray array];
}



@end

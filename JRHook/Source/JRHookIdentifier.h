//
//  JRHookIdentifier.h
//  JRHook
//
//  Created by sunzhixiong on 2023/8/17.
//

#ifndef JRHookIdentifier_h
#define JRHookIdentifier_h

#import <Foundation/Foundation.h>
#import "JRHookHelper.h"

@interface JRHookIdentifier : NSObject

- (instancetype)initWithSel:(SEL)sel
                      block:(id)block
                     hookobject:(id)object
                     option:(JRHookOption)option
                      error:(NSError **)error;

@property (nonatomic,assign) SEL sel;

@property (nonatomic,weak) id object;

@property (nonatomic,strong) id block;

@property (nonatomic,assign) JRHookOption option;

@property (nonatomic,strong) NSMethodSignature *signature;




@end

#endif /* JRHookIdentifier_h */

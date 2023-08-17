//
//  JRHookIdentifier.m
//  JRHook
//
//  Created by sunzhixiong on 2023/8/17.
//


#import "JRHookIdentifier.h"

@implementation JRHookIdentifier

- (instancetype)initWithSel:(SEL)sel block:(id)block hookobject:(id)object option:(JRHookOption)option error:(NSError *__autoreleasing *)error{
    NSCParameterAssert(sel);
    NSCParameterAssert(block);
    NSCParameterAssert(object);
    
    JRHookIdentifier *identifier = nil;
    NSMethodSignature *signature = JRBlockGetMethodSignature(block,error);
    if(signature){
        identifier = [JRHookIdentifier new];
        identifier.object = object;
        identifier.block = block;
        identifier.sel = sel;
        identifier.option = option;
        identifier.signature = signature;
    }
    return identifier;
}








@end

//
//  NSObject+JRHook.m
//  JRHook
//
//  Created by sunzhixiong on 2023/8/17.
//

#import "NSObject+JRHook.h"
#import "JRBlock.h"
#import "JRHookContainer.h"
#import <os/lock.h>
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (JRHook)


- (void)JRHookWithSEL:(SEL)sel block:(id)block option:(JRHookOption)option error:(NSError *__autoreleasing  _Nullable *)error{
    /// 首先拿到需要hook的SEL 以及需要的Block
    NSCParameterAssert(self);
    NSCParameterAssert(sel);
    NSCParameterAssert(block);
    static os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
    os_unfair_lock_lock(&lock);
    JRHookContainer *container = [self hookContainerWithSEl:sel];
    JRHookIdentifier *identifier = [[JRHookIdentifier alloc] initWithSel:sel block:block hookobject:self option:option error:error];
    if(identifier){
        [container addHook:identifier];
        [self activeHookMethodWithSEl:sel error:error];
    }
    os_unfair_lock_unlock(&lock);
}

- (JRHookContainer *)hookContainerWithSEl:(SEL)sel{
    NSCParameterAssert(sel);
    JRHookContainer *container = nil;
    container = objc_getAssociatedObject(self,sel_getName(sel));
    if(!container){
        container = [JRHookContainer new];
         objc_setAssociatedObject(self,sel_getName(sel),[JRHookContainer new], OBJC_ASSOCIATION_RETAIN);
    }
    return container;
}

- (void)activeHookMethodWithSEl:(SEL)sel error:(NSError **)error{
    NSCParameterAssert(sel);
    Class class = [self JRHookSelfClassWithError:error];
    Method targetMethod = class_getInstanceMethod(class,sel);
    IMP targetMethodIMP = method_getImplementation(targetMethod);
    const char *typeCoding = method_getTypeEncoding(targetMethod);
    SEL JRNewSEL = NSSelectorFromString([NSString stringWithFormat:@"JRHookSel_%@",NSStringFromSelector(sel)]);
    if(![class instancesRespondToSelector:JRNewSEL]){
        __unused BOOL isAdd = class_addMethod(class,JRNewSEL,targetMethodIMP,typeCoding);
        NSAssert(isAdd,@"this method has been hooked");
        class_replaceMethod(class,sel,JRHook_getMsgForwardIMP(self,sel),typeCoding);
    }
}

static IMP JRHook_getMsgForwardIMP(NSObject *self, SEL selector) {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    // As an ugly internal runtime implementation detail in the 32bit runtime, we need to determine of the method we hook returns a struct or anything larger than id.
    // https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/LowLevelABI/000-Introduction/introduction.html
    // https://github.com/ReactiveCocoa/ReactiveCocoa/issues/783
    // http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042e/IHI0042E_aapcs.pdf (Section 5.4)
    Method method = class_getInstanceMethod(self.class, selector);
    const char *encoding = method_getTypeEncoding(method);
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(encoding, &valueSize, NULL);

            if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                methodReturnsStructValue = NO;
            }
        } @catch (__unused NSException *e) {}
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}


- (Class)JRHookSelfClassWithError:(NSError **)error{
    Class objectClass = [self class];
    Class baseClass = object_getClass(self);
    NSString *baseClassName = NSStringFromClass(baseClass);
    if([baseClassName hasSuffix:@"_JRHook_"]){
        return baseClass;
    }else if(class_isMetaClass(baseClass)){
        return [self JRHook_SwizzleClass:baseClass];
    }
}

static NSString *const JRHookForwardInvocationSelectorName = @"__JRHook_forwardInvocation:";

- (Class)JRHook_SwizzleClass:(Class)kclass{
    NSCParameterAssert(kclass);
    NSString *className = NSStringFromClass(kclass);
    static NSMutableSet *swizzleClass;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        swizzleClass = [NSMutableSet set];
    });
    @synchronized (swizzleClass) {
        if(![swizzleClass containsObject:className]){
            IMP originImp = class_replaceMethod(kclass,@selector(forwardInvocation:),nil, @"v@:@");
            if(originImp){
                class_addMethod(kclass,NSSelectorFromString(JRHookForwardInvocationSelectorName), originImp,@"v@:@");
            }
            [swizzleClass addObject:className];
        }
    }
    return kclass;
}

static void ForWardInvaction(__unsafe_unretained NSObject *self,SEL sel,NSInvocation *invocation){
    NSCParameterAssert(self);
    NSCParameterAssert(sel);
    NSCParameterAssert(invocation);
    
    SEL originSEL = invocation.selector;
    SEL newSEL =  NSSelectorFromString([NSString stringWithFormat:@"JRHook_%@",NSStringFromSelector(originSEL)]);
    invocation.selector = newSEL;
    
    
    
};




@end

//
//  JRBlock.h
//  JRHook
//
//  Created by sunzhixiong on 2023/8/17.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(int,JRBlockFlag){
    JRBlockHasSignature = 1<<10,
    JRBlockHasMethodHelper = 2<<10
};

typedef struct _JRBlockDescriptor{
    unsigned long int reserved;
    unsigned long int size;
    void (* copy)(void *old,const void *src);
    void (* dispose)(const void *);
    const char *signature;
    const char *layout;
} * JRBlockDescriptor;


typedef struct _JRHookBlock {
    __unused Class isa;
    __unused int reserved;
    JRBlockFlag flags;
    void (__unused *invoke)(struct _JRHookBlock *block, ...);
    JRBlockDescriptor descriptor;
    // imported variables
} * JRBlock;

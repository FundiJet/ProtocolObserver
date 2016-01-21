//
//  ProtocolObserver.m
//  ProtocolObserver
//
//  Created by Jet on 16/1/12.
//  Copyright © 2016年 Jet. All rights reserved.
//

#import "ProtocolObserver.h"
#import <objc/runtime.h>

@interface ProtocolObserver ()

@property (nonatomic, strong, readonly) Protocol *protocol;
@property (nonatomic, strong, readonly) NSMutableSet *observers;

@end

@implementation ProtocolObserver
- (instancetype)initWithProtocol:(Protocol *)protocol observers:(NSSet *)observers {
    if (self = [super init]) {
        _protocol = protocol;
        _observers = observers.mutableCopy;
    }
    return self;
}

- (void)addObserver:(id)observer {
    NSAssert([observer conformsToProtocol:self.protocol], @"Observer didn't conform to protocol");
    [self.observers addObject:observer];
}

- (void)removeObserver:(id)observer {
    [self.observers removeObject:observer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    if (sig) {
        return sig;
    }
    
    struct objc_method_description desc = protocol_getMethodDescription(self.protocol, aSelector, YES, YES);
    if (desc.name == NULL) {
        desc = protocol_getMethodDescription(self.protocol, aSelector, NO, YES);
    }
    
    if (desc.name == NULL) {
        [self doesNotRecognizeSelector:aSelector];
        return nil;
    }
    
    return [NSMethodSignature signatureWithObjCTypes:desc.types];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = [anInvocation selector];
    for (id observer in self.observers) {
        if ([observer respondsToSelector:selector]) {
            [anInvocation setTarget:observer];
            [anInvocation invoke];
        }
    }
}
@end

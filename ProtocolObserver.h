//
//  ProtocolObserver.h
//  ProtocolObserver
//
//  Created by Jet on 16/1/12.
//  Copyright © 2016年 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProtocolObserver : NSObject

- (instancetype)initWithProtocol:(Protocol *)protocol observers:(NSSet *)observers;
- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

@end

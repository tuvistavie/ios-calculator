//
//  AbstractSyntaxTree.m
//  Test
//
//  Created by Daniel Perez on 7/18/13.
//  Copyright (c) 2013 Daniel Perez. All rights reserved.
//

#import "AbstractSyntaxTree.h"

#import "Math.h"


@implementation IntValue

- (id)initWithValue:(long)v
{
    _value = v;
    return self;
}

- (ValueType) getType
{
    return INT_VALUE;
}

- (double) getDoubleValue
{
    return (double)[self value];
}

- (NSObject<Value>*) evaluate
{
    return self;
}

- (NSObject<Value>*) add:(NSObject<Value> *)other
{
    if([other getType] == INT_VALUE) {
        return [[IntValue alloc] initWithValue: [self value] + [(IntValue*)other value]];
    } else {
        return [[DoubleValue alloc] initWithValue:[self value] + [other getDoubleValue]];
    }
}

- (NSObject<Value>*) sub:(NSObject<Value> *)other
{
    if([other getType] == INT_VALUE) {
        return [[IntValue alloc] initWithValue: [self value] - [(IntValue*)other value]];
    } else {
        return [[DoubleValue alloc] initWithValue:[self value] - [other getDoubleValue]];
    }
}

- (NSObject<Value>*) mul:(NSObject<Value> *)other
{
    if([other getType] == INT_VALUE) {
        return [[IntValue alloc] initWithValue: [self value] * [(IntValue*)other value]];
    } else {
        return [[DoubleValue alloc] initWithValue:[self value] * [other getDoubleValue]];
    }
}

- (NSObject<Value>*) div:(NSObject<Value> *)other
{
    if([other getType] == INT_VALUE) {
        return [[IntValue alloc] initWithValue: [self value] / [(IntValue*)other value]];
    } else {
        return [[DoubleValue alloc] initWithValue:[self value] / [other getDoubleValue]];
    }
}

- (NSObject<Value>*) pow:(NSObject<Value> *)other
{
    if([other getType] == INT_VALUE) {
        long newValue = [Math intPow:[self value] :(int)[(IntValue*)other value]];
        return [[IntValue alloc] initWithValue: newValue];
    } else {
        long newValue = [Math pow:[self value] :[other getDoubleValue]];
        return [[IntValue alloc] initWithValue: newValue];
    }
}

@end

@implementation DoubleValue

- (id)initWithValue:(double)v
{
    _value = v;
    return self;
}

- (ValueType) getType
{
    return DOUBLE_VALUE;
}

- (double) getDoubleValue
{
    return [self value];
}

- (NSObject<Value>*) evaluate
{
    return self;
}

- (NSObject<Value>*) add:(NSObject<Value> *)other
{
    return [[DoubleValue alloc] initWithValue:[self getDoubleValue] + [other getDoubleValue]];
}

- (NSObject<Value>*) sub:(NSObject<Value> *)other
{
    return [[DoubleValue alloc] initWithValue:[self getDoubleValue] - [other getDoubleValue]];
}

- (NSObject<Value>*) mul:(NSObject<Value> *)other
{
    return [[DoubleValue alloc] initWithValue:[self getDoubleValue] * [other getDoubleValue]];
}

- (NSObject<Value>*) div:(NSObject<Value> *)other
{
    return [[DoubleValue alloc] initWithValue:[self getDoubleValue] / [other getDoubleValue]];
}

- (NSObject<Value>*) pow:(NSObject<Value> *)other
{
    double newValue;
    if([other getType] == INT_VALUE) {
        newValue = [Math doubleIntPow:[self value] :(int)[(IntValue*)other value]];
    } else {
        newValue = [Math pow:[self value] :[other getDoubleValue]];
    }
    return [[DoubleValue alloc] initWithValue:newValue];
}
        

@end

@implementation UnaryApp

- (id)initWithValues:(UnaryAppType)type :(NSObject<AbstractSyntaxTree>*)e
{
    elem = e;
    return self;
}

- (NSObject<Value>*)evaluate
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}
@end

@implementation BinaryApp

- (id)initWithValues:(BinaryAppType)t :(NSObject<AbstractSyntaxTree>*)l :(NSObject<AbstractSyntaxTree>*)r
{
    type = t;
    left = l;
    right = r;
    return self;
}

- (NSObject<Value>*)evaluate
{
    switch(type) {
        case ADD: return [[left evaluate] add: [right evaluate]];
        case SUB: return [[left evaluate] sub: [right evaluate]];
        case MUL: return [[left evaluate] mul: [right evaluate]];
        case DIV: return [[left evaluate] div: [right evaluate]];
        case POW: return [[left evaluate] pow: [right evaluate]];
    }
}

@end


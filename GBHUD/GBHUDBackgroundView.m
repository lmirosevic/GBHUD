//
//  GBHUDBackgroundView.m
//  GBHUD
//
//  Created by Luka Mirosevic on 21/11/2012.
//  Copyright (c) 2012 Goonbee. All rights reserved.
//

#import "GBHUDBackgroundView.h"

@implementation GBHUDBackgroundView {
    CGFloat _cornerRadius;
}

#pragma mark - acc

-(void)setColor:(UIColor *)color {
    _color = color;
    
    [self setNeedsDisplay];
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    
    [self setNeedsDisplay];
}

#pragma mark - mem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.cornerRadius = 0;
    }
    return self;
}

-(void)dealloc {
    self.color = nil;
}

#pragma mark - drawing

-(void)layoutSubviews {
    NSLog(@"layout subviews");
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"draw");
    
    [self.color setStroke];
    [self.color setFill];
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) cornerRadius:self.cornerRadius];
    [rectPath fill];
}

@end

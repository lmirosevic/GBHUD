//
//  GBHUDView.m
//  GBHUD
//
//  Created by Luka Mirosevic on 21/11/2012.
//  Copyright (c) 2012 Goonbee. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "GBHUDView.h"
#import "GBHUDBackgroundView.h"

#define kLabelSidePadding 6
#define kLabelHeight 20

@interface GBHUDView ()

@property (strong, nonatomic) GBHUDBackgroundView *backgroundView;
@property (strong, nonatomic) UILabel *label;

@end


@implementation GBHUDView

#pragma mark - acc

-(void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    
    self.backgroundView.cornerRadius = cornerRadius;
}

-(void)setSymbolSize:(CGSize)symbolSize {
    _symbolSize = symbolSize;
    
    [self _resizeSymbol];
}

-(void)setSymbolTopOffset:(CGFloat)symbolTopOffset {
    _symbolTopOffset = symbolTopOffset;
    
    [self _resizeSymbol];
}

-(void)setLabelBottomOffset:(CGFloat)labelBottomOffset {
    _labelBottomOffset = labelBottomOffset;
    
    [self _resizeLabel];
}

-(void)setSymbolView:(UIView *)symbolView {
    [_symbolView removeFromSuperview];
    
    _symbolView = symbolView;

    [self _addSymbol];
}

-(void)setText:(NSString *)text {
    _text = text;
    
    self.label.text = text;
}

-(void)setFont:(UIFont *)font {
    _font = font;
    
    self.label.font = font;
}

-(void)setBackdropColor:(UIColor *)backdropColor {
    _backdropColor = backdropColor;
    
    self.backgroundView.color = backdropColor;
}

-(void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    self.label.textColor = textColor;
}

#pragma mark - mem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //add and draw subviews
        [self _addBackground];
        [self _addSymbol];
        [self _addLabel];
    }
    return self;
}

-(void)dealloc {
    self.backgroundColor = nil;
    self.text = nil;
    self.font = nil;
    self.backdropColor = nil;
    self.textColor = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    [self.symbolView removeFromSuperview];
    self.symbolView = nil;
    [self.label removeFromSuperview];
    self.label = nil;
}

#pragma mark - private drawing

-(void)_addBackground {
    GBHUDBackgroundView *bgView = [[GBHUDBackgroundView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    bgView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    bgView.center = self.center;
    bgView.color = self.backdropColor;
    bgView.cornerRadius = self.cornerRadius;
    [self addSubview:bgView];
    self.backgroundView = bgView;
}

-(void)_resizeBackground {
    if (self.backgroundView) {
        self.backgroundView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.backgroundView.center = self.center;
    }
}

-(void)_addSymbol {
    if (self.symbolView) {
        //make sure its not a subview of anywhere else first
        [self.symbolView removeFromSuperview];
        
        //configure and add the view
        self.symbolView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
        self.symbolView.frame = CGRectMake((self.bounds.size.width - self.symbolSize.width)/2.0, self.symbolTopOffset, self.symbolSize.width, self.symbolSize.height);
        [self addSubview:self.symbolView];
    }
}

-(void)_resizeSymbol {
    if (self.symbolView) {
        self.symbolView.frame = CGRectMake((self.bounds.size.width - self.symbolSize.width)/2.0, self.symbolTopOffset, self.symbolSize.width, self.symbolSize.height);
    }
}

-(void)_addLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kLabelSidePadding, self.bounds.size.height - kLabelHeight - self.labelBottomOffset, self.bounds.size.width - 2*kLabelSidePadding, kLabelHeight)];
    label.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = self.textColor;
    label.textAlignment = UITextAlignmentCenter;
    label.minimumFontSize = 8;
    label.adjustsFontSizeToFitWidth = YES;
    label.font = self.font;
    label.text = self.text;
    [self addSubview:label];
    self.label = label;
}

-(void)_resizeLabel {
    self.label.frame = CGRectMake(kLabelSidePadding, self.bounds.size.height - kLabelHeight - self.labelBottomOffset, self.bounds.size.width - 2*kLabelSidePadding, kLabelHeight);
}

@end

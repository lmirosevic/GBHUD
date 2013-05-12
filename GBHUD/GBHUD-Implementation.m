//
//  GBHUD-Implementation.m
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

#define kAnimationDuration 0.2
#define kDefaultDisableUserInteraction YES
#define kDefaultCurtainOpacity 0.3
#define kDefaultShowCurtain YES
#define kDefaultSize (CGSize){110, 110}
#define kDefaultCornerRadius 8
#define kDefaultSymbolSize (CGSize){60, 60}
#define kDefaultSymbolTopOffset 16
#define kDefaultTextBottomOffset 8
#define kDefaultFont [UIFont fontWithName:@"Helvetica-Bold" size:12]
#define kDefaultBackdropColor [UIColor colorWithWhite:0 alpha:0.7]
#define kDefaultTextColor [UIColor whiteColor]
#define kDefaultForcedOrientation 0


#import "GBHUD.h"
#import "GBHUDView.h"


@interface GBHUD()

@property (assign, nonatomic, readwrite) BOOL isShowingHUD;
@property (strong, nonatomic) GBHUDView *hudView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *curtainView;

@end


@implementation GBHUD {
    CGSize _size;
    CGFloat _cornerRadius;
    CGSize _symbolSize;
    CGFloat _symbolTopOffset;
    CGFloat _textBottomOffset;
    
#if TARGET_OS_IPHONE
    UIFont *_font;
    UIColor *_backdropColor;
    UIColor *_textColor;
#else
#endif
}

#pragma mark - custom accessors: Common

-(CGFloat)cornerRadius {
    if (_cornerRadius == 0) {
        return kDefaultCornerRadius;
    }
    else {
        return _cornerRadius;
    }
}

-(CGSize)symbolSize {
    if (CGSizeEqualToSize(_symbolSize, CGSizeZero)) {
        return kDefaultSymbolSize;
    }
    else {
        return _symbolSize;
    }
}

-(CGFloat)symbolTopOffset {
    if (_symbolTopOffset == 0) {
        return kDefaultSymbolTopOffset;
    }
    else {
        return _symbolTopOffset;
    }
}

-(CGFloat)textBottomOffset {
    if (_textBottomOffset == 0) {
        return kDefaultTextBottomOffset;
    }
    else {
        return _textBottomOffset;
    }
}

-(CGSize)size {
    if (CGSizeEqualToSize(_size, CGSizeZero)) {
        return kDefaultSize;
    }
    else {
        return _size;
    }
}

-(void)setSize:(CGSize)size {
    _size = size;
    
    self.hudView.frame = CGRectMake((self.containerView.bounds.size.width - size.width)/2.0, (self.containerView.bounds.size.height - size.height)/2.0, size.width, size.height);
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    
    self.hudView.cornerRadius = cornerRadius;
}

-(void)setDisableUserInteraction:(BOOL)disableUserInteraction {
    _disableUserInteraction = disableUserInteraction;
    
    self.containerView.userInteractionEnabled = disableUserInteraction;
}

-(void)setSymbolSize:(CGSize)symbolSize {
    _symbolSize = symbolSize;
    
    self.hudView.symbolSize = symbolSize;
}

-(void)setSymbolTopOffset:(CGFloat)symbolTopOffset {
    _symbolTopOffset = symbolTopOffset;
    
    self.hudView.symbolTopOffset = symbolTopOffset;
}

-(void)setTextBottomOffset:(CGFloat)textBottomOffset {
    _textBottomOffset = textBottomOffset;
    
    self.hudView.labelBottomOffset = textBottomOffset;
}

-(void)setShowCurtain:(BOOL)showCurtain {
    _showCurtain = showCurtain;
    
    if (showCurtain) {
        self.curtainView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.curtainOpacity];
    }
    else {
        self.curtainView.backgroundColor = [UIColor clearColor];
    }
}

-(void)setCurtainOpacity:(CGFloat)curtainOpacity {
    _curtainOpacity = curtainOpacity;
    
    self.curtainView.backgroundColor = [UIColor colorWithWhite:0 alpha:curtainOpacity];
}

#pragma mark - custom accessors: iOS

#if TARGET_OS_IPHONE
-(UIFont *)font {
    if (!_font) {
        return kDefaultFont;
    }
    else {
        return _font;
    }
}

-(UIColor *)backdropColor {
    if (!_backdropColor) {
        return kDefaultBackdropColor;
    }
    else {
        return _backdropColor;
    }
}

-(UIColor *)textColor {
    if (!_textColor) {
        return kDefaultTextColor;
    }
    else {
        return _textColor;
    }
}

-(void)setFont:(UIFont *)font {
    _font = font;
    
    self.hudView.font = font;
}

-(void)setBackdropColor:(UIColor *)backdropColor {
    _backdropColor = backdropColor;
    
    self.hudView.backdropColor = backdropColor;
}

-(void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    self.hudView.textColor = textColor;
}

-(void)setForcedOrientation:(UIInterfaceOrientation)forcedOrientation {
    _forcedOrientation = forcedOrientation;
    
    [self _sortOutOrientation];
}
#endif

#pragma mark - custom accessors: OSX

#if !TARGET_OS_IPHONE
//foo put them here
#endif

#pragma mark - memory

+(GBHUD *)sharedHUD {
    static GBHUD* _sharedHUD;
    
    @synchronized(self)
    {
        if (!_sharedHUD)
            _sharedHUD = [[GBHUD alloc] init];
        
        return _sharedHUD;
    }
}

-(id)init {
    if (self = [super init]) {
        //init ivars
        self.size = CGSizeZero;
        self.symbolSize = CGSizeZero;
        self.symbolTopOffset = 0;
        self.textBottomOffset = 0;
        self.font = nil;
        self.backdropColor = nil;
        self.textColor = nil;
        self.forcedOrientation = kDefaultForcedOrientation;
        self.showCurtain = kDefaultShowCurtain;
        self.curtainOpacity = kDefaultCurtainOpacity;
        self.disableUserInteraction = kDefaultDisableUserInteraction;
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_sortOutOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    return self;
}

-(void)dealloc {
    [self dismissHUDAnimated:NO];
    
    self.hudView = nil;
    self.containerView = nil;
    self.curtainView = nil;
    self.font = nil;
    self.backdropColor = nil;
    self.textColor = nil;
}

#pragma mark - public API

-(void)showHUDWithType:(GBHUDType)type text:(NSString *)text animated:(BOOL)animated {
    __block UIView *symbolView;
   
    void(^prepareView)(NSString *name) = ^(NSString *name) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"GBHUDResources.bundle" stringByAppendingPathComponent:name]]];
        imageView.contentMode = UIViewContentModeCenter;
        symbolView = imageView;
    };
    
    switch (type) {
        case GBHUDTypeLoading: {
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [spinner startAnimating];
            symbolView = spinner;
        } break;
            
        case GBHUDTypeError: {
            prepareView(@"GBHUDSymbolError");
        } break;
            
        case GBHUDTypeSuccess: {
            prepareView(@"GBHUDSymbolSuccess");
        } break;
            
        case GBHUDTypeExplosion: {
            prepareView(@"GBHUDSymbolExplosion");
        } break;
            
        case GBHUDTypeInfo: {
            prepareView(@"GBHUDSymbolInfo");
        } break;
            
        case GBHUDTypeSleep: {
            prepareView(@"GBHUDSymbolSleep");
        } break;
            
        default:
            break;
    }
    
    if (symbolView) {
        [self showHUDWithView:symbolView text:text animated:animated];
    }
}

-(void)showHUDWithImage:(UIImage *)image text:(NSString *)text animated:(BOOL)animated {
    UIImageView *symbolImageView = [[UIImageView alloc] initWithImage:image];
    [self showHUDWithView:symbolImageView text:text animated:animated];
}

-(void)showHUDWithView:(UIView *)symbolView text:(NSString *)text animated:(BOOL)animated {
    if (!self.isShowingHUD) {
        //fetch the target view which the entire hud view will be added to
        UIView *targetView = [[UIApplication sharedApplication] keyWindow];
        
        //create the hud view
        GBHUDView *newHUD = [[GBHUDView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
        newHUD.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        newHUD.symbolView = symbolView;
        newHUD.text = text;
        newHUD.textColor = self.textColor;
        newHUD.backdropColor = self.backdropColor;
        newHUD.font = self.font;
        newHUD.symbolSize = self.symbolSize;
        newHUD.symbolTopOffset = self.symbolTopOffset;
        newHUD.labelBottomOffset = self.textBottomOffset;
        newHUD.cornerRadius = self.cornerRadius;
        
        //create the container and add the hud to it
        UIView *containerView = [[UIView alloc] initWithFrame:targetView.bounds];//this keeps the size of the current orientation throughout but it doesnt matter cuz it doesnt clip bounds
        containerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [containerView addSubview:newHUD];
        
        //center the hud in the container
        newHUD.center = containerView.center;
        
        //create the curtain view and add the container to it
        UIView *curtainView = [[UIView alloc] initWithFrame:targetView.bounds];
        if (self.showCurtain) {
            curtainView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.curtainOpacity];
        }
        else {
            curtainView.backgroundColor = [UIColor clearColor];
        }
        curtainView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        curtainView.userInteractionEnabled = self.disableUserInteraction;
        [curtainView addSubview:containerView];
        
        //draw the view
        [targetView addSubview:curtainView];
        
        //store in properties
        self.hudView = newHUD;
        self.containerView = containerView;
        self.curtainView = curtainView;
        
        //sort out orientation
        [self _sortOutOrientation];
        
        //set flag
        self.isShowingHUD = YES;
        
        //animations
        if (animated) {
            //first shrink to 0
            newHUD.transform = CGAffineTransformMakeScale(0.1, 0.1);
            curtainView.alpha = 0;
            
            //then scale up a bit too much
            [UIView animateWithDuration:kAnimationDuration*0.5 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
                newHUD.transform = CGAffineTransformMakeScale(1.15, 1.15);
                curtainView.alpha = 1;
                
            } completion:^(BOOL finished) {
                
                //bounce back
                [UIView animateWithDuration:kAnimationDuration*0.2 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                    newHUD.transform = CGAffineTransformMakeScale(0.95, 0.95);
                } completion:^(BOOL finished) {
                    
                    //settle
                    [UIView animateWithDuration:kAnimationDuration*0.25 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                        newHUD.transform = CGAffineTransformMakeScale(1, 1);
                    } completion:^(BOOL finished) {
                        //noop
                    }];
                }];
                
            }];
        }
    }
    else {
        NSLog(@"GBHUD: can't show new HUD, already showing one.");
    }
}

-(void)dismissHUDAnimated:(BOOL)animated {
    if (self.isShowingHUD) {
        void(^completedBlock)(void) = ^{
            [self.curtainView removeFromSuperview];
            self.containerView = nil;
            self.hudView = nil;
            self.curtainView = nil;
            self.isShowingHUD = NO;
        };
        
        if (animated) {
            [UIView animateWithDuration:kAnimationDuration*0.6 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
                self.hudView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                self.curtainView.alpha = 0;
                
            } completion:^(BOOL finished) {
                completedBlock();
            }];
        }
        else {
            completedBlock();
        }
    }
    else {
        NSLog(@"GBHUD: can't dismiss HUD, not showing one.");
    }
}

-(void)autoDismissAfterDelay:(NSTimeInterval)delay animated:(BOOL)animated {
    //to make sure we only close the HUD which is currently shown, not any potential future ones
    GBHUDView *hudView = self.hudView;
    
    int64_t delayInSeconds = delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (self.isShowingHUD && (hudView == self.hudView)) {
            [self dismissHUDAnimated:animated];
        }
    });
}

#pragma mark - private util

-(void)_sortOutOrientation {
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
    
    //if its forced override the orientation
    if (self.forcedOrientation) {
        currentOrientation = self.forcedOrientation;
    }
    
    //rotate it
    switch (currentOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            self.containerView.transform = CGAffineTransformMakeRotation(0.5*M_PI);
            break;
            
        case UIDeviceOrientationLandscapeRight:
            self.containerView.transform = CGAffineTransformMakeRotation(1.5*M_PI);
            break;
            
        case UIDeviceOrientationPortrait:
            self.containerView.transform = CGAffineTransformMakeRotation(0*M_PI);
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            self.containerView.transform = CGAffineTransformMakeRotation(1*M_PI);
            break;
            
        default:
            break;
    }
}

@end


//add an enum for no icon, and if thats the case, then make it a small HUD with text only, like the on e in the skala preview app
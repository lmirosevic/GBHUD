//
//  GBHUD.m
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

#import "GBHUD.h"
#import "GBHUDView.h"

#import "GBHUDShims.h"

#import <QuartzCore/QuartzCore.h>

#define kAnimationDuration 0.2
#define kDefaultDisableUserInteraction YES
#define kDefaultCurtainOpacity 0.3
#define kDefaultShowCurtain YES
#define kDefaultSize (CGSize){110, 110}
#define kDefaultCornerRadius 8
#define kDefaultSymbolSize (CGSize){60, 60}
#define kDefaultSymbolTopOffset 16
#define kDefaultTextBottomOffset 8

#if TARGET_OS_IPHONE
    #define kDefaultFont [UIFont fontWithName:@"HelveticaNeue-Bold" size:12]
    #define kDefaultBackdropColor [[UIColor blackColor] colorWithAlphaComponent:0.7]
    #define kDefaultTextColor [UIColor whiteColor]
    #define kDefaultForcedOrientation 0
#else
    #define kDefaultPositioning GBHUDPositioningCenterInMainWindow
    #define kDefaultFont [NSFont fontWithName:@"HelveticaNeue-Bold" size:12]
    #define kDefaultBackdropColor [[NSColor blackColor] colorWithAlphaComponent:0.7]
    #define kDefaultTextColor [NSColor whiteColor]
#endif

@interface GBHUD()

@property (assign, nonatomic, readwrite) BOOL                   isShowingHUD;
@property (strong, nonatomic) GBHUDView                         *hudView;
@property (strong, nonatomic) GBView                            *containerView;
@property (strong, nonatomic) GBView                            *curtainView;

#if !TARGET_OS_IPHONE
@property (strong, nonatomic, readonly) NSBundle                *resourcesBundle;
@property (strong, nonatomic) NSProgressIndicator               *spinner;
@property (strong, nonatomic,readonly) NSWindow                 *popupWindow;
#endif

@end


@implementation GBHUD {
    CGSize                  _size;
    CGFloat                 _cornerRadius;
    CGSize                  _symbolSize;
    CGFloat                 _symbolTopOffset;
    CGFloat                 _textBottomOffset;
    
    GBFont                  *_font;
    GBColor                 *_backdropColor;
    GBColor                 *_textColor;
    
#if !TARGET_OS_IPHONE
    NSBundle                *_resourcesBundle;
    NSWindow                *_popupWindow;
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
#if TARGET_OS_IPHONE
-(void)setDisableUserInteraction:(BOOL)disableUserInteraction {
    _disableUserInteraction = disableUserInteraction;
    
    self.containerView.userInteractionEnabled = disableUserInteraction;
}
#endif

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
#if TARGET_OS_IPHONE
    _showCurtain = showCurtain;
    
    if (showCurtain) {
        self.curtainView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.curtainOpacity];
    }
    else {
        self.curtainView.backgroundColor = [UIColor clearColor];
    }
#else
//  currently does nothing on iOS
#endif
}

-(void)setCurtainOpacity:(CGFloat)curtainOpacity {
#if TARGET_OS_IPHONE
    _curtainOpacity = curtainOpacity;
    
    self.curtainView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.curtainOpacity];
#else
//  currently do nothing on OSX
#endif
}

-(GBFont *)font {
    if (!_font) {
        return kDefaultFont;
    }
    else {
        return _font;
    }
}

-(GBColor *)backdropColor {
    if (!_backdropColor) {
        return kDefaultBackdropColor;
    }
    else {
        return _backdropColor;
    }
}

-(GBColor *)textColor {
    if (!_textColor) {
        return kDefaultTextColor;
    }
    else {
        return _textColor;
    }
}

-(void)setFont:(GBFont *)font {
    _font = font;
    
    self.hudView.font = font;
}

-(void)setBackdropColor:(GBColor *)backdropColor {
    _backdropColor = backdropColor;
    
    self.hudView.backdropColor = backdropColor;
}

-(void)setTextColor:(GBColor *)textColor {
    _textColor = textColor;
    
    self.hudView.textColor = textColor;
}

#if TARGET_OS_IPHONE
-(void)setForcedOrientation:(UIInterfaceOrientation)forcedOrientation {
    _forcedOrientation = forcedOrientation;
    
    [self _sortOutOrientation];
}
#endif

#pragma mark - lazy
    
#if !TARGET_OS_IPHONE
-(NSBundle *)resourcesBundle {
    if (!_resourcesBundle) {
        _resourcesBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:kGBHUDResourcesBundleName ofType:@""]];
    }
    
    return _resourcesBundle;
}
    
-(NSProgressIndicator *)spinner {
    if (!_spinner) {
        _spinner = [[NSProgressIndicator alloc] init];
        _spinner.style = NSProgressIndicatorSpinningStyle;
        _spinner.wantsLayer = YES;
        _spinner.layer.zPosition = 10;
        _spinner.contentFilters = @[[CIFilter filterWithName:@"CIColorInvert"]];
        _spinner.frame = NSMakeRect(0, 0, 32, 32);
    }
    
    [_spinner startAnimation:self];
    
    return _spinner;
}
    
-(NSWindow *)popupWindow {
    if (!_popupWindow) {
        _popupWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(0,0,0,0) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
        [_popupWindow setOpaque:NO];
        _popupWindow.backgroundColor = [NSColor clearColor];
        ((NSView *)_popupWindow.contentView).wantsLayer = YES;
    }
    
    return _popupWindow;
}
#endif
    
#pragma mark - memory

+(GBHUD *)sharedHUD {
    static GBHUD* _sharedHUD;
    
    @synchronized(self) {
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
        self.showCurtain = kDefaultShowCurtain;
        self.curtainOpacity = kDefaultCurtainOpacity;
#if TARGET_OS_IPHONE
        self.disableUserInteraction = kDefaultDisableUserInteraction;
        self.forcedOrientation = kDefaultForcedOrientation;
#else
        self.positioning = kDefaultPositioning;
#endif

        //set up listening to orientation changes
#if TARGET_OS_IPHONE
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_sortOutOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
#endif
    }
    
    return self;
}

-(void)dealloc {
    [self dismissHUDAnimated:NO];
    
#if !TARGET_OS_IPHONE
    _popupWindow = nil;
    [self.spinner stopAnimation:self];
    self.spinner = nil;
#endif
    self.hudView = nil;
    self.containerView = nil;
    self.curtainView = nil;
    self.font = nil;
    self.backdropColor = nil;
    self.textColor = nil;
}

#pragma mark - public API

-(void)showHUDWithType:(GBHUDType)type text:(NSString *)text {
    [self showHUDWithType:type text:text animated:NO];
}

-(void)showHUDWithType:(GBHUDType)type text:(NSString *)text animated:(BOOL)animated {
    __block GBView *symbolView;
   
    void(^prepareView)(NSString *name) = ^(NSString *name) {
#if TARGET_OS_IPHONE
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[kGBHUDResourcesBundleName stringByAppendingPathComponent:name]]];
        imageView.contentMode = UIViewContentModeCenter;
#else
        NSString *imagePath = [self.resourcesBundle pathForImageResource:name];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
        
        NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, image.size.width, image.size.height)];
        imageView.image = image;
        imageView.imageAlignment = NSImageAlignCenter;
#endif
        
        symbolView = imageView;
    };
    
    switch (type) {
        case GBHUDTypeLoading: {
#if TARGET_OS_IPHONE
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [spinner startAnimating];
#else
            NSProgressIndicator *spinner = [[NSProgressIndicator alloc] init];
            spinner.style = NSProgressIndicatorSpinningStyle;
            spinner.wantsLayer = YES;
            spinner.layer.zPosition = 10;
            spinner.contentFilters = @[[CIFilter filterWithName:@"CIColorInvert"]];
            spinner.frame = NSMakeRect(0, 0, 32, 32);
            
            [spinner startAnimation:self];
            
            self.spinner = spinner;
#endif
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

-(void)showHUDWithImage:(GBImage *)image text:(NSString *)text {
    [self showHUDWithImage:image text:text animated:NO];
}

-(void)showHUDWithImage:(GBImage *)image text:(NSString *)text animated:(BOOL)animated {
#if TARGET_OS_IPHONE
    UIImageView *symbolImageView = [[UIImageView alloc] initWithImage:image];
#else
    NSImageView *symbolImageView = [[NSImageView alloc] init];
    [symbolImageView setImage:image];
#endif
    
    [self showHUDWithView:symbolImageView text:text animated:animated];
}

-(void)showHUDWithView:(GBView *)symbolView text:(NSString *)text {
    [self showHUDWithView:symbolView text:text animated:NO];
}

-(void)showHUDWithView:(GBView *)symbolView text:(NSString *)text animated:(BOOL)animated {
    if (!self.isShowingHUD) {
        //fetch the target view which the entire hud view will be added to
#if TARGET_OS_IPHONE
        UIView *targetView = [[UIApplication sharedApplication] keyWindow];
#else
        NSView *targetView = [[NSApplication sharedApplication] keyWindow].contentView;
#endif
        
        
#if !TARGET_OS_IPHONE
        //make sure the symbolview has the right zOrder
        symbolView.wantsLayer = YES;
        symbolView.layer.zPosition = 10;
#endif
        
        //create the hud view
        GBHUDView *newHUD = [[GBHUDView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
#if TARGET_OS_IPHONE
        newHUD.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
#else
        newHUD.autoresizingMask = (NSViewMinXMargin | NSViewMaxXMargin | NSViewMaxYMargin | NSViewMinYMargin);
#endif
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
        GBView *containerView = [[GBView alloc] initWithFrame:targetView.bounds];//this keeps the size of the current orientation throughout but it doesnt matter cuz it doesnt clip bounds
#if TARGET_OS_IPHONE
        containerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
#else
        containerView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
#endif
        [containerView addSubview:newHUD];
        
#if TARGET_OS_IPHONE
        //center the hud in the container
        newHUD.frame = CGRectMake((containerView.frame.size.width-newHUD.frame.size.width)*0.5, (containerView.frame.size.height-newHUD.frame.size.height)*0.5, newHUD.frame.size.width, newHUD.frame.size.height);
#else
        if (self.positioning == GBHUDPositioningCenterInMainWindow) {
            //center the hud in the container
            newHUD.frame = CGRectMake((containerView.frame.size.width-newHUD.frame.size.width)*0.5, (containerView.frame.size.height-newHUD.frame.size.height)*0.5, newHUD.frame.size.width, newHUD.frame.size.height);
        }
        else if (self.positioning == GBHUDPositioningCenterOnMainScreen) {
            newHUD.frame = CGRectMake(0, 0, newHUD.frame.size.width, newHUD.frame.size.height);
            
            NSRect screenRect = [NSScreen mainScreen].visibleFrame;
            NSRect contentRect = CGRectMake((screenRect.size.width-newHUD.frame.size.width)*0.5, (screenRect.size.height-newHUD.frame.size.height)*0.5, newHUD.frame.size.width, newHUD.frame.size.height);
            
            [self.popupWindow.contentView setSubviews:@[]];
            [self.popupWindow.contentView addSubview:newHUD];
            
            [self.popupWindow setFrame:contentRect display:YES];
            [self.popupWindow makeKeyAndOrderFront:self];
        }
#endif
        
        //create the curtain view and add the container to it
        GBView *curtainView = [[GBView alloc] initWithFrame:targetView.bounds];
#if TARGET_OS_IPHONE
        if (self.showCurtain) {
            curtainView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.curtainOpacity];
        }
        else {
            curtainView.backgroundColor = [UIColor clearColor];
        }
        
        curtainView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        curtainView.userInteractionEnabled = self.disableUserInteraction;
#else
//        [targetView setContentFilters:@[[CIFilter filterWithName:@""]]];
        //foo todo, set the color of the curtain view, like above
        curtainView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
        //foo todo add the user interaction stuff to the mac version, like above
#endif
        [curtainView addSubview:containerView];
        
        //draw the view
        [targetView addSubview:curtainView];
        
        //store in properties
        self.hudView = newHUD;
        self.containerView = containerView;
        self.curtainView = curtainView;
        
#if TARGET_OS_IPHONE
        //sort out orientation
        [self _sortOutOrientation];
#endif
        
        //set flag
        self.isShowingHUD = YES;

//animations currently only supported on iOS
#if TARGET_OS_IPHONE
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
#endif
    }
    else {
        NSLog(@"GBHUD: can't show new HUD, already showing one.");
    }
}

-(void)dismissHUD {
    [self dismissHUDAnimated:NO];
}

-(void)dismissHUDAnimated:(BOOL)animated {
    if (self.isShowingHUD) {
        void(^completedBlock)(void) = ^{
            //if we had a spinner, kill it because it gets fucked up when placed in a window that goes in and out of focus
#if !TARGET_OS_IPHONE
            [self.spinner stopAnimation:self];
            [self.spinner removeFromSuperview];
            [self.popupWindow orderOut:self];
#endif
            [self.curtainView removeFromSuperview];
            self.containerView = nil;
            self.hudView = nil;
            self.curtainView = nil;
            self.isShowingHUD = NO;
        };

//animations currently only supported on iOS
#if TARGET_OS_IPHONE
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
#else
        completedBlock();
#endif
    }
    else {
        NSLog(@"GBHUD: can't dismiss HUD, not showing one.");
    }
}

-(void)autoDismissAfterDelay:(NSTimeInterval)delay {
    [self autoDismissAfterDelay:delay animated:NO];
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

#if TARGET_OS_IPHONE
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
#endif

@end


//add an enum for no icon, and if thats the case, then make it a small HUD with text only, like the on e in the skala preview app
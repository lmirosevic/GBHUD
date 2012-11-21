//
//  GBHUD.h
//  GBHUD
//
//  Created by Luka Mirosevic on 21/11/2012.
//  Copyright (c) 2012 Goonbee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    GBHUDTypeLoading,
    GBHUDTypeSuccess,
    GBHUDTypeError,
} GBHUDType;

@interface GBHUD : NSObject

@property (assign, nonatomic, readonly) BOOL isShowingHUD;
@property (assign, nonatomic) BOOL disableUserInteraction;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) CGSize symbolSize;
@property (assign, nonatomic) CGFloat symbolTopOffset;
@property (assign, nonatomic) CGFloat textBottomOffset;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *backdropColor;
@property (strong, nonatomic) UIColor *textColor;

//maybe show a little shadow too

+(GBHUD *)sharedHUD;

-(void)showHUDWithType:(GBHUDType)type text:(NSString *)text animated:(BOOL)animated;
-(void)showHUDWithImage:(UIImage *)image text:(NSString *)text animated:(BOOL)animated;//should also work in landscape
-(void)showHUDWithView:(UIView *)symbolView text:(NSString *)text animated:(BOOL)animated;
-(void)dismissHUDAnimated:(BOOL)animated;

@end

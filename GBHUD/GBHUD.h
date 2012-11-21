//
//  GBHUD.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    GBHUDTypeLoading,
    GBHUDTypeSuccess,
    GBHUDTypeError,
    GBHUDTypeSleep,
    GBHUDTypeExplosion,
    GBHUDTypeInfo,
} GBHUDType;

@interface GBHUD : NSObject

@property (assign, nonatomic, readonly) BOOL            isShowingHUD;
@property (assign, nonatomic) BOOL                      disableUserInteraction;
@property (assign, nonatomic) CGSize                    size;
@property (assign, nonatomic) CGFloat                   cornerRadius;
@property (assign, nonatomic) CGSize                    symbolSize;
@property (assign, nonatomic) CGFloat                   symbolTopOffset;
@property (assign, nonatomic) CGFloat                   textBottomOffset;
@property (strong, nonatomic) UIFont                    *font;
@property (strong, nonatomic) UIColor                   *backdropColor;
@property (strong, nonatomic) UIColor                   *textColor;
@property (assign, nonatomic) UIInterfaceOrientation    forcedOrientation;

+(GBHUD *)sharedHUD;

//add queieing up of HUD's
//add bg view dimming

-(void)showHUDWithType:(GBHUDType)type text:(NSString *)text animated:(BOOL)animated;
-(void)showHUDWithImage:(UIImage *)image text:(NSString *)text animated:(BOOL)animated;
-(void)showHUDWithView:(UIView *)symbolView text:(NSString *)text animated:(BOOL)animated;
-(void)dismissHUDAnimated:(BOOL)animated;
-(void)autoDismissAfterDelay:(NSTimeInterval)delay animated:(BOOL)animated;

@end

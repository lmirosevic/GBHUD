//
//  GBHUD-Interface-iOS.h
//  GBHUD
//
//  Created by Luka Mirosevic on 12/05/2013.
//  Copyright (c) 2013 Goonbee. All rights reserved.
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

#import "GBHUDTypes.h"

@interface GBHUD : NSObject

@property (assign, nonatomic, readonly) BOOL            isShowingHUD;
@property (assign, nonatomic) BOOL                      disableUserInteraction;
@property (assign, nonatomic) BOOL                      showCurtain;
@property (assign, nonatomic) CGFloat                   curtainOpacity;
@property (strong, nonatomic) UIColor                   *curtainColor;
@property (assign, nonatomic) CGSize                    size;
@property (assign, nonatomic) CGFloat                   cornerRadius;
@property (assign, nonatomic) CGSize                    symbolSize;
@property (assign, nonatomic) CGFloat                   symbolTopOffset;
@property (assign, nonatomic) CGFloat                   textBottomOffset;
@property (assign, nonatomic) CGPoint                   offset;
@property (strong, nonatomic) UIFont                    *font;
@property (strong, nonatomic) UIColor                   *backdropColor;
@property (strong, nonatomic) UIColor                   *textColor;

+(GBHUD *)sharedHUD;


-(void)autoDismissAfterDelay:(NSTimeInterval)delay;
-(void)showHUDWithType:(GBHUDType)type text:(NSString *)text animated:(BOOL)animated;

-(void)showHUDWithImage:(UIImage *)image text:(NSString *)text;
-(void)showHUDWithImage:(UIImage *)image text:(NSString *)text animated:(BOOL)animated;

-(void)showHUDWithView:(UIView *)symbolView text:(NSString *)text;
-(void)showHUDWithView:(UIView *)symbolView text:(NSString *)text animated:(BOOL)animated;

-(void)dismissHUD;
-(void)dismissHUDAnimated:(BOOL)animated;

-(void)showHUDWithType:(GBHUDType)type text:(NSString *)text;
-(void)autoDismissAfterDelay:(NSTimeInterval)delay animated:(BOOL)animated;

-(void)enableForcedOrientation:(UIDeviceOrientation)forcedOrientation;
-(void)disableForcedOrientation;

@end

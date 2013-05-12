//
//  GBHUDView.h
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

#import "GBHUDShims.h"

@interface GBHUDView : GBView

@property (strong, nonatomic) GBView        *symbolView;
@property (assign, nonatomic) CGFloat       cornerRadius;
@property (strong, nonatomic) NSString      *text;
@property (assign, nonatomic) CGSize        symbolSize;
@property (assign, nonatomic) CGFloat       symbolTopOffset;
@property (assign, nonatomic) CGFloat       labelBottomOffset;
@property (strong, nonatomic) GBFont        *font;
@property (strong, nonatomic) GBColor       *backdropColor;
@property (strong, nonatomic) GBColor       *textColor;

@end

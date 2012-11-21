//
//  GBHUDView.h
//  GBHUD
//
//  Created by Luka Mirosevic on 21/11/2012.
//  Copyright (c) 2012 Goonbee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBHUDView : UIView

@property (strong, nonatomic) UIView *symbolView;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) CGSize symbolSize;
@property (assign, nonatomic) CGFloat symbolTopOffset;
@property (assign, nonatomic) CGFloat labelBottomOffset;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *backdropColor;
@property (strong, nonatomic) UIColor *textColor;

@end

//
//  CircleProgressView.h
//  CircleProgressView
//
//  Created by George Danikas on 9/21/15.
//  Copyright (c) 2015 Intelen Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleProgressViewDelegate;

@interface CircleProgressView : UIView

@property (weak, nonatomic) id <CircleProgressViewDelegate> delegate;

@property (strong, nonatomic) UIColor *primaryColor;
@property (strong, nonatomic) UIColor *secondaryColor;
@property (strong, nonatomic) NSNumber *percentValue;
@property (assign, nonatomic) BOOL animated;

- (void)setPercentValue:(NSNumber *)percentValue withColor:(UIColor*) color;

@end


@protocol CircleProgressViewDelegate <NSObject>
@optional
- (void)circleProgressView:(CircleProgressView *)view setPercentCompletedWithValue:(NSNumber *)value;
@end

//
//  CircleProgressView.m
//  CircleProgressView
//
//  Created by George Danikas on 9/21/15.
//  Copyright (c) 2015 Intelen Ltd. All rights reserved.
//

#import "CircleProgressView.h"

#define pi   3.14159265359
#define DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@interface CircleProgressView()

@property (nonatomic) CALayer *circularMask;
@property (nonatomic) CAShapeLayer *circle;
@property (nonatomic) CAShapeLayer *circleBackg;
@property (nonatomic) UILabel *percentLbl;

@end

@implementation CircleProgressView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initView];
  }
    
  return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
  self = [super initWithCoder:decoder];
  if (self) {
    [self initView];
  }
  
  return self;
}

- (void)initView {
    self.animated = NO;
    self.primaryColor = [UIColor colorWithRed:229.0/255.0 green: 228.0/255.0 blue: 229.0/255.0 alpha: 1.0];
    self.secondaryColor = [UIColor colorWithRed:27.0/255.0 green: 122.0/255.0 blue: 194.0/255.0 alpha: 1.0];
}

- (void)setPrimaryColor:(UIColor *)color {
    _primaryColor = color;
    
    // setNeedsDisplay needs to be in the main queue to update the drawRect in case the caller of this method is in a different queue
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setNeedsDisplay];
    }];
}

- (void)setSecondaryColor:(UIColor *)color {
    _secondaryColor = color;
    
    // setNeedsDisplay needs to be in the main queue to update the drawRect in case the caller of this method is in a different queue
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setNeedsDisplay];
    }];
}

- (void)setPercentValue:(NSNumber *)percentValue withColor:(UIColor *) color {
    _percentValue = percentValue;
    _secondaryColor = color;
    
    // setNeedsDisplay needs to be in the main queue to update the drawRect in case the caller of this method is in a different queue
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setNeedsDisplay];
    }];
}

- (void)setPercentValue:(NSNumber *)percentValue {
    [self setPercentValue:percentValue withColor:_secondaryColor];
}

- (void)drawRect:(CGRect)rect {
  CGFloat radius = self.bounds.size.width / 2;
  
  // Draw background circle
  _circleBackg = [CAShapeLayer layer];
  _circleBackg.path = [self generateCirclePathWithRadius:radius];
  _circleBackg.position = CGPointMake(CGRectGetMidX(self.bounds) - radius, CGRectGetMidY(self.bounds) - radius);
  _circleBackg.fillColor = _primaryColor.CGColor;
  [self.layer addSublayer:_circleBackg];
  
  // Create & Apply mask
  if (!self.circularMask) {
    self.circularMask = [CALayer layer];
    self.circularMask.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.circularMask.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.circularMask.contents = (id)[UIImage imageNamed:@"circular mask"].CGImage;
  }
    
  self.layer.mask = self.circularMask;
  self.layer.masksToBounds = YES;
  
  if (_circle) {
    [_circle removeFromSuperlayer];
    [self.layer layoutIfNeeded];
  }
  
  if (self.percentValue) {
    _circle = [CAShapeLayer layer];
    _circle.path = [self createArcPathWithRadius:radius forPercent:self.percentValue];
    _circle.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _circle.fillColor = [UIColor clearColor].CGColor;
    _circle.strokeColor = _secondaryColor.CGColor;
    _circle.lineWidth = self.frame.size.width * 0.40;
    
    // Configure animation
    if (self.animated) {
      CABasicAnimation *drawAnimation     = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
      drawAnimation.duration              = 5.0f; // "animate over 10 seconds or so.."
      drawAnimation.repeatCount           = 1.0;  // Animate only once..
      drawAnimation.removedOnCompletion   = NO;   // Remain stroked after the animation..
      drawAnimation.fillMode              = kCAFillModeForwards;
      
      drawAnimation.fromValue             = [NSNumber numberWithFloat:0.0f];
      drawAnimation.toValue               = [NSNumber numberWithFloat:100.0f];
      
      // Experiment with timing to get the appearence to look the way you want
      drawAnimation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
      
      // Add the animation to the circle
      [_circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    }
    
    [self.layer addSublayer:_circle];
    [self.layer layoutIfNeeded];
    
    // Notify Delegate that value has been set
    if ([self.delegate respondsToSelector:@selector(circleProgressView:setPercentCompletedWithValue:)])
      [self.delegate circleProgressView:self setPercentCompletedWithValue:self.percentValue];
  }
}

- (CGPathRef)generateCirclePathWithRadius:(CGFloat)radius {
  return [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0 * radius, 2.0 * radius) cornerRadius:radius].CGPath;
}

- (CGPathRef)createArcPathWithRadius:(CGFloat)radius forPercent:(NSNumber *)value {
  CGFloat startAngle = -pi/2;
  CGFloat endAngle = (value.doubleValue*2*pi)+startAngle;
  CGPathRef aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0)
                                                   radius:radius
                                               startAngle:startAngle
                                                 endAngle:endAngle
                                                clockwise:YES].CGPath;
  return aPath;
}

@end

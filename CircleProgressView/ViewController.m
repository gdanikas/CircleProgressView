//
//  ViewController.m
//  CircleProgressView
//
//  Created by George Danikas on 9/21/15.
//  Copyright © 2015 Intelen Inc. All rights reserved.
//

#import "ViewController.h"
#import "CircleProgressView.h"

static NSNumberFormatter *percentFormatter = nil;

@interface ViewController () <CircleProgressViewDelegate>

@property (weak, nonatomic) IBOutlet CircleProgressView *circleProgressView;
@property (weak, nonatomic) IBOutlet UILabel *percentLbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.percentLbl.alpha = 0.0;
    
    // Set delegate
    self.circleProgressView.delegate = self;
    
    // Set formatter
    if (percentFormatter == nil) {
        percentFormatter = [[NSNumberFormatter alloc] init];
        [percentFormatter setNumberStyle:NSNumberFormatterPercentStyle];
        percentFormatter.maximumFractionDigits = 0;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Call showPercentage method with delay
    [self performSelector:@selector(showPercentage) withObject:nil afterDelay:0.2f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPercentage {
    self.circleProgressView.percentValue = @0.6f;
    self.circleProgressView.animated = YES;
}

#pragma mark - Circular Progress View Delagate methods
- (void)circleProgressView:(CircleProgressView *)view setPercentCompletedWithValue:(NSNumber *)value {
    // Hide it to show with fade in animation
    self.percentLbl.alpha = 0.0;
    self.percentLbl.text = [percentFormatter stringFromNumber:value];
    
    // Animate Fade in
    [UIView animateWithDuration:2.0 animations:^{
        self.percentLbl.alpha = 1.0;
    }];
}

@end

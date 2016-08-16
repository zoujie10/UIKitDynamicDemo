//  Copyright (c) 2013 Rob Napier
//
//  This code is licensed under the MIT License:
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//
#import "DraggableView.h"

@interface DraggableView ()
@property (nonatomic) UISnapBehavior *snapBehavior;
@property (nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic) UIGestureRecognizer *gestureRecognizer;
@end

@implementation DraggableView

- (instancetype)initWithFrame:(CGRect)frame
                     animator:(UIDynamicAnimator *)animator {
  self = [super initWithFrame:frame];
  if (self) {
    _dynamicAnimator = animator;
    self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];//随机背景色

    self.layer.borderWidth = 5;
    self.layer.cornerRadius = 10;
    self.layer.borderColor =[[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]CGColor];
    self.gestureRecognizer = [[UIPanGestureRecognizer alloc]
                              initWithTarget:self
                              action:@selector(handlePan:)];
    [self addGestureRecognizer:self.gestureRecognizer];
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  DraggableView *newView = [[[self class] alloc]
                            initWithFrame:CGRectZero
                            animator:self.dynamicAnimator];
  newView.bounds = self.bounds;
  newView.center = self.center;
  newView.transform = self.transform;
  newView.alpha = self.alpha;
  return newView;
}

- (void)handlePan:(UIPanGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded ||
        g.state == UIGestureRecognizerStateCancelled) {
        [self stopDragging];//手势结束时
    }
    else {
        [self dragToPoint:[g locationInView:self.superview]];//拖曳视图
    }
}

- (void)dragToPoint:(CGPoint)point {//给手势添加snap动力学效果
    [self.dynamicAnimator removeBehavior:self.snapBehavior];
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self
                                                 snapToPoint:point];
    self.snapBehavior.damping = .25;
    [self.dynamicAnimator addBehavior:self.snapBehavior];
}

- (void)stopDragging {
    [self.dynamicAnimator removeBehavior:self.snapBehavior];
    self.snapBehavior = nil;
}

@end

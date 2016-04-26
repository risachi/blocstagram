//
//  CircleSpinnerView.m
//  blocstagram
//
//  Created by Lisa on 4/23/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import "CircleSpinnerView.h"

@interface CircleSpinnerView ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation CircleSpinnerView

- (CAShapeLayer*)circleLayer {
    if(!_circleLayer) {
        //calculates a CGPoint representing the center of the arc (in this case, an entire circle)
        //then arcCenter is used to construct a CGRect. The spinning circle will fit inside the rect.
        CGPoint arcCenter = CGPointMake(self.radius+self.strokeThickness/2+5, self.radius+self.strokeThickness/2+5);
        CGRect rect = CGRectMake(0, 0, arcCenter.x*2, arcCenter.y*2);
        
        //a bezier path is a path which can have both straight and curved line segments
        UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                                    radius:self.radius
                                                                startAngle:M_PI*3/2
                                                                  endAngle:M_PI/2+M_PI*5
                                                                 clockwise:YES]; //makes a new bezier path in the shape of an arc, with the start and end angles in radians
        
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.contentsScale = [[UIScreen mainScreen] scale];
        _circleLayer.frame = rect;
        //Core animation classes use CGColorRef instead of UIColor, so we convert them using CGColor
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = self.strokeColor.CGColor; //strokeColor changes the border color
        _circleLayer.lineWidth = self.strokeThickness;
        _circleLayer.lineCap = kCALineCapRound; //lineCap specifies the shape of the ends of the line
        _circleLayer.lineJoin = kCALineJoinBevel; //lineJoin specifies the shape of the joints between parts of the line
        _circleLayer.path = smoothedPath.CGPath; //smoothedPath represents a smooth circle
        
        //angle-mask will allow the circle to have a gradient on it
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id)[[UIImage imageNamed:@"angle-mask"] CGImage];
        maskLayer.frame = _circleLayer.bounds;
        _circleLayer.mask = maskLayer;
        
        CFTimeInterval animationDuration = 1; //specified in seconds
        CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]; //the speed of the movement will stay the same throughout the entire animation
        
        //animates the layter's rotation transform from 0 to pi * 2 (one full circular turn)
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.fromValue = @0;
        animation.toValue = @(M_PI*2);
        animation.duration = animationDuration;
        animation.timingFunction = linearCurve;
        animation.removedOnCompletion = NO;
        animation.repeatCount = INFINITY;
        animation.fillMode = kCAFillModeForwards; //fillMode specifies what happens when the animation is complete; kCAFillModeForwards leaves the layer on the screen after the animation
        animation.autoreverses = NO;
        [_circleLayer.mask addAnimation:animation forKey:@"rotate"];
        
        //animate the line that draws the circle itself
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = INFINITY;
        animationGroup.removedOnCompletion = NO;
        animationGroup.timingFunction = linearCurve;
        
        //animates the start of the stroke
        CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue = @0.015;
        strokeStartAnimation.toValue = @0.515;
        
        //animates the end of the stroke
        CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.fromValue = @0.485;
        strokeEndAnimation.toValue = @0.985;
        
        animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
        [_circleLayer addAnimation:animationGroup forKey:@"progress"];
        
    }
    return _circleLayer;
}

//positions the circle layer in the center of the view
- (void)layoutAnimatedLayer {
    [self.layer addSublayer:self.circleLayer];
    
    self.circleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [self layoutAnimatedLayer];
    } else {
        [self.circleLayer removeFromSuperlayer];
        self.circleLayer = nil;
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (self.superview != nil) {
        [self layoutAnimatedLayer];
    }
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    
    [_circleLayer removeFromSuperlayer];
    _circleLayer = nil;
    
    [self layoutAnimatedLayer];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    _circleLayer.strokeColor = strokeColor.CGColor;
}

- (void)setStrokeThickness:(CGFloat)strokeThickness {
    _strokeThickness = strokeThickness;
    _circleLayer.lineWidth = _strokeThickness;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.strokeThickness = 1;
        self.radius = 12;
        self.strokeColor = [UIColor purpleColor];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake((self.radius+self.strokeThickness/2+5)*2, (self.radius+self.strokeThickness/2+5)*2);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

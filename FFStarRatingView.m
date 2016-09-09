//
//  FFStarRatingView.m
//  FFStarRatingView
//
//  Created by caozhen@neusoft on 16/9/9.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "FFStarRatingView.h"
#define kDefaultStarNumber 5

#define kBackgroudStar @"backgroundStar"
#define kForengoudStar @"foregroundStar"

@interface FFStarRatingView ()

@property (nonatomic,strong) UIView *forenStarView;

@end


@implementation FFStarRatingView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfStar:kDefaultStarNumber];
}

- (instancetype)initWithFrame:(CGRect)frame numberOfStar:(NSInteger)stars {
    
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStars = stars;
        [self uiInit];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    _numberOfStars = kDefaultStarNumber;
    [self uiInit];
}
#pragma mark ---- init UI
- (void)uiInit {
    UIView *backStarView = [self createStarViewWithImageName:@"backgroundStar"];
    [self addSubview:backStarView];
    
    self.forenStarView = [self createStarViewWithImageName:@"foregroundStar"];
    [self addSubview:self.forenStarView];
}

- (UIView *)createStarViewWithImageName:(NSString *)name {
    
    CGRect rect = self.bounds;
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.clipsToBounds = YES;
    CGFloat starW = rect.size.width / _numberOfStars;
    CGFloat starH = rect.size.height;
    for (int i = 0; i < _numberOfStars; i++) {
        UIImageView *star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
        star.frame = CGRectMake(i * starW, 0, starW, starH);
        [view addSubview:star];
    }
    return view; 
}

#pragma mark ---- respons touch
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = self.bounds;
    if (CGRectContainsPoint(rect, point)) {
        [self modifyStarsWithPoint:point];
    }

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self modifyStarsWithPoint:point];
    }];
}

#pragma mark ---- change star rating

- (void)setScore:(CGFloat)score withAnim:(BOOL)isAnim {
    [self setScore:score withAnim:isAnim completion:nil];
}

// score between [0,1]
- (void)setScore:(CGFloat)score withAnim:(BOOL)isAnim completion:(void(^)(BOOL isFinish))completion {
    
    if (score < 0) score = 0;
    if (score > 1) score = 1;
    
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if (isAnim) {
        
        __weak typeof (self) weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf modifyStarsWithPoint:point];
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
        
    } else {
        [self modifyStarsWithPoint:point];
    }

}

// modify the width of self.fornStarsView by point.x
- (void)modifyStarsWithPoint:(CGPoint)point {
    
    CGFloat selfWidth = self.bounds.size.width;
    if (point.x < 0) point.x = 0;
    if (point.x > selfWidth) point.x = selfWidth;

    CGRect rect = self.forenStarView.frame;
    rect.size.width = point.x;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.forenStarView.frame = rect;

    });
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(starRatingView:score:)]) {
        [self.delegate starRatingView:self score:point.x/selfWidth];
    }
}

@end

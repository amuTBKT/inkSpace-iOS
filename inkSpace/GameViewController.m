//
//  GameViewController.m
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 14/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>

#import "Canvas.h"

@interface GameViewController () {
    int screenWidth, screenHeight;
    
    Canvas *canvas;
    GLKVector3 colors[6];
    
    CGRect visibleFrame, hiddenFrame;
}

@property (strong, nonatomic) EAGLContext *context;
@property (weak, nonatomic) IBOutlet UIButton *clearCanvasButton;
@property (weak, nonatomic) IBOutlet UIView *colorPallete;
@property (weak, nonatomic) IBOutlet UIImageView *activeColorSwatch;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    screenWidth = self.view.bounds.size.width;
    screenHeight = self.view.bounds.size.height;
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    // hide clear button
    [self.clearCanvasButton setHidden:true];
    
    [self.activeColorSwatch setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    
    // set tap gesture listener for color pallete
    for (UIView *child in [[self.colorPallete.subviews objectAtIndex:0] subviews]){
        UITapGestureRecognizer *tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleColorTaps:)];
        [child addGestureRecognizer:tapRecogniser];
    }
    
    visibleFrame = [self.colorPallete frame];
    hiddenFrame = CGRectOffset(visibleFrame, -screenWidth, 0);
    
    // color pallete presets
    colors[0] = GLKVector3Make(1, 0, 0);    // red
    colors[1] = GLKVector3Make(0, 1, 0);    // green
    colors[2] = GLKVector3Make(0, 0, 1);    // blue
    colors[3] = GLKVector3Make(1, 1, 0);    // yellow
    colors[4] = GLKVector3Make(0, 1, 1);    // cyan
    colors[5] = GLKVector3Make(1, 1, 1);    // white
    
    [self setupGL];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    canvas = [[Canvas alloc] initWithWidth:screenWidth andHeight:screenHeight];
    
    // enable depth test
    glEnable(GL_DEPTH_TEST);
}

- (void)tearDownGL
{
    [canvas clear];
    
    [EAGLContext setCurrentContext:self.context];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    // temporary
    [canvas rotateCanvas:CGPointMake(0, self.timeSinceLastUpdate * 20.f)];
    
    // update canvas
    [canvas update:self.timeSinceLastUpdate];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // set clear color
    glClearColor(0, 0, 0, 1);
    // clear color and depth buffer bits
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
 
    // render canvas
    [canvas render];
}

# pragma mark - Touch Events

- (IBAction)Pan:(UIPanGestureRecognizer *)panGestureRecogniser {
    CGPoint touchLocation = [panGestureRecogniser locationInView:panGestureRecogniser.view];

    if ([panGestureRecogniser state] == UIGestureRecognizerStateBegan){
        [canvas onTouchBegan:touchLocation];
    }
    else if ([panGestureRecogniser state] == UIGestureRecognizerStateEnded){
        [canvas onTouchEnd:touchLocation];
        
        // show clear button
        [self.clearCanvasButton setHidden:false];
    }
    else {
        CGPoint touchVelocity = [panGestureRecogniser velocityInView:panGestureRecogniser.view];
        [canvas onTouchMove:touchLocation touchVelocity:touchVelocity];
    }
}

- (IBAction)Tap:(UITapGestureRecognizer *)sender {
//    // toggle clear button visibility
//    if ([canvas.meshData count] > 0){
//        [self.clearCanvasButton setHidden:![self.clearCanvasButton isHidden]];
//    }
    
    // toggle visibility for color pallete
    if ([self.colorPallete frame].origin.x < 0){
        [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.colorPallete setFrame:visibleFrame];
        }completion:NULL];
    }
    else {
        [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.colorPallete setFrame:hiddenFrame];
        }completion:NULL];
    }
    
}

- (void)handleColorTaps:(UITapGestureRecognizer*)sender{
    UIImageView *view = (UIImageView*)sender.view;
    int index = (int)[[[[self.colorPallete subviews] objectAtIndex:0] subviews] indexOfObject:view];
    
    if (index >= 0){
        // update color for active color
        [self.activeColorSwatch setBackgroundColor:[UIColor colorWithRed:colors[index].x green:colors[index].g blue:colors[index].b alpha:1.f]];
        
        // set stroke color
        [canvas setStrokeColor:colors[index]];
    }
}

- (IBAction)clearCanvas:(UIButton *)sender {
    // clear canvas
    [canvas clear];
    
    // hide clear button
    [self.clearCanvasButton setHidden:true];
}

# pragma mark - Motion Events

// TODO: add accelerometer events

@end

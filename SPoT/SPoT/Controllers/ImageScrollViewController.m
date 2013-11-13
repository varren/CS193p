//
//  ImageScrollViewController.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "ImageScrollViewController.h"
#import "DataSource.h"
#import "FlickrFetcher.h"

@interface ImageScrollViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) NSURL *imageURL;
@end

@implementation ImageScrollViewController;

#pragma mark - Properties

- (UIImageView *)imageView{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

-(void)setImage:(NSDictionary *)image{
    _image = image;
    self.imageURL = [FlickrFetcher urlForPhoto:image format:FlickrPhotoFormatLarge];
    [self resetImage];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
/*
//from http://stackoverflow.com/questions/1316451/center-content-of-uiscrollview-when-smaller
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"zoomed");
    //UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    //subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
    //                             scrollView.contentSize.height * 0.5 + offsetY);
    subView.center = CGPointMake(scrollView.bounds.size.width * 0.5,
                                 scrollView.bounds.size.height * 0.5);
}
 */
#pragma mark - VCLifecicle

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorites-gray.png"]  forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorites-red.png"]  forState:UIControlStateSelected];
    self.favoriteButton.selected = [[[DataSource instance] favoritePhotos] containsObject:self.image];
    
    [self resetImage];
}

-(float)minZoomScaleToFillScreen{
    float wScale = self.scrollView.bounds.size.width/self.imageView.image.size.width;
    float hScale = self.scrollView.bounds.size.height/self.imageView.image.size.height;
    [self debug];
    return MAX(wScale, hScale);
}
-(void)debug{
    NSLog(@"Zoom Scale: %f", self.scrollView.zoomScale);

    NSLog(@"Content:%f*%f ",self.scrollView.contentSize.height,self.scrollView.contentSize.width);
    NSLog(@"Bounds:%f*%f | x:%f y:%f",self.scrollView.bounds.size.height,self.scrollView.bounds.size.width,self.scrollView.bounds.origin.x,self.scrollView.bounds.origin.y);
    NSLog(@"Frame:%f*%f | x:%f y:%f",self.scrollView.frame.size.height,self.scrollView.frame.size.width,self.scrollView.frame.origin.x,self.scrollView.frame.origin.y);
    NSLog(@"IMGBounds:%f*%f | x:%f y:%f",self.imageView.bounds.size.height,self.imageView.bounds.size.width,self.imageView.bounds.origin.x,self.imageView.bounds.origin.y);
    NSLog(@"IMGFrame:%f*%f | x:%f y:%f",self.imageView.frame.size.height,self.imageView.frame.size.width,self.imageView.frame.origin.x,self.imageView.frame.origin.y);
    NSLog(@"---------------------------------------------------------------");
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.zoomScale = [self minZoomScaleToFillScreen];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetImage];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.imageView.image = nil;
}

#pragma mark - Other

- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            self.scrollView.zoomScale = 1;
            self.scrollView.contentSize = image.size;
            // [self.scrollView zoomToRect:self.scrollView.bounds animated:NO];
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            self.scrollView.zoomScale = [self minZoomScaleToFillScreen];

       
        }
    }
}

- (IBAction)addToFavorite:(id)sender {
    self.favoriteButton.selected ? [[DataSource instance] removeFromFavorite:self.image] :[[DataSource instance] addFavoritePhoto:self.image];
    
    self.favoriteButton.selected = ! self.favoriteButton.selected;
}



@end

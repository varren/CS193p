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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) NSURL *imageURL;
@end

@implementation ImageScrollViewController

// resets the image whenever the URL changes
-(void)setImage:(NSDictionary *)image{
    _image = image;
    self.imageURL = [FlickrFetcher urlForPhoto:image format:FlickrPhotoFormatLarge];
}
- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

// fetches the data from the URL
// turns it into an image
// adjusts the scroll view's content size to fit the image
// sets the image as the image view's image

- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            self.scrollView.zoomScale = 1.0;
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
    }
}

// lazy instantiation

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

// returns the view which will be zoomed when the user pinches
// in this case, it is the image view, obviously
// (there are no other subviews of the scroll view in its content area)

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

// add the image view to the scroll view's content area
// setup zooming by setting min and max zoom scale
//   and setting self to be the scroll view's delegate
// resets the image in case URL was set before outlets (e.g. scroll view) were set

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self setFavoriteButtonImage];
    
    [self resetImage];
}
- (IBAction)addToFavorite:(id)sender {
    if([[[DataSource instance] favoritePhotos] containsObject:self.image])
        [[DataSource instance] removeFromFavorite:self.image];
    else
        [[DataSource instance] addFavoritePhoto:self.image];
    
    [self setFavoriteButtonImage];
}

-(void)setFavoriteButtonImage{
    self.favoriteButton.image =
    [[[DataSource instance] favoritePhotos] containsObject:self.image]
    ? [UIImage imageNamed:@"favorites-red.png"]
    : [UIImage imageNamed:@"favorites-gray.png"];
    
}

@end

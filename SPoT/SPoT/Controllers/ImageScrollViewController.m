//
//  ImageScrollViewController.m
//  SPoT
//
//  Created by mmh on 10/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "ImageScrollViewController.h"
#import "DataCache.h"

@interface ImageScrollViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *splitViewBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIImageView *imageView;

@property(nonatomic) BOOL imgHasLoaded;
@property (nonatomic) BOOL needToAutoResize;
@end

@implementation ImageScrollViewController;

#pragma mark - Properties

- (UIImageView *)imageView{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

-(void)setImageURL:(NSURL *)imageURL{
    _imageURL = imageURL;
    [self resetImage];
}
-(void)setTitle:(NSString *)title{
    super.title = title;
    self.barButtonTitle.title = title;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self centerImage];
}

#pragma mark - Segue fn and properties setters
-(void) setSplitViewBarButtonItem:(UIBarButtonItem *) barButtonItem{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
  
    if (_splitViewBarButtonItem)
        [toolbarItems removeObject:_splitViewBarButtonItem];
    if (barButtonItem)
        [toolbarItems insertObject:barButtonItem atIndex:0];
        
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = barButtonItem;
}

-(void)setFavoriteButton:(UIBarButtonItem *)favoriteButton{

    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];

    if(favoriteButton){
        // probably can create conditions here...
        // but it works fine this way
        // if iPhone => navigationBar iPad => toolbar
        [toolbarItems addObject:favoriteButton];
        self.navigationItem.rightBarButtonItem = favoriteButton;
    }
    
    self.toolbar.items = toolbarItems;
    _favoriteButton = favoriteButton;
}

#pragma mark - VC Life Cicle

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    
    self.needToAutoResize = YES;
   
    self.barButtonTitle.title  = self.title;
    self.splitViewBarButtonItem = self.splitViewBarButtonItem;
    self.favoriteButton = self.favoriteButton;
    
    [self resetImage];
}

-(float)zoomScaleToFillScreen{
    float wScale = self.scrollView.bounds.size.width/self.imageView.image.size.width;
    float hScale = self.scrollView.bounds.size.height/self.imageView.image.size.height;
    return MAX(wScale, hScale);
}

-(void)viewWillLayoutSubviews{
    self.needToAutoResize = CGRectIsEmpty(self.scrollView.bounds) ||
    self.scrollView.contentSize.height == self.scrollView.bounds.size.height ||
    self.scrollView.contentSize.width == self.scrollView.bounds.size.width;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if(self.needToAutoResize)
        self.scrollView.zoomScale = [self zoomScaleToFillScreen];
    else
        [self centerImage];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self resetImage];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.imageView.image = nil;
}

#pragma mark - Other

- (void)resetImage{
    if (self.scrollView && !self.imgHasLoaded) {
        self.imgHasLoaded = YES;

        
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        [self.activityIndicator startAnimating];
        
        dispatch_queue_t loaderQueue = dispatch_queue_create("Image Loader", NULL);
        dispatch_async(loaderQueue, ^{
            
            UIImage *image = [[DataCache instance] getImage: self.imageURL];
            
                dispatch_async(dispatch_get_main_queue(),^{
                    if (image) {
                        self.scrollView.zoomScale = 1;
                        self.scrollView.contentSize = image.size;
                        self.imageView.image = image;
                        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                        if(self.needToAutoResize)
                            self.scrollView.zoomScale = [self zoomScaleToFillScreen];
                    }
                    
                    [self.activityIndicator stopAnimating];
                });
        });
        
    } 
}


-(void)centerImage{
    //Code from http://stackoverflow.com/questions/1316451/center-content-of-uiscrollview-when-smaller
    
    CGFloat offsetX = (self.scrollView.bounds.size.width > self.scrollView.contentSize.width)?
    (self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (self.scrollView.bounds.size.height > self.scrollView.contentSize.height)?
    (self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX, self.scrollView.contentSize.height * 0.5 + offsetY);
}

@end

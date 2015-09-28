//
//  DetailViewController.swift
//  SDWebImageExample
//
//  Created by Vladimir Goncharov on 16.09.15.
//  Copyright © 2015 FlatStack. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var imageURL: NSURL? {
        didSet {
            self.configureView()
        }
    }

    //MARK: - UI
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    //MARK: - UI helper
    private func configureView() {
        if let lImageURL = self.imageURL {
            self.imageView.sd_set
        }
    }
}


- (void)configureView
    {
        if (self.imageURL) {
            __block UIActivityIndicatorView *activityIndicator;
            __weak UIImageView *weakImageView = self.imageView;
            [self.imageView sd_setImageWithURL:self.imageURL
                placeholderImage:nil
                options:SDWebImageProgressiveDownload
                progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                if (!activityIndicator) {
                [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                activityIndicator.center = weakImageView.center;
                [activityIndicator startAnimating];
                }
                }
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [activityIndicator removeFromSuperview];
                activityIndicator = nil;
                }];
        }
    }
    
    - (void)viewDidLoad
        {
            [super viewDidLoad];
            [self configureView];
        }
        
        - (void)viewDidUnload
            {
                [super viewDidUnload];
                self.imageView = nil;
            }
            
            - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
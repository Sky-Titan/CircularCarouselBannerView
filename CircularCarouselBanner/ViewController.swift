//
//  ViewController.swift
//  CircularCarouselBanner
//
//  Created by 박준현 on 2022/08/19.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circularBannerView: CircularCarouselBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let images: [UIImage?] = [UIImage(named: "img0"), UIImage(named: "img1"), UIImage(named: "img2"), UIImage(named: "img3")]
        circularBannerView.images = images
        circularBannerView.isAutoScroll = true
        circularBannerView.startAutoScroll()
    }


}


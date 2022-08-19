//
//  CircularCarouselBannerView.swift
//  CircularCarouselBanner
//
//  Created by 박준현 on 2022/08/19.
//

import UIKit

class CircularCarouselBannerView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var images: [UIImage?] = [] {
        didSet {
            setupInnerItems()
        }
    }
    var autoScrollDuration: Double = 3
    var isAutoScroll: Bool = false
    
    private var innerItems: [UIImage?] = [] {
        didSet {
            setupImageViews()
        }
    }
    private var timer: Timer?
    private var sectionWidth: CGFloat {
        self.frame.width
    }
    private var sectionHeight: CGFloat {
        self.frame.height
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        if Bundle.main.loadNibNamed("CircularCarouselBannerView", owner: self) != nil {
            addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: self.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
            scrollView.delegate = self
        }
    }
    
    deinit {
        stopAutoScroll()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupImageViews()
    }
    
    private func setupInnerItems() {
        self.innerItems.removeAll()
        
        var items: [UIImage?] = []
        if images.count > 1 {
            items.append(images.last ?? UIImage())
            items.append(contentsOf: images)
            items.append(images.first ?? UIImage())
        } else {
            items.append(contentsOf: images)
        }
        
        //앞뒤에 추가로 아이템을 이어붙인 image array
        self.innerItems = items
    }
    
    private func setupImageViews() {
        scrollView.subviews.forEach({
            $0.removeFromSuperview()
        })
        var x: CGFloat = 0
        
        for image in self.innerItems {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: x, y: 0, width: sectionWidth, height: sectionHeight)
            imageView.contentMode = .scaleAspectFill
            scrollView.addSubview(imageView)
            x += sectionWidth
        }
        
        //content size 지정
        scrollView.contentSize.width = x
        scrollView.contentSize.height = sectionHeight
        
        // 첫번째 이미지 위치로 초기화
        scrollView.contentOffset.x = sectionWidth
    }
    
    func startAutoScroll() {
        stopAutoScroll()
        timer = Timer.scheduledTimer(timeInterval: autoScrollDuration, target: self, selector: #selector(moveToRight), userInfo: nil, repeats: true)
    }
    
    func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    private func moveToRight() {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + sectionWidth, y: 0), animated: true)
    }
}
extension CircularCarouselBannerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 맨 앞에 도착한 경우
        if scrollView.contentOffset.x <= 0 {
            self.scrollView.contentOffset.x = CGFloat(images.count) * sectionWidth
        }
        
        // 맨 뒤에 도착한 경우
        if scrollView.contentOffset.x >= CGFloat(innerItems.count - 1) * sectionWidth {
            self.scrollView.contentOffset.x = sectionWidth
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoScroll {
            startAutoScroll()
        }
    }
}

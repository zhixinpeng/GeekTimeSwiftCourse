//
//  BannerView.swift
//  SwiftCourse
//
//  Created by 彭智鑫 on 2022/8/9.
//

import UIKit

protocol BannerViewDataSource: AnyObject {
    func numberOfBanners(_ bannerView: BannerView) -> Int
    func viewForBanner(_ bannerView: BannerView, index: Int, convertView: UIView?) -> UIView
}

protocol BannerViewDelegate: AnyObject {
    func didSelectBanner(_ bannerView: BannerView, index: Int)
}

class BannerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView
    var flowLayout: UICollectionViewFlowLayout
    var pageControl: UIPageControl
    var autoScrollInterval: Float = 0 {
        didSet {
            if self.autoScrollInterval > 0 {
                self.startAutoScroll()
            } else {
                self.stopAutoScroll()
            }
        }
    }
    var isInfinite: Bool = true
    var timer: Timer?
    
    weak var dataSource: BannerViewDataSource! {
        didSet {
            pageControl.numberOfPages = self.dataSource.numberOfBanners(self)
            collectionView.reloadData()
            if isInfinite {
                DispatchQueue.main.async {
                    self.collectionView.setContentOffset(CGPoint(x: self.collectionView.frame.width, y: 0), animated: false)
                }
            }
        }
    }
    weak var delegate: BannerViewDelegate?
    
    static var cellId = "bannerViewCell"
    static var convertViewTag = 10086
    
    override init(frame: CGRect) {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = .zero
        flowLayout.footerReferenceSize = .zero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        flowLayout.collectionView?.insetsLayoutMarginsFromSafeArea = true
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: flowLayout)
        pageControl = UIPageControl()
        
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: BannerView.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        addSubview(pageControl)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let pageNumber = dataSource.numberOfBanners(self)
        if isInfinite {
            return pageNumber == 1 ? 1 : pageNumber + 2
        } else {
            return pageNumber
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerView.cellId, for: indexPath)
        var index = indexPath.row
        
        if isInfinite {
            let pageNumber = dataSource.numberOfBanners(self)
            if pageNumber > 1 {
                if indexPath.row == 0 {
                    index = pageNumber - 1
                } else if indexPath.row == pageNumber + 1 {
                    index = 0
                } else {
                    index = indexPath.row - 1
                }
            }
        }
        
        if let view = cell.contentView.viewWithTag(BannerView.convertViewTag) {
            let _ = dataSource.viewForBanner(self, index: index, convertView: view)
        } else {
            let newView = dataSource.viewForBanner(self, index: index, convertView: nil)
            newView.tag = BannerView.convertViewTag
            cell.contentView.addSubview(newView)
            newView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        return cell
    }
    
    func startAutoScroll() {
        guard autoScrollInterval > 0 && timer == nil else {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(autoScrollInterval), target: self, selector: #selector(flipNext), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stopAutoScroll() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    @objc func flipNext() {
        guard let _ = superview, let _ = window else {
            return
        }
        
        let total = dataSource.numberOfBanners(self)
        guard total > 1 else {
            return
        }
        
        let currentPage = Int(round(collectionView.contentOffset.x / collectionView.frame.width))
        
        if isInfinite {
            let nextPage = currentPage + 1
            collectionView.setContentOffset(CGPoint(x: collectionView.frame.width * CGFloat(nextPage), y: 0), animated: true)
            if nextPage >= total + 1 {
                pageControl.currentPage = 0
            } else {
                pageControl.currentPage = nextPage - 1
            }
        } else {
            var nextPage = currentPage + 1
            if nextPage >= total {
                nextPage = 0
            }
            collectionView.setContentOffset(CGPoint(x: collectionView.frame.width * CGFloat(nextPage), y: 0), animated: true)
            pageControl.currentPage = nextPage
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let total = dataSource.numberOfBanners(self)
        let current = Int(round(collectionView.contentOffset.x / collectionView.frame.width))
        if current >= total + 1 {
            collectionView.setContentOffset(CGPoint(x: collectionView.frame.width, y: 0), animated: false)
        }
    }
}

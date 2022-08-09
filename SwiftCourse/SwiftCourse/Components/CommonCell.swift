//
//  CommonCell.swift
//  SwiftCourse
//
//  Created by 彭智鑫 on 2022/8/9.
//

import UIKit

class CommonCell: UIControl {
    var title: String? {
        didSet {
            self.titleView.text = self.title
        }
    }
    var icon: UIImage? {
        didSet {
            self.iconView.image = self.icon
        }
    }
    var titleView: UILabel
    var iconView: UIImageView
    var bottomLine: UIView
    var arrowView: UIImageView
    var highlightView: UIView
    
    override init(frame: CGRect) {
        titleView = UILabel()
        iconView = UIImageView()
        bottomLine = UIView()
        arrowView = UIImageView(image: R.image.icon_right_arrow())
        highlightView = UIView()
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(highlightView)
        highlightView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        highlightView.isHidden = true
        highlightView.alpha = 0
        highlightView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        addSubview(titleView)
        titleView.textColor = UIColor.hexColor(0x333333)
        titleView.font = UIFont.systemFont(ofSize: 15)
        titleView.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        addSubview(arrowView)
        arrowView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor(white: 0.95, alpha: 1)
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1 / UIScreen.main.scale)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = self.isHighlighted
            if self.isHighlighted {
                self.highlightView.alpha = 1
                self.highlightView.isHidden = false
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.highlightView.alpha = 0
                } completion: { _ in
                    self.highlightView.isHidden = true
                }

            }
        }
    }
}

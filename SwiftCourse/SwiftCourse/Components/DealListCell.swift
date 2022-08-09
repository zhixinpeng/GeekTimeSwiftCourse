//
//  DealListCell.swift
//  SwiftCourse
//
//  Created by 彭智鑫 on 2022/8/9.
//

import UIKit
import SnapKit

class DealListCell: CommonListCell<Deal> {
    let progressLabel: UILabel
    let productImageView: UIImageView
    
    override var item: Deal? {
        didSet {
            if let item = item {
                self.productImageView.kf.setImage(with: URL(string: item.product.imageUrl))
                self.textLabel?.text = item.product.name
                self.detailTextLabel?.text = item.product.desc
                self.progressLabel.text = "已经学习 \(item.progress)%"
            }
        }
    }
    
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        progressLabel = UILabel(frame: .zero)
        productImageView = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        textLabel?.textColor = UIColor.hexColor(0x333333)
        detailTextLabel?.textColor = UIColor.hexColor(0x999999)
        detailTextLabel?.numberOfLines = 2
        progressLabel.textColor = UIColor.hexColor(0xe23b41)
        progressLabel.font = UIFont.systemFont(ofSize: 15)
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        
        contentView.addSubview(progressLabel)
        contentView.addSubview(productImageView)
        
        productImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(100)
        }
        
        textLabel?.snp.makeConstraints({ make in
            make.left.equalTo(productImageView.snp.right).offset(12)
            make.top.equalTo(productImageView)
            make.right.equalTo(contentView).offset(-10)
        })
        
        progressLabel.snp.makeConstraints { make in
            make.left.equalTo(textLabel!)
            make.centerY.equalTo(contentView)
        }
        
        detailTextLabel?.snp.makeConstraints { make in
            make.left.equalTo(textLabel!)
            make.bottom.equalTo(productImageView)
            make.right.equalTo(contentView).offset(-20)
        }
    }
}

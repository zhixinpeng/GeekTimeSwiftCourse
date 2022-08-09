//
//  DealListViewController.swift
//  SwiftCourse
//
//  Created by 彭智鑫 on 2022/8/9.
//

import UIKit
import SnapKit

class DealListViewController: BaseViewController, CommonListDelegate {
    func didSelectItem<Item>(_ item: Item) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let productList = CommonList<Deal, DealListCell>(frame: .zero)
        productList.items = FakeData.createDeals()
        productList.delegate = self
        view.addSubview(productList)
        productList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

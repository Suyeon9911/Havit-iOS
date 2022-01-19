//
//  CategoryListTableViewCell.swift
//  Havit
//
//  Created by SHIN YOON AH on 2022/01/16.
//

import UIKit

import SnapKit
import RxCocoa

final class CategoryListTableViewCell: BaseTableViewCell {
    
    private enum Count {
        static let maxCategoryCountInPage = 6
        static let allContentPart = 1
    }
    
    private enum CategoryType: Int {
        case allContent = 0
    }
    
    // MARK: - property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.pretendardSemibold, ofSize: 17)
        label.textColor = .primaryBlack
        label.text = "박태준님의 카테고리"
        return label
    }()
    private let overallButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .font(.pretendardReular, ofSize: 12)
        button.setTitleColor(.gray003, for: .normal)
        button.setTitle("전체보기", for: .normal)
        return button
    }()
    private lazy var categoryCollectionView: UICollectionView = {
        let flowLayout = MainCategoryCollectionViewFlowLayout(row: 2, column: 3)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.register(cell: CategoryListCollectionViewCell.self)
        return collectionView
    }()
    private let pageControl = MainCategoryPageControl()
    
    var dummyCategories: [String] = ["카테고리1", "카테고리2", "카테고리3", "카테고리4", "카테고리5", "카테고리6", "카테고리1", "카테고리2", "카테고리3", "카테고리4", "카테고리5", "카테고리6", "카테고리1", "카테고리2", "카테고리3"]
    
    // MARK: - func
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        contentView.addSubViews([titleLabel, overallButton, categoryCollectionView, pageControl])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        overallButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(-4)
            $0.trailing.equalToSuperview().inset(19)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(-10)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(348)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(-10)
            $0.bottom.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func configUI() {
        backgroundColor = .white
        applyPageControlPages()
    }
    
    // MARK: - func
    
    private func bind() {
        categoryCollectionView.rx.willEndDragging
            .asDriver()
            .drive(onNext: { [weak self] _, targetContentOffset in
                guard
                    let layout = self?.categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout,
                    let collectionViewContentInsetLeft = self?.categoryCollectionView.contentInset.left,
                    let collectionViewContentOffsetX = self?.categoryCollectionView.contentOffset.x
                else { return }
                let pageWidth = layout.collectionView?.frame.width ?? 0
                let offsetPoint = targetContentOffset.pointee
                var selectedIndex = (offsetPoint.x + collectionViewContentInsetLeft) / pageWidth

                if collectionViewContentOffsetX > targetContentOffset.pointee.x {
                    selectedIndex = floor(selectedIndex)
                } else if collectionViewContentOffsetX < targetContentOffset.pointee.x {
                    selectedIndex = ceil(selectedIndex)
                } else {
                    selectedIndex = round(selectedIndex)
                }
                
                self?.pageControl.selectedPage = Int(selectedIndex)
            })
            .disposed(by: disposeBag)
    }
    
    private func applyPageControlPages() {
        let totalCellCount = calculateTotalCategoryCellCount(with: dummyCategories)
        pageControl.pages = totalCellCount / Count.maxCategoryCountInPage
    }
    
    private func calculateTotalCategoryCellCount(with categories: [String]) -> Int {
        var categoryCount = categories.count + Count.allContentPart
        let filledCategoryCountInLastPage = categoryCount % Count.maxCategoryCountInPage
        let hasPlaceHolderCell = filledCategoryCountInLastPage != 0
        if hasPlaceHolderCell {
            let placeHolderCategoryCount = Count.maxCategoryCountInPage - filledCategoryCountInLastPage
            categoryCount += placeHolderCategoryCount
        }
        return categoryCount
    }
}

extension CategoryListTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let totalCellCount = calculateTotalCategoryCellCount(with: dummyCategories)
        return totalCellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoryListCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let hasCategoryData = dummyCategories.count + Count.allContentPart > indexPath.item
        if hasCategoryData {
            let categoryType = CategoryType.init(rawValue: indexPath.row)
            switch categoryType {
            case .allContent:
                cell.backgroundImageView.image = ImageLiteral.imgCardCategoryLine
                cell.updateCategory(image: UIImage(),
                                    title: "모든 콘텐츠",
                                    contentCount: 90)
            default:
                cell.updateCategory(image: ImageLiteral.imgCategoryNone,
                                    title: dummyCategories[indexPath.item - 1],
                                    contentCount: 27)
            }
            return cell
        } else {
            cell.backgroundColor = .clear
            return cell
        }
    }
}

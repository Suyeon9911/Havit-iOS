//
//  CategoryContentsViewController.swift
//  Havit
//
//  Created by SHIN YOON AH on 2022/01/06.
//

import UIKit

import RxSwift
import SnapKit

final class CategoryContentsViewController: BaseViewController {
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "원하는 콘텐츠를 검색하세요."
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        return view
    }()
    var filterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    var totalLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 0"
        return label
    }()
    var changeShowButton: UIButton = {
        let button = UIButton()
        button.setTitle("B", for: .normal)
        button.backgroundColor = UIColor.blue
        return button
    }()
    var sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("최근순", for: .normal)
        button.backgroundColor = UIColor.blue
        return button
    }()
    
    var filterCollectionView: UICollectionView = {
        return UICollectionView(frame: CGRect.zero,
                                collectionViewLayout: UICollectionViewFlowLayout.init())
    }()
    var contentsCollectionView: UICollectionView = {
        UICollectionView(frame: CGRect.zero,
                         collectionViewLayout: UICollectionViewFlowLayout.init())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViews()
        setNavigationItems()
    }
    
    override func configUI() {
        // 네비게이션바 생성하기 (메인화면에서 Coordinator로 진입
        
    }
    
    override func render() {
        
        // 메인 뷰 생성
        self.view.addSubview(mainView)
        
        // 필터 뷰 생성
        self.view.addSubview(filterView)
        filterView.addSubview(totalLabel)
        filterView.addSubview(changeShowButton)
        filterView.addSubview(sortButton)
        // 필터 컬렉션 뷰 생성
        filterCollectionView.backgroundColor = .blue
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(cell: CategoryFilterCollectionViewCell.self)
        filterView.addSubview(filterCollectionView)
        
        // 메인 컨텐츠 뷰 생성
        contentsCollectionView.backgroundColor = .green
        contentsCollectionView.delegate = self
        contentsCollectionView.dataSource = self
        contentsCollectionView.register(cell: SortTwoContentsCollectionViewCell.self)
        mainView.addSubview(contentsCollectionView)
        
        mainView.snp.makeConstraints {
            $0.leading.equalTo(view)
            $0.bottom.equalTo(view)
            $0.trailing.equalTo(view)
            $0.top.equalTo(view).offset(17)
        }
        
        filterView.snp.makeConstraints {
            $0.leading.trailing.equalTo(mainView).offset(0)
            $0.top.equalTo(mainView).offset(17)
            $0.height.equalTo(67)
        }
        
        totalLabel.snp.makeConstraints {
            $0.leading.equalTo(filterView).offset(16)
            $0.top.equalTo(filterView).offset(0)
        }
        
        changeShowButton.snp.makeConstraints {
            $0.top.equalTo(filterView).offset(0)
            $0.trailing.equalTo(filterView).offset(-16)
            $0.width.equalTo(18)
            $0.height.equalTo(18)
        }
        
        sortButton.snp.makeConstraints {
            $0.bottom.equalTo(filterView).offset(-19)
            $0.trailing.equalTo(filterView).offset(-16)
            $0.width.equalTo(47)
            $0.height.equalTo(15)
        }
        
        filterCollectionView.snp.makeConstraints {
            $0.leading.equalTo(filterView).offset(0)
            $0.bottom.equalTo(filterView).offset(-9)
            $0.width.equalTo(250)
            $0.height.equalTo(31)
        }
        
        contentsCollectionView.snp.makeConstraints {
            $0.top.equalTo(filterView).offset(67)
            $0.leading.equalTo(mainView).offset(0)
            $0.trailing.equalTo(mainView).offset(0)
            $0.bottom.equalTo(mainView).offset(0)
        }
    }
    
    func setNavigationItems() {
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "카테고리"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setCollectionViews() {
        
    }
}

extension CategoryContentsViewController: UISearchBarDelegate {
    
}

extension CategoryContentsViewController: UICollectionViewDelegate {
    
}

extension CategoryContentsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case filterCollectionView:
            let cell: CategoryFilterCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.filterNameLabel.text = "앙대"
            
            return cell
        case contentsCollectionView:
            let cell: SortTwoContentsCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.backgroundColor = .white
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension CategoryContentsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case filterCollectionView:
            return 3
        case contentsCollectionView:
            return 10
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case filterCollectionView:
            return CGSize(width: 50, height: 31)
        case contentsCollectionView:
            return CGSize(width: (view.frame.width / 2) - 9, height: 139)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}

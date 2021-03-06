//
//  EventDetailPhotoTableCell.swift
//  IceHockey
//
//  Created by  Buxlan on 10/19/21.
//

import UIKit

class EventDetailPhotoView: UITableViewCell {
    
    // MARK: - Properties
    
    typealias DataType = EventDetailPhotoCellModel
    var isInterfaceConfigured = false
    var imageAspectRate: CGFloat = 1
    var data: DataType?
    var collectionBase = CollectionViewBase()
    
    private lazy var collectionView: PhotoCollectionView = {
        let layout = EventDetailPhotoCollectionViewLayout()
        layout.delegate = self
        let view = PhotoCollectionView(frame: .zero, collectionViewLayout: layout)
        view.accessibilityIdentifier = "collectionView (inside table cell)"
        view.backgroundColor = Asset.other1.color
        view.isUserInteractionEnabled = true
        view.allowsSelection = true
        view.allowsMultipleSelection = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true
        view.register(EventDetailPhotoCollectionViewCell.self,
                      forCellWithReuseIdentifier: EventDetailPhotoCollectionViewCell.reuseIdentifier)
        return view
    }()
    
    private let usefulButtonsView = EventDetailUsefulButtonsView()
    
    private lazy var pageControl: ScrollingPageControl = {
        let view = ScrollingPageControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecircle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        isInterfaceConfigured = false
    }
    
    // MARK: - Helper functions
    
    func configureUI() {
        if isInterfaceConfigured { return }
        collectionBase.setupCollection(collectionView)
        contentView.backgroundColor = Asset.other2.color
        tintColor = Asset.other1.color
//        contentView.addSubview(coloredView)
        contentView.addSubview(collectionView)
        contentView.addSubview(usefulButtonsView)
        contentView.addSubview(pageControl)
        usefulButtonsView.translatesAutoresizingMaskIntoConstraints = false
        configureConstraints()
        isInterfaceConfigured = true
    }
    
    internal func configureConstraints() {
        let constraints: [NSLayoutConstraint] = [
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor),
            
            usefulButtonsView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0),
            usefulButtonsView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            usefulButtonsView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            usefulButtonsView.heightAnchor.constraint(equalToConstant: 40),
            usefulButtonsView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: usefulButtonsView.centerYAnchor),
            pageControl.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            pageControl.heightAnchor.constraint(equalToConstant: 16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension EventDetailPhotoView: ConfigurableCollectionContent {
    
    func configure(with data: DataType) {
        configureUI()
        self.data = data
        
        var viewModel = EventDetailUsefulButtonsCellModel(likesInfo: data.likesInfo,
                                                          viewsInfo: data.viewsInfo)
        viewModel.likeAction = { state in
            guard let data = self.data else {
                return
            }
            self.data?.likesInfo.isLiked = state
            
            let count = data.likesInfo.count + (state ? 1 : -1)
            self.data?.likesInfo.count = count
            self.data?.likeAction(state)
        }
        viewModel.shareAction = {
            self.data?.shareAction()
        }
        usefulButtonsView.configure(with: viewModel)
        pageControl.numberOfPages = data.images.count
        let collectionDataSource = makeCollectionViewDataSource(images: data.images)
        collectionBase.updateDataSource(collectionDataSource)
        collectionView.reloadData()        
        
        collectionView.backgroundColor = data.backgroundColor
        collectionView.tintColor = data.tintColor        
        
    }
    
}

extension EventDetailPhotoView: EventCollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, getSizeAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
        return .init(width: width, height: width)
    }
    
}

extension EventDetailPhotoView {
    
    func makeCollectionViewDataSource(images: [ImageData]) -> CollectionDataSource {
        let size = CGSize(width: 0, height: 0)
        var collectionRows = [CollectionRow]()
        for (index, imageData) in images.enumerated() {
            let row = makePhotoCollectionRow(imageData: imageData, size: size)
            row.willDisplay = {
                self.pageControl.currentPage = index
            }
            collectionRows.append(row)
        }
        var dataSource = CollectionDataSource()
        var section = CollectionSection()
        section.addRows(collectionRows)
        dataSource.addSection(section)
        return dataSource
    }
    
    func makePhotoCollectionRow(imageData: ImageData, size: CGSize) -> CollectionRow {
        let image = imageData.image
        let cellModel = PhotoCellModel(image: image)
        let config = EventDetailPhotoCollectionCellConfigurator(data: cellModel)
        let row = CollectionRow(rowId: type(of: config).reuseIdentifier, config: config, size: size)
        return row
    }
}

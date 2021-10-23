//
//  EventDetailPhotoTableCell.swift
//  IceHockey
//
//  Created by  Buxlan on 10/19/21.
//

import UIKit

class EventDetailPhotoTableCell: UITableViewCell, CollectionViewDelegate {
    
    // MARK: - Properties
    
    typealias DataType = [String]
    var isInterfaceConfigured = false
    var imageAspectRate: CGFloat = 1
    var timer: Timer?
    weak var delegate: UICollectionViewDelegate?
    private var viewModel = EventDetailPhotoCellModel()
    
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
        
        view.delegate = self
        view.dataSource = self

//        view.layer.shadowRadius = 10.0
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOffset = CGSize()
//        view.layer.shadowOpacity = 0.8
//        view.layer.shouldRasterize = true
//        view.layer.rasterizationScale = UIScreen.main.scale
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(collectionViewLongPressHandle))
        gesture.minimumPressDuration = 1.0
        view.addGestureRecognizer(gesture)
        
        return view
    }()
    
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
        contentView.backgroundColor = Asset.other2.color
        tintColor = Asset.other1.color
//        contentView.addSubview(coloredView)
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        configureConstraints()
        isInterfaceConfigured = true
    }
    
    internal func configureConstraints() {
        let constraints: [NSLayoutConstraint] = [
//            collectionView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor),
//            collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
            collectionView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            pageControl.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            pageControl.heightAnchor.constraint(equalToConstant: 16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true) { [weak self] (_) in
            guard let self = self else {
                return
            }
            let pageWidth = self.collectionView.frame.size.width
            let currentPage = Int(self.collectionView.contentOffset.x / pageWidth)

            var newItemIndex = currentPage + 1
            let numberOfPages = self.collectionView.numberOfItems(inSection: 0)
            if newItemIndex == numberOfPages {
                newItemIndex = 0
            }
            let indexPath = IndexPath(item: newItemIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc
    private func collectionViewLongPressHandle(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            timer?.invalidate()
            timer = nil
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            startTimer()
        }
    }
}

extension EventDetailPhotoTableCell: ConfigurableCell {
    
    func configure(with data: DataType) {
        configureUI()
        viewModel.images = data
        pageControl.numberOfPages = data.count
        collectionView.reloadData()
        startTimer()
    }
    
}

extension EventDetailPhotoTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.item(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseIdentifier,
                                                      for: indexPath)
        item.configure(cell: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("touched")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(page)
    }
}

extension EventDetailPhotoTableCell: EventCollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, getSizeAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
        return .init(width: width, height: width)
    }
    
}
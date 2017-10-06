//
//  DiscoverViewController.swift
//  Mangi
//
//  Created by Marco Mempin on 10/6/17.
//  Copyright © 2017 marcowesome. All rights reserved.
//

import UIKit
import IGListKit

class DiscoverViewController: UIViewController {

    // MARK: Data
    let dicoverLoader = DiscoverLoader()
    var movies = [Movie]()
    
    // MARK: IGListKit
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    // MARK: UI
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .white
        return view
    }()
    let activityLoader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loader.startAnimating()
        return loader
    }()
    let refreshControl = UIRefreshControl()
    var loading = false
    let spinToken = "spinner"
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Discover"
        
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        view.addSubview(collectionView)
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: Functions
    func getData() {
        self.dicoverLoader.getMovies {
            self.movies = self.dicoverLoader.movies
            self.refreshControl.endRefreshing()
            self.adapter.performUpdates(animated: true)
        }
    }
}

// MARK: - ListAdapterDataSource
extension DiscoverViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var objects = movies as [ListDiffable]
        
        if loading {
            objects.append(spinToken as ListDiffable)
        }
        
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
            
        case is String:
            return spinnerSectionController()
            
        case is Movie:
            let movie = object as! Movie
            let popularity = "Popularity: \((roundf(Float(movie.popularity)!) / 1000.0) * 100)% "
            return ListStackedSectionController(sectionControllers: [imageSectionController(with: movie.posterPath ?? movie.backdropPath ?? ""), labelSectionController(with: movie.title), labelSectionController(with: popularity)])
            
        default:
            return spinnerSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return listAdapter.objects().count != 0 ? nil : activityLoader
    }
}

// MARK: - ListSingleSectionControllerDelegate
extension DiscoverViewController: ListSingleSectionControllerDelegate {
    func didSelect(_ sectionController: ListSingleSectionController, with object: Any) {
        
    }
}

// MARK: - UIScrollViewDelegate
extension DiscoverViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !loading && distance < 200 {
            loading = true
            adapter.performUpdates(animated: true, completion: nil)
            DispatchQueue.global(qos: .default).async {
                DispatchQueue.main.async {
                    self.loading = false
                    self.dicoverLoader.getMovies(for: self.dicoverLoader.currentPage) {
                        self.movies = self.dicoverLoader.movies
                        self.adapter.performUpdates(animated: true)
                    }
                }
            }
        }
    }
}

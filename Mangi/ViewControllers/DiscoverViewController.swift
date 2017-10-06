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
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Discover"
        
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        view.addSubview(collectionView)
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
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

extension DiscoverViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return movies
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
            
        case is Movie:
            let movie = object as! Movie
            return ListStackedSectionController(sectionControllers: [imageSectionController(with: movie.posterPath ?? movie.backdropPath ?? "")])
            
        default:
            return spinnerSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return listAdapter.objects().count != 0 ? nil : activityLoader
    }
}

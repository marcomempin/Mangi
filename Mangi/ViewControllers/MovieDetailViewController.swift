//
//  MovieDetailViewController.swift
//  Mangi
//
//  Created by Marco Mempin on 10/6/17.
//  Copyright © 2017 marcowesome. All rights reserved.
//

import UIKit
import IGListKit

class MovieDetailViewController: UIViewController {

    let movieLoader = MovieLoader()
    var movie: Movie!

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
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = movie.title
        
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
        movieLoader.getMovieDetails(for: Int(movie.id)!) { movie in
            self.movie = movie
            self.adapter.reloadData()
        }
    }
}

// MARK: - ListAdapterDataSource
extension MovieDetailViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [movie as ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let movie = object as! Movie
        let popularity = "\((roundf(Float(movie.popularity)!) / 1000.0) * 100)% "
        return ListStackedSectionController(sectionControllers:
            [imageSectionController(with: movie.posterPath ?? movie.backdropPath ?? ""),
             headerSectionController(with: "TITLE"),
             labelSectionController(with: movie.title),
             headerSectionController(with: "POPULARITY"),
             labelSectionController(with: popularity),
             headerSectionController(with: "SYNOPSIS"),
             labelSectionController(with: movie.overview),
             headerSectionController(with: movie.genres!.count > 1 ? "GENRES" : "GENRE"),
             labelSectionController(with: movie.genres!.count != 0 ? movie.genres!.minimalDescription : "Data unavailable"),
             headerSectionController(with: movie.languages!.count > 1 ? "LANGUAGES" : "LANGUAGE"),
             labelSectionController(with: movie.languages!.count != 0 ? movie.languages!.minimalDescription : "Data unavailable"),
             headerSectionController(with: "DURATION"),
             labelSectionController(with: "\(movie.duration) minutes"),
             buttonSectionController()])
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return listAdapter.objects().count != 0 ? nil : activityLoader
    }
}

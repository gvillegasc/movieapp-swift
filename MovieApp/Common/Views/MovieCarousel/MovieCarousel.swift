//
//  MovieCarousel.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 18/09/21.
//

import UIKit

protocol MovieCarouselProtocol {
    func showMovieDetail(movieSelected: Movie)
}

class MovieCarousel: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var carouselActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleCarouselLabel: UILabel!
    @IBOutlet weak var movieCarouselCollectionView: UICollectionView!
    @IBOutlet weak var refreshView: UIView!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    // MARK: - Variables
    private var movies: [Movie] = []
    var delegate: MovieCarouselProtocol!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "MovieCarousel") else { return }
        view.frame = self.bounds
        movieCarouselCollectionView?.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCollectionViewCell")
        movieCarouselCollectionView?.delegate = self
        movieCarouselCollectionView?.dataSource = self
        self.addSubview(view)
    }
    
    func configureView(titleCarousel: String) {
        self.titleCarouselLabel.text = titleCarousel
    }
    
    func reloadCollectionView(movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.carouselActivityIndicator.stopAnimating()
            self.carouselActivityIndicator.isHidden = true
            self.movieCarouselCollectionView.reloadData()
        }
    }
}


extension MovieCarousel: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 135, height: 245)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate.showMovieDetail(movieSelected: movies[indexPath.item])
    }
}

extension MovieCarousel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCarouselCollectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        cell.movieImageView.imageFromMovieDB(urlString: movies[indexPath.item].posterPath, placeHolderImage: UIImage(named: "not_image")!)
        cell.movieTitleLabel.text = movies[indexPath.item].title
        cell.movieReleaseDateLabel.text = movies[indexPath.item].releaseDate.convertReleaseDate
        return cell
    }
}

extension MovieCarousel: UICollectionViewDelegateFlowLayout { }

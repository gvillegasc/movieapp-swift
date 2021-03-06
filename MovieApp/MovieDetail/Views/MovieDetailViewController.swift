//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 20/09/21.
//

import UIKit
import RxSwift
import SnackBar

class MovieDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var viewScrollView: UIScrollView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDateCategoryLabel: UILabel!
    @IBOutlet weak var movieVoteAverageLabel: UILabel!
    @IBOutlet weak var movieOverviewPaddingLabel: PaddingLabel!
    @IBOutlet weak var castTitlePaddingLabel: PaddingLabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var castActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoriteLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Variables
    var movieSelected: Movie!
    private var viewModel = MovieDetailViewModel()
    private var disposeBag = DisposeBag()
    private var movieDetail: MovieDetail?
    private var isFavorite = false

    // MARK: - Lifecycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        searchMovie()
        setupMovieSelected()
        hideNavigationBar()
        getMovieDetail()
    }
    
    // MARK: - Actions
    @objc private func backAction(_ sender: UITapGestureRecognizer) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
     }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        if isFavorite {
            viewModel.deleteMovie(movieId: movieSelected.id)
                .subscribe(on: MainScheduler.instance)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onNext: { isDeleted in
                        MovieStatusSnackBar.make(in: self.view, message: "Movie removes from favorites", duration: .lengthLong).show()
                        self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                        self.isFavorite = false
                    }
                ).disposed(by: disposeBag)
        } else {
            viewModel.insertMovie(movie: movieSelected!)
                .subscribe(on: MainScheduler.instance)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onNext: { isCreated in
                        MovieStatusSnackBar.make(in: self.view, message: "Movie saved in favorites", duration: .lengthLong).show()
                        self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                        self.isFavorite = true
                    }
                ).disposed(by: disposeBag)
        }

    }
    
    private func setupUI() {
        viewScrollView.contentInsetAdjustmentBehavior = .never
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.darkBackground.withAlphaComponent(0.3).cgColor, UIColor.darkBackground.withAlphaComponent(1).cgColor]
        backgroundGradientView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = backgroundGradientView.bounds
        let topPadding = UIApplication.topSafeAreaHeight
        backLayoutConstraint.constant = topPadding + 20
        favoriteLayoutConstraint.constant = topPadding + 20
        backView.layer.cornerRadius = backView.frame.size.width / 2
        backView.clipsToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.backAction(_:)))
        backView.addGestureRecognizer(gesture)
    }
    
    private func searchMovie() {
        return viewModel.searchMovie(movieId: movieSelected.id)
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { isFavorite in
                    self.isFavorite = isFavorite
                    if self.isFavorite {
                        self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    }
                }
            ).disposed(by: disposeBag)
    }
    
    private func setupMovieSelected() {
        if movieSelected.posterPath != nil {
            moviePosterImageView.imageFromMovieDB(urlString: movieSelected.posterPath!, placeHolderImage: UIImage(named: "not_image")!, highResolution: true)
        } else {
            moviePosterImageView.image = UIImage(named: "not_image")!
        }
        movieTitleLabel.text = movieSelected.title
        movieDateCategoryLabel.text = movieSelected.releaseDate.convertReleaseDate
        movieOverviewPaddingLabel.text = movieSelected.overview
        movieVoteAverageLabel.text = String(movieSelected.voteAverage)
        movieOverviewPaddingLabel.padding(15, 20, 15, 20)
        castTitlePaddingLabel.padding(0, 20, 5, 20)
        castCollectionView?.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "castCollectionViewCell")
        castCollectionView?.delegate = self
        castCollectionView?.dataSource = self
    }
    
    private func getMovieDetail() {
        return viewModel.getMovieDetail(movieId: movieSelected.id)
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { movieDetail in
                    self.castActivityIndicator.stopAnimating()
                    self.castActivityIndicator.isHidden = true
                    self.movieDetail = movieDetail
                    self.reloadCollectionView()
                },
                onError: { error in
                    print(error)
                }
            ).disposed(by: disposeBag)
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.castCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MovieDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieDetail?.cast.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: "castCollectionViewCell", for: indexPath) as! CastCollectionViewCell
        if movieDetail?.cast[indexPath.item].profilePath != nil {
            cell.actorImage.imageFromMovieDB(urlString: (movieDetail?.cast[indexPath.item].profilePath)!, placeHolderImage: UIImage(named: "not_image")!)
        } else {
            cell.actorImage.image = UIImage(named: "not_image")!
        }
        cell.actorName.text = movieDetail?.cast[indexPath.item].name
        cell.actorCharacter.text = movieDetail?.cast[indexPath.item].character
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout { }

private class MovieStatusSnackBar: SnackBar {
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = UIColor(red: 51.0/255, green: 51.0/255, blue: 50.0/255, alpha: 1.0)
        style.textColor = .white
        style.font = UIFont.systemFont(ofSize: 16)
        return style
    }
}

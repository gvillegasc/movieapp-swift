//
//  LocalDB.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 1/10/21.
//

import Foundation
import SQLite3
import RxSwift

class LocalDB {
    private var db: OpaquePointer?
    private var path = "movies.sqlite"

    static let shared = LocalDB()
    
    private init() {
        db = createDB()
        createTable()
    }
    
    private func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path)
        var db: OpaquePointer?
        
        if sqlite3_open(filePath.path, &db) == SQLITE_OK {
            return db
        }
        return nil
    }
    
    private func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS movies(id INTEGER PRIMARY KEY, title TEXT, popularity REAL, voteCount INT, originalTitle TEXT, voteAverage REAL, overview TEXT, releaseDate TEXT, posterPath TEXT)"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableString, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table create success")
            } else {
                print("Table creation fail")
            }
        } else {
            print("Prepration fail")
        }
    }
    
    private func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
          throw SQLiteError.Prepare(message: "errorMessage")
        }
        return statement
    }
    
    func insertMovie(movie: Movie) -> Observable<Bool> {
        return Observable.create { observer in
            let insertStatementString = "INSERT INTO movies(id, title, popularity, voteCount, originalTitle, voteAverage, overview, releaseDate, posterPath) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            var statement: OpaquePointer?
            var isCreated = false
            
            if sqlite3_prepare_v2(self.db, insertStatementString, -1, &statement, nil) == SQLITE_OK {
                let id = Int32(movie.id)
                let title = movie.title as NSString
                let popularity = movie.popularity
                let voteCount = Int32(movie.voteCount)
                let originalTitle = movie.originalTitle as NSString
                let voteAverage = movie.voteAverage
                let overview = movie.overview as NSString
                let releaseDate = movie.releaseDate as NSString?
                let posterPath = movie.posterPath as NSString?
                sqlite3_bind_int(statement, 1, id)
                sqlite3_bind_text(statement, 2, title.utf8String, -1, nil)
                sqlite3_bind_double(statement, 3, popularity)
                sqlite3_bind_int(statement, 4, voteCount)
                sqlite3_bind_text(statement, 5, originalTitle.utf8String, -1, nil)
                sqlite3_bind_double(statement, 6, voteAverage)
                sqlite3_bind_text(statement, 7, overview.utf8String, -1, nil)
                sqlite3_bind_text(statement, 8, releaseDate?.utf8String, -1, nil)
                sqlite3_bind_text(statement, 9, posterPath?.utf8String, -1, nil)
                if sqlite3_step(statement) == SQLITE_DONE {
                    isCreated = true
                    print("Successfully inserted row.")
                }
            }
            observer.onNext(isCreated)
            
            return Disposables.create {
                sqlite3_finalize(statement)
            }
        }
    }
    
    func deleteMovie(id: Int) -> Observable<Bool> {
        return Observable.create { observer in
            let statementString = "DELETE FROM movies WHERE id = ?"
            var statement: OpaquePointer?
            var isDeleted = false
            
            if sqlite3_prepare_v2(self.db, statementString, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(id))
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Successfully deleted row.")
                    isDeleted = true
                }
            }
            observer.onNext(isDeleted)
            
            return Disposables.create {
                sqlite3_finalize(statement)
            }
        }
    }
    
    func searchMovie(movieId: Int) -> Observable<Bool> {
        return Observable.create { observer in
            let statementString = "SELECT * FROM movies WHERE id = ?"
            var statement: OpaquePointer?
            var isFavorite = false
            
            if sqlite3_prepare_v2(self.db, statementString, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(movieId))
                if sqlite3_step(statement) == SQLITE_ROW {
                    isFavorite = true
                }
            }
            observer.onNext(isFavorite)
            
            return Disposables.create {
                sqlite3_finalize(statement)
            }
        }
    }
    
    func loadMovies() -> Observable<[Movie]> {
        return Observable.create { observer in
            let statementString = "SELECT * FROM movies"
            var statement: OpaquePointer?
            var favoriteMovies: [Movie] = []
            
            if sqlite3_prepare_v2(self.db, statementString, -1, &statement, nil) ==
                SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let movie = Movie(id: Int(sqlite3_column_int(statement, 0)), title: String(cString: sqlite3_column_text(statement, 1)), popularity: sqlite3_column_double(statement, 2), voteCount: Int(sqlite3_column_int(statement, 3)), originalTitle: String(cString: sqlite3_column_text(statement, 4)), voteAverage: sqlite3_column_double(statement, 5), overview: String(cString: sqlite3_column_text(statement, 6)), releaseDate: String(cString: sqlite3_column_text(statement, 7)), posterPath: String(cString: sqlite3_column_text(statement, 8)))
                    favoriteMovies.append(movie)
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(self.db))
                print("\nQuery is not prepared \(errorMessage)")
            }
            observer.onNext(favoriteMovies)
            
            return Disposables.create {
                sqlite3_finalize(statement)
            }
        }
    }
}

enum SQLiteError: Error {
  case OpenDatabase(message: String)
  case Prepare(message: String)
  case Step(message: String)
  case Bind(message: String)
}


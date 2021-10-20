//
//  DBHelper.swift
//  MovieApp
//
//  Created by Gerardo Villegas on 1/10/21.
//

import Foundation
import SQLite3

class DBHelper {
    var db: OpaquePointer?
    var path = "movies.sqlite"
//    private let dbPointer: OpaquePointer?

    
//    static let shared = DBHelper()
    
    init() {
        db = createDB()
        createTable()
//        self.dbPointer = dbPointer
    }
    

//    private init(dbPointer: OpaquePointer?) {
//      self.dbPointer = dbPointer
//    }
//
//    deinit {
//      sqlite3_close(dbPointer)
//    }
    
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
    
    func insertMovie(movie: Movie) {
        let insertStatementString = "INSERT INTO movies(id, title, popularity, voteCount, originalTitle, voteAverage, overview, releaseDate, posterPath) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &statement, nil) == SQLITE_OK {
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
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
        } else {
            print("\nINSERT statement is not prepared.")
        }
        sqlite3_finalize(statement)
    }
    
    func searchMovie(id: Int) -> Bool {
        print("====> \(id)")
        let id = Int32(id)
        let queryStatementString = "SELECT * FROM movies WHERE id = ?"
//        var statement: OpaquePointer?
        guard let statement = try? prepareStatement(sql: queryStatementString) else {
          return false
        }

        guard sqlite3_bind_int(statement, 1, id) == SQLITE_OK else {
          return false
        }
        guard sqlite3_step(statement) == SQLITE_ROW else {
          return false
        }
        let iNEW = sqlite3_column_int(statement, 0)
//        guard let queryResultCol0 = sqlite3_column_text(statement, 1) else {
//          print("Query result is nil.")
//          return false
//        }
        print(iNEW)
        sqlite3_finalize(statement)
        return true
    }
    
    private func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
          throw SQLiteError.Prepare(message: "errorMessage")
        }
        return statement
    }
    
    func getFavoriteMovies() -> [Movie] {
        let queryStatementString = "SELECT * FROM movies"
        var queryStatement: OpaquePointer?
        var favoriteMovies: [Movie] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let movie = Movie(id: Int(sqlite3_column_int(queryStatement, 0)), title: String(cString: sqlite3_column_text(queryStatement, 1)), popularity: sqlite3_column_double(queryStatement, 2), voteCount: Int(sqlite3_column_int(queryStatement, 3)), originalTitle: String(cString: sqlite3_column_text(queryStatement, 4)), voteAverage: sqlite3_column_double(queryStatement, 5), overview: String(cString: sqlite3_column_text(queryStatement, 6)), releaseDate: String(cString: sqlite3_column_text(queryStatement, 7)), posterPath: String(cString: sqlite3_column_text(queryStatement, 8)))
                    favoriteMovies.append(movie)
                }
                print(favoriteMovies.count)
                sqlite3_finalize(queryStatement)
                return favoriteMovies
            } else {
                print("\nQuery returned no results.")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return favoriteMovies
    }
}

enum SQLiteError: Error {
  case OpenDatabase(message: String)
  case Prepare(message: String)
  case Step(message: String)
  case Bind(message: String)
}

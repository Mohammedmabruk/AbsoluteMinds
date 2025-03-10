//
//  ViewController.swift
//  AbsoluteMinds
//
//  Created by Abdullah Bajaman on 21/11/2021.
//

import UIKit
import CoreData



class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
//    let api = Api()
    var library = Library()
    var books : [Source] = []
    var booksInfo : [BookInfo] = []

    
    var photos : [UIImage] = []
    var titles : [String] = []

    @IBOutlet weak var collectionView: UICollectionView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UINib(nibName: "BookCVCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
        getData()

        //loadBooks()

        collectionView.reloadData()
    }
   

    // function from protocol UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return books.count
    }
    // function from protocol UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // create nip with custom cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCVCell
        // avoid out of range
        if photos.indices.contains(0){
            cell.bookImage.image = photos[indexPath.row]
        }
//        print(photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    func getData() {
        
        let headers = [
            "x-rapidapi-host": "google-books.p.rapidapi.com",
            "x-rapidapi-key": "ef0d0f69cbmsh71b92f587dcbfbfp1a7701jsn5f5fae649978"
        ]
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "google-books.p.rapidapi.com"
        urlComponents.path = "/volumes"
        
        
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.allHTTPHeaderFields = headers
        
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: urlRequest as URLRequest) { (data: Data?, res: URLResponse?, err: Error?) in
            do {
                // After you get all the info from API
                    
                // Decode
                let jsonDecoder = JSONDecoder()
                let decodedRes = try jsonDecoder.decode(Library.self, from: data!)
                
                // Fill the local array / object
                self.books = decodedRes.items!
                
                // Reload the UI to show the new data fetched from API
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    print("Books loaded to view: \(self.books.count)")
                }
                for book in self.books {
                    if let bookImageString = book.volumeInfo.imageLinks?["thumbnail"] {
                        self.getBookImg(bookImage: bookImageString)
                    }
                }
            }catch {
                print("data not found \(error)")
            }
        }
        task.resume()
//    sleep(5)
    }
    
    func getBookImg(bookImage: String?) {
//                item.imageLinks?["thumbnail"]
//                guard let linkImage = bookImage  else { return }
        // to avoid forse unwrap
        if let bookImage = bookImage {
            // change scheme
            var bookImageURLComp = URLComponents(string: bookImage)
            bookImageURLComp?.scheme = "https"
            let urlImageSession = URLSession.shared
            
            let imageTask = urlImageSession.dataTask(with: (bookImageURLComp?.url)!) { (data: Data?, res: URLResponse?, err: Error?) in
                do {
                    let imageBook = UIImage(data: data!)
                    // assign it to array
                    self.photos.append(imageBook!)
                    // update ui to show one pic
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch {
                    print("data not found \(error)")
                }
            }
            imageTask.resume()
        }
                
                
                //        guard let imageUrl = imageLinks?["thumbnail"] else { return  }
                //        var urlImageRequest = URLRequest(url: URL(string: imageUrl)!)
                

                
//        sleep(10)
        }
}


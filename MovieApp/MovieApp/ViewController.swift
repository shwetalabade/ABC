//
//  ViewController.swift
//  MovieApp
//
//  Created by Mac on 30/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    let data:[Card] = []
    @IBOutlet weak var movieDataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       fetchdata()
       // self.movieDataTableView.dataSource = self
        //self.movieDataTableView.delegate = self
        self.movieDataTableView.register(UINib(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: "DataTableViewCell")
        
    }
func fetchdata()
    {
        let urlString = "https://task.auditflo.in/1.json"
        guard let url = URL(string: urlString)
        else{
            print("url is invalide")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request){data,response,error   in
            print("data received from url is \(data)")
            if let error = error{
                print("error received from url is\(error)")
            }
                else{
                    guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                         var data = data else{
                        print("status code is invalide")
                        return
                    }
                    do{
                        let jsonobject = try! JSONSerialization.jsonObject(with: data) as? [String:Any]
                        
                        if let data = jsonobject?["Movie List"] as? [Any] {
                            
                        for eachdictionary in data{
                            
                            let data = eachdictionary as! [String:Any]
                           let piMDBID = data["IMDBID"] as! String
                            let ptitle = data["Title"] as! String
                            let pyear = data["Year"] as! String
                            let pruntime = data["Runtime"] as! String
                            let pcast = data["Cast"] as! String

                            let newData = Card(IMBDID: piMDBID, Title: ptitle, year: pyear, runtime: pruntime, cast: pcast)
                            
                            print("id is\(piMDBID)\n\n title is\(ptitle)\n\n year is \(pyear)\n\n runtime is\(pruntime)\n\n cast is\(pcast)")
                            DispatchQueue.main.async {
                                self.movieDataTableView.reloadData()
                            }
                        }
                    }
                    } catch let myerror{
                        print("convert data into json\(myerror.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
}

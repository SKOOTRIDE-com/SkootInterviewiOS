//
//  ViewController.swift
//  SkootInterviewApp
//
//  Created by Summer Jones on 02/03/2021.
//

import UIKit

struct User: Codable {
    let id: String
    let firstName: String
}

struct UserData: Codable {
    let data: [User]
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var users: [User] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let url = URL(string: "https://dummyapi.io/data/api/user")!
        var request = URLRequest(url: url)
        request.setValue("603e78921e1a8f012a249693", forHTTPHeaderField: "app-id")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let users = try? JSONDecoder().decode(UserData.self, from: data)
            self.users = users?.data ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = users[indexPath.item].firstName
        return cell!
    }


}


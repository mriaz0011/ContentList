//
//  ContentListVC.swift
//  ContentList
//
//  Created by Muhammad Riaz on 15/09/2021.
//

import UIKit
import Network

class ContentListVC: UIViewController {
    
    @IBOutlet weak var clTblView: UITableView!
    
    private var listItems: [Items?] = []
    private let contentManager = ContentManager()
    
    //To Check Internet Connectivity
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        internetConnectionStatus()
        
        clTblView.dataSource = self
        clTblView.delegate = self
        contentManager.fetchContent() { [weak self] (result) in
            guard let this = self else { return }
            this.handleResult(result)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Content List"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func handleResult(_ result: Result<ContentListData, Error>) {
        switch result {
        case .success(let data):
            updateView(with: data)
        case .failure(let error):
            handleError(error)
            print(error)
        }
    }
    
    private func updateView(with data: ContentListData) {
        listItems = data.items
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.clTblView.reloadData()
        }
    }
    
    func internetConnectionStatus() {
        let alert = UIAlertController(title: "Internet Connection?", message: "There is no internet connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                print("Internet connection is on.")
            } else {
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }                
            }
        }
        monitor.start(queue: queue)
    }
    
    private func handleError(_ error: Error) {
        
        print(error.localizedDescription)
    }
}

extension ContentListVC: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listItems.isEmpty {
            return 1
        } else {
            return listItems.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = clTblView.dequeueReusableCell(withIdentifier: ContentListCell.reuseIdentifier, for: indexPath) as? ContentListCell {
            
            if listItems.isEmpty {
                cell.itemLbl.showAnimatedGradientSkeleton()
                cell.arrowImage.showAnimatedGradientSkeleton()
                return cell
            } else {
                cell.itemLbl.hideSkeleton()
                cell.arrowImage.hideSkeleton()
                cell.arrowImage.image = UIImage(named: "button_next_general")
            }
            guard let data = listItems[indexPath.row] else {
                return UITableViewCell()
            }
            let item = ContentListModel(item: data)
            cell.itemLbl.text = item.articleTitle
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if listItems.isEmpty {
            return
        }
        guard let data = listItems[indexPath.row] else {
            return
        }
        let item = ContentListModel(item: data)
        
        goToDetailVC(articleId: item.articleId)
    }
    
    private func goToDetailVC(articleId id: Int) {
        
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: ListDetailsVC.vcIdentifier) as! ListDetailsVC
        detailVC.mListId = id
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
}

    //
    //  CountryListTableViewController.swift
    //  CountryListExample
    //
    //  Created by Juan Pablo on 9/8/17.
    //  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
    //
    
    import UIKit
    
    public protocol CountryListDelegate: class {
        func selectedCountry(country: Country)
    }
    
    public class CountryList: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
        
        var tableView: UITableView!
        var searchController: UISearchController?
        var resultsController = UITableViewController()
        var filteredCountries = [Country]()
        
        open weak var delegate: CountryListDelegate?
        
        private var countryList: [Country] {
            let countries = Countries()
            let countryList = countries.countries
            return countryList
        }
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            
            self.view.backgroundColor = .white
            
            tableView = UITableView(frame: view.frame)
            tableView.register(CountryCell.self, forCellReuseIdentifier: "Cell")
            tableView.tableFooterView = UIView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.backgroundColor = UIColor.clear
            
            self.view.addSubview(tableView)
            
            setUpSearchBar()
        }
        
        public func updateSearchResults(for searchController: UISearchController) {
            
            filteredCountries.removeAll()
            
            let text = searchController.searchBar.text!.lowercased()
            
            for country in countryList {
                guard let name = country.name else { return }
                if name.lowercased().contains(text) {
                    
                    filteredCountries.append(country)
                }
            }
            
            tableView.reloadData()
        }
        
        func setUpSearchBar() {
            self.searchController = UISearchController(searchResultsController: nil)
            self.searchController?.hidesNavigationBarDuringPresentation = false
            self.searchController?.searchResultsUpdater = self
            self.searchController?.dimsBackgroundDuringPresentation = false
            self.searchController?.searchBar.placeholder = "Search"
            navigationItem.titleView = searchController?.searchBar
            
        }
        
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath) as! CountryCell
            let country = cell.country!
            
            self.searchController?.isActive = false
            self.delegate?.selectedCountry(country: country)
            
            tableView.deselectRow(at: indexPath, animated: true)
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if searchController!.isActive && searchController!.searchBar.text != "" {
                return filteredCountries.count
            }
            
            return countryList.count
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! CountryCell
            
            if searchController!.isActive && searchController!.searchBar.text != "" {
                cell.country = filteredCountries[indexPath.row]
                return cell
            }
            
            cell.country = countryList[indexPath.row]
            return cell
        }
    }

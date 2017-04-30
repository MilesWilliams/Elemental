//
//  ViewController.swift
//  Elemental
//
//  Created by MIles Work on 2017/04/30.
//  Copyright © 2017 StudioRepublika. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate {

    var rows : NSStackView!
    var selectedWebView : WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //1 - create the stackView and add it to our view
        rows = NSStackView()
        rows.orientation = .vertical
        rows.distribution = .fillEqually
        rows.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rows)
        
        //2 - create auto layout constraints that pin the stackView to the edges of its container
        rows.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        rows.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rows.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rows.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //3 - create an inital column that contains a single web view
        let column = NSStackView(views: [makeWebView()])
        column.distribution = .fillEqually
        
        //4 - add this column to the rows stack view
        rows.addArrangedSubview(column)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func urlEntered(_ sender: NSTextField){
    
    }
    
    @IBAction func navigationClicked(_ sender: NSSegmentedControl){
    
    }
    
    @IBAction func adjustRows(_ sender: NSSegmentedControl){
        
        // We're adding a new row
        if  sender.selectedSegment == 0 {
            
            // Count how many rows we have already
            let columnCount = (rows.arrangedSubviews[0] as! NSStackView).arrangedSubviews.count
            
            // Make a new array of web view that contain the correct amount of columns
            let viewArray = (0 ..< columnCount).map { _ in makeWebView() }
            
            // Use the web view to create a new stak view
            let row = NSStackView(views: viewArray)
            
            // Make the stack view size it children correctly and then add it to our rows array
            row.distribution = .fillEqually
            rows.addArrangedSubview(row)
            
        }else {
            
            // We're deleting rows
            
            // Make sure we have atleast 2 rows
            guard rows.arrangedSubviews.count > 1 else { return }
            
            // Pull out the final row and make sure its a stack view
            guard let rowToRemove = rows.arrangedSubviews.last as? NSStackView else { return }
            
            // Loop through each web view in the row, removing it from the screen
            for cell in rowToRemove.arrangedSubviews {
                
                cell.removeFromSuperview()
                
            }
            
            rows.removeArrangedSubview(rowToRemove)
            
        }
    }
    
    @IBAction func adjustCols(_ sender: NSSegmentedControl){
        
        if sender.selectedSegment == 0 {
            
            for case let row as NSStackView in rows.arrangedSubviews {
                // Loop through each row and add a new view to it
                row.addArrangedSubview(makeWebView())
            }
        }
        else {
            
            // We need to delete a column
            
            //pull out the first of the rows
            guard let  firstRow = self.rows.arrangedSubviews.first as? NSStackView else {return}
            
            guard firstRow.arrangedSubviews.count > 1 else { return }
            
            // If we are still here, means we are safe to delete a column
            for case let row as NSStackView in rows.arrangedSubviews {
                
                if let last = row.arrangedSubviews.last {
                    
                    // pull out the last web view in this column and remove it using 2 steps
                    row.removeArrangedSubview(last)
                    last.removeFromSuperview()
                    
                    
                }
            }
            
        }
    }
    
    func makeWebView() -> NSView{
        
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.wantsLayer = true
        webView.configuration.preferences.javaEnabled = true
//        webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        webView.load(URLRequest(url: URL(string: "https://www.apple.com")!))
        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(webViewClicked) )
        recognizer.numberOfClicksRequired = 1
        webView.addGestureRecognizer(recognizer)
        return webView
    }

    func selectView(webView: WKWebView) {
    
        selectedWebView = webView
        selectedWebView.layer?.borderWidth = 2
        selectedWebView.layer?.borderColor = NSColor.red.cgColor
        selectedWebView.layer?.opacity = 0.8
    
    }
    
    func webViewClicked(recognizer: NSClickGestureRecognizer) {
    
        // Get the web view that triggered this method
        guard let newSelectedWebView = recognizer.view as? WKWebView else {return}
        
        // Deselect the currently selectedweb viewif there is one
        if let selected = selectedWebView {
            selected.layer?.borderWidth = 0
            selected.layer?.opacity = 1.0
        }
        
        selectView(webView: newSelectedWebView)
    }
}


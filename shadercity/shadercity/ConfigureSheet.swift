import Cocoa

class ConfigureSheet: NSObject {
    
    weak var mainViewdelegate: MainView?
    
    let photoItemIdentifier: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "photoItemIdentifier")
    
    static var sharedInstance = ConfigureSheet()
    
    @IBOutlet weak var doneButton: NSButton!
    
    
    @IBOutlet weak var versionNumber: NSTextField!
    var shaders = [[ShaderInfo]]()
    var newShaders = [ShaderInfo]()
    let thumbnailSize = NSSize(width: 130.0, height: 130.0)
    
    var showSectionHeaders = false
    
    var previewURL: URL?
    
    var filenameLabel: NSTextField!

  @IBOutlet weak var collectionView: NSCollectionView!
  @IBOutlet var window: NSWindow!
  let settings = Settings()

    override init() {
        super.init()
        let bundle = Bundle(for: ConfigureSheet.self)
        bundle.loadNibNamed("ConfigureSheet", owner: self, topLevelObjects: nil)
        configureCollectionView()
        fetchShaders()
        
        versionNumber.stringValue = "Version: 0.0.2"

  }
    
    func parseShaders(data: Data) {
        
        self.newShaders = [ShaderInfo]()
        
               let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
               let itemObject = json as? [String : Any]
       
       
               if let dict = itemObject?["data"] as? [String : Any] {
       
                   if let dict2 = dict["listShaders"] as? [String : Any] {
       
                       if let dict3 = dict2["items"] as? [[String : Any]] {
       
                           for dict in dict3 {
                               guard
                                   let id = dict["id"] as? String,
                                   let imageURL = dict["imageURL"] as? String,
                                   let fileURL = dict["fileURL"] as? String,
                                   let ispublic = dict["ispublic"] as? Bool

       
       
                               else {
                                   print("Error parsing \(dict)")
                                   continue
                               }
                              
                            if (ispublic) {
                                let url = URL(string: "https://sdwr-shader-scapesstorage-dev.s3.eu-central-1.amazonaws.com/public/" + imageURL)
                                let shaderInfo = ShaderInfo(with: fileURL, thumbURL: url!)
                                self.newShaders.append(shaderInfo)
                            }

                           }
       
                       }
       
                   }
       
               }
        
            self.shaders.append(self.newShaders)
        
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.enclosingScrollView?.contentView.scroll(to: NSPoint(x: 0.0, y: 0.0))
            }
        


           }
           
    func fetchShaders() {
               
               /* Configure session, choose between:
                       * defaultSessionConfiguration
                       * ephemeralSessionConfiguration
                       * backgroundSessionConfigurationWithIdentifier:
                     And set session-wide properties, such as: HTTPAdditionalHeaders,
                     HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
                     */
                    let sessionConfig = URLSessionConfiguration.default

                    /* Create session, and optionally set a URLSessionDelegate. */
                    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

                    /* Create the Request:
                       Request (GET https://n7ekgxjxtnc7lhov366guzvyfa.appsync-api.eu-central-1.amazonaws.com/graphql)
                     */

                    guard var URL = URL(string: "https://n7ekgxjxtnc7lhov366guzvyfa.appsync-api.eu-central-1.amazonaws.com/graphql") else {return}
                    let URLParams = [
                        "query": "query ListShaders($filter: ModelShaderFilterInput, $limit: Int, $nextToken: String) {\n          listShaders(filter: $filter, limit: $limit, nextToken: $nextToken) {\n            __typename\n            items {\n              __typename\n              id\n              owner\n              createdAt\n              title\n              imageURL\n              fileURL\n              ispublic\n            }\n            nextToken\n          }\n        }",
                    ]
                    URL = URL.appendingQueryParameters(URLParams)
                    var request = URLRequest(url: URL)
                    request.httpMethod = "GET"

                    // Headers

                    request.addValue("application/graphql", forHTTPHeaderField: "content-type")
                    request.addValue("da2-jzmqkva6unhv5gsn547unluktm", forHTTPHeaderField: "x-api-key")

                    /* Start a new Task */
                    let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                        if (error == nil) {
                            // Success
                           self.parseShaders(data: data!)
                            let statusCode = (response as! HTTPURLResponse).statusCode
                            print("URL Session Task Succeeded: HTTP \(statusCode)")
                        }
                        else {
                            // Failure
                            print("URL Session Task Failed: %@", error!.localizedDescription);
                        }
                    })
                    task.resume()
                    session.finishTasksAndInvalidate()

               
           }
    
    func configureCollectionView() {
    
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.isSelectable = true
        collectionView.allowsEmptySelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.enclosingScrollView?.borderType = .noBorder
        let myBundle = Bundle(for: NSClassFromString(self.className)!)
        let nib = NSNib(nibNamed: "ShaderItem", bundle: myBundle)
        collectionView.register(nib, forItemWithIdentifier: photoItemIdentifier)
        
        configureFlowLayout()
        
    }
    
    func configureFlowLayout() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.sectionInset = NSEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        flowLayout.itemSize = NSSize(width: 200.0, height: 200.0)
        collectionView.collectionViewLayout = flowLayout
    }
    
    
    func configureGridLayout() {
        let gridLayout = NSCollectionViewGridLayout()
        gridLayout.minimumInteritemSpacing = 30.0
        gridLayout.minimumLineSpacing = 30.0
        gridLayout.maximumNumberOfColumns = 3
        gridLayout.maximumNumberOfRows = 2
        
        gridLayout.minimumItemSize = NSSize(width: 200.0, height: 200.0)
        gridLayout.maximumItemSize = NSSize(width: 200.0, height: 200.0)
        collectionView.collectionViewLayout = gridLayout
    }
    
    
    
    

  @IBAction func done(_ sender: NSButton) {
    guard let parent = window.sheetParent else {
      fatalError("Can't get configure sheet parent window")
    }
    parent.endSheet(window)
  }


}


extension ConfigureSheet: NSCollectionViewDataSource {


 func numberOfSections(in collectionView: NSCollectionView) -> Int {
     return shaders.count
 }

func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return shaders[section].count
 }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        guard let item = collectionView.makeItem(withIdentifier: photoItemIdentifier, for: indexPath) as? ShaderItem else { return NSCollectionViewItem() }
        
        item.imageView?.image = shaders[indexPath.section][indexPath.item].thumbnail
        
//        item.doubleClickActionHandler = { [weak self] in
//            self?.previewURL = self?.photos[indexPath.section][indexPath.item].url
//            self?.configureAndShowQuickLook()
//        }
        
        return item
    }
    
}


extension ConfigureSheet: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {


        guard let indexPath = indexPaths.first else { return }

        doneButton.isEnabled = true
        let shader = shaders[indexPath.section][indexPath.item]
        mainViewdelegate?.sheetDidSelectShader(shader: shader)

        
        
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 200.0, height: 200.0)
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        
        return showSectionHeaders ? NSSize(width: 0.0, height: 60.0) : .zero
    }
}


protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
    */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
    */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}


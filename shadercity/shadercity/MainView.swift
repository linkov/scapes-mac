import ScreenSaver
import WebKit


import AppCenter
import AppCenterCrashes



class MainView: ScreenSaverView {

    
    var webView: WKWebView?
    var sheet: ConfigureSheet?
    var image: NSImage?
    var selectedShader: ShaderInfo?
    var startedFromTestApp = false
    
  override func viewDidMoveToWindow() {
    wantsLayer = true
    animationTimeInterval = 1
    
    let configureSheet = ConfigureSheet.sharedInstance
    configureSheet.mainViewdelegate = self
    sheet = configureSheet

    
    loadFonts()
//    loadImage()

    animateOneFrame()
    
//    if startedFromTestApp { startAnimation() }
    
    MSAppCenter.start("89e07be7-7c9b-4811-88bb-283ca0bbaf5e", withServices:[
      MSCrashes.self
    ])
    
  }

  func loadFonts() {
    Fonts.load(fontName: Fonts.timeFont, extension: "ttf")
  }
  func loadImage() {
        DispatchQueue.global().async() {
            let url = NSURL(string: "https://raw.githubusercontent.com/yomajkel/ImageStream/added-swift-image/assets/swift.png")
            let data = NSData(contentsOf: url! as URL)
            if let data = data {
                self.image = NSImage(data: data as Data)
                
                DispatchQueue.main.async {

                self.needsDisplay = true
                    self.animateOneFrame()
                    
                }

            }
        }
    }
    
    func sheetDidSelectShader(shader: ShaderInfo) {
        selectedShader = shader
        Settings().lastSelectedShaderURL = selectedShader!.url!
        self.sheet?.window!.sheetParent!.endSheet(self.sheet!.window)
        
        startAnimation()
        
    }

  override func draw(_ rect: NSRect) {
    if let image = image {
    
        let point = CGPoint(x: (frame.size.width - image.size.width) / 2, y: (frame.size.height - image.size.height) / 2)
            image.draw(at: point, from: NSZeroRect, operation: .saturation, fraction: 1)
    }
    
    }

  override func animateOneFrame() {

    

    setNeedsDisplay(bounds)
  }
    
    override var hasConfigureSheet: Bool {
        return true
    }

//  override func hasConfigureSheet() -> Bool {
//    return true
//  }
    
    override var configureSheet: NSWindow? {
        get {

            return sheet!.window
        }
    }
    
    
    
//    
//    // entry point for when we are started within our own test-app
//    required init?(coder: NSCoder) {
//      super.init(coder: coder)
////      startedFromTestApp = true
//    }
//    
    
    
    
    //

    override func startAnimation() {
        super.startAnimation()

        if (Settings().lastSelectedShaderURL == "") {
            return
        }

      createWebView()
      if let webView = webView {
        webView.wantsLayer = true
        webView.layer?.backgroundColor = NSColor.clear.cgColor
        webView.autoresizingMask = [NSView.AutoresizingMask.width, NSView.AutoresizingMask.height]
        webView.autoresizesSubviews = true

        addSubview(webView)


      }

    }
    
    
    
    fileprivate func createWebView() {
     
      webView = WKWebView(frame: self.bounds)
    let lastURL = Settings().lastSelectedShaderURL
    var token = lastURL.components(separatedBy: ".")
      if let webView = webView {
        let link = URL(string:"https://master.d8f577j2tq0dz.amplifyapp.com/shaderpresentation/\(token[0] )")!
        let request = URLRequest(url: link)
        webView.load(request)
      }
    }
    
    
    override func stopAnimation() {
      super.stopAnimation()
      if let webView = webView {
        webView.removeFromSuperview()
//        webView.close()
      }
      webView = nil
    }
    
    
    

}

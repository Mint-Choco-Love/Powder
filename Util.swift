import Foundation

struct Util {
    static func getImgURLs(_ str: String) -> [String] {
        var ret = [String]()
        
        func dfs(_ cur: XMLElement) {
            if let id = cur.attribute(forName: "id")?.stringValue, let src = cur.attribute(forName: "src")?.stringValue {
                if id.lowercased() == "pdf" {
                    print(src)
                    ret.append(src)
                }
            }
            if let nxts = cur.children {
                for nxt in nxts {
                    if let nxt = nxt as? XMLElement {
                        dfs(nxt)
                    }
                }
            }
        }
        guard let xml = try? XMLDocument(xmlString: str, options: .documentTidyHTML) else {
            return ret
        }
        
        if let root = xml.rootElement() {
            dfs(root)
        } else {
            print("root in nil.")
        }

        return ret
    }
    
    static func saveImage(location: URL, fileName: String? = nil) {
        do {
            let documentsURL = try FileManager.default.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let savedURL = documentsURL.appendingPathComponent(fileName ?? location.lastPathComponent)
            try FileManager.default.moveItem(at: location, to: savedURL)
            
            print("saved as", savedURL, "\n")
        } catch {
            print(error)
        }
    }
}



extension URLSessionTask {
    struct Holder {
        static let _sema = DispatchSemaphore(value: 0)
    }
    
    var sema: DispatchSemaphore {
        get {
            return Holder._sema
        }
    }
}

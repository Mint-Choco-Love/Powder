import Foundation

class Crawler: NSObject {
    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    private var htmlData = Data()
    
    override init() {
        super.init()
    }
    
    func getHTML(url: String) -> String? {
        guard let url = URL(string: url) else {
            return nil
        }
        let task = self.session.dataTask(with: url)
        task.resume()
        let _ = task.sema.wait(timeout: .now() + 5)
        
        let ret = String(bytes: self.htmlData, encoding: .utf8)
        return ret
    }
    
    private func invalidate() {
        self.session.finishTasksAndInvalidate()
        print("session invalidated.")
    }
}

extension Crawler: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.htmlData.append(data)
        print("html:", data)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let res = response as? HTTPURLResponse else {
            completionHandler(.cancel)
            invalidate()
            return
        }

        if (200...299).contains(res.statusCode) == false {
            completionHandler(.cancel)
            invalidate()
            return
        }
        completionHandler(.allow)
    }
}

extension Crawler: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print(error)
        }
        invalidate()
        task.sema.signal()
    }
}

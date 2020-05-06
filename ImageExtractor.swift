import Foundation

class ImageExtractor: NSObject {
    lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    
    override init() {
        super.init()
    }
    
    private func invalidate() {
        self.session.finishTasksAndInvalidate()
        print("session invalidated.")
    }
    
    func extract(urls: [String]) {
        for url in urls {
            guard let url = URL(string: url) else { continue }
            let task = session.downloadTask(with: url)
            task.resume()
            let _ = task.sema.wait(timeout: .now() + 5)
        }
        
        invalidate()
    }
}

// write file
extension ImageExtractor: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(location.lastPathComponent, "(+)", downloadTask.countOfBytesReceived, "bytes")
        Util.saveImage(location: location, fileName: downloadTask.originalRequest?.url?.lastPathComponent)
    }
}

// complete or error
extension ImageExtractor: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print(error)
        }
        task.sema.signal()
    }
}

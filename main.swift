import Foundation

//let test = "https://developer.apple.com/documentation/coredata"
let test = readLine() ?? ""
let htmlString = Crawler().getHTML(url: test)
let temp = Util.getImgURLs(htmlString ?? "")
ImageExtractor().extract(urls: temp)

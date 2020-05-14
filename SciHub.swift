
struct SciHub {
    static func doi(url: String) {
        // let test = "https://sci-hub.tw/10.1145/253769.253798"
        let doiURL = "https://sci-hub.tw/" + url
        let htmlString = Crawler().getHTML(url: doiURL)
        let tags = Util.getImgURLs(htmlString ?? "")
        ImageExtractor().extract(urls: tags)
    }
}




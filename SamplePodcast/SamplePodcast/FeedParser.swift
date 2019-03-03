//
//  FeedParser.swift
//
//  Created by Nacho on 28/9/14.
//  Copyright (c) 2014 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit


let kReadyRSS2ChannelName = "channel"




enum FeedType: String {
    case Unknown = "unknown", RSS2 = "rss"
    
    func feedsDateFormat() -> DateFormat? {
        switch self {
        
        case .RSS2:
            return .rfc822
        default:
            return .rfc822
        }
    }
}

enum ParsingType {
    case full, itemsOnly, channelOnly
}

enum ParsingStatus {
    case stopped, parsing, succeed, aborted, failed;
}



/** The feed parser parses a feed URL and communicates the results to its delegate */
class FeedParser: NSObject, XMLParserDelegate {
    // parsing delegate
    var delegate: FeedParserDelegate?
    
    // Parser properties
    var feedType: FeedType! = .Unknown
    var parsingType: ParsingType
    var parsingStatus: ParsingStatus
    var feedURL: String
    var feedLogoURL: String?
    var feedRawContents: Data?
    var feedEncoding = String.Encoding.utf8
    var feedParser: XMLParser?
    var feedItemsParsed = 0

    
    // Temporal parsing values
    var currentPath: String = "/"
    var currentElementIdentifier: String!
    var currentElementAttributes: [AnyHashable: Any]!
    var currentElementContent: String!
    var currentFeedChannel: FeedChannel!
    var currentFeedItem: FeedItem!
    
    init(feedURL: String) {
        self.feedURL = feedURL
        self.parsingType = .full
        self.parsingStatus = .stopped
    }
    
    convenience init(feedURL: String, feedRawContents: Data) {
        self.init(feedURL: feedURL)
        self.feedRawContents = feedRawContents
    }
    
    
 
    
    // MARK: - Parsing methods
    
    /** Resets the parser status, aborting any parsing process */
    func reset() {
        if (parsingStatus == .parsing) {
            feedParser?.abortParsing()
        }
        parsingStatus = .stopped
        currentElementIdentifier = nil
        currentElementAttributes = nil
        currentElementContent = nil
        currentFeedChannel = nil
        currentFeedItem = nil
        currentPath = "/"
        parsingType = .full
        feedEncoding = String.Encoding.utf8
        feedType = .Unknown
        feedItemsParsed = 0
    }
    
    /** Starts the parsing process, requesting the feed URL content and parsing it with the NSXMLParser */
    func parse() {
        if (parsingStatus == .parsing) {
            delegate?.feedParser?(self, parsingFailedReason: NSLocalizedString("another_parsing_in_process", comment: ""))
            return
        }
        self.reset()
        
        // Request the feed and start parsing.
        
        if (feedRawContents != nil) { // already downloaded content?
            feedParser = XMLParser(data: feedRawContents!)
        } else { // retrieve content and start parsing.
            feedParser = XMLParser(contentsOf: URL(string: feedURL)!)
        }
        if (feedParser != nil) { // content successfully retrieved
            self.parsingStatus = .parsing
            self.feedParser!.shouldProcessNamespaces = true
            self.feedParser!.shouldResolveExternalEntities = false
            self.feedParser!.delegate = self
            self.feedParser!.parse()
        } else { // unable to retrieve content
            self.parsingStatus = .failed
            self.delegate?.feedParser?(self, parsingFailedReason: NSString(format: "%@: %@", NSLocalizedString("unable_retrieve_feed_contents",comment: ""), self.feedURL) as String)
        }
        
    }
    
    func abortParsing() {
        if (parsingStatus == .parsing) {
            feedParser?.abortParsing()
        }
        parsingStatus = .aborted
        delegate?.feedParserParsingAborted?(self)
    }
    
    // MARK: - NSXMLParser methods
    
    // MARK: -- Element start
    
    /** Did start element. */
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        autoreleasepool {
            
            
            
            self.currentPath = URL(fileURLWithPath: self.currentPath).appendingPathComponent(qName!).path
            self.currentElementIdentifier = elementName
            self.currentElementAttributes = attributeDict
            self.currentElementContent = ""
            
            
            
            // Determine the type of feed.
            if elementName == FeedType.RSS2.rawValue { self.feedType = .RSS2; return }
            
            // parse depending on feed type
            if (self.feedType == .RSS2) { self.parseStartOfRSS2Element(elementName, attributes: attributeDict) }
        }
    }
    
    
    
    func parseStartOfRSS2Element(_ elementName: String, attributes attributeDict: [String: Any]!) {
        // start of atom feed channel
        if self.currentPath == "/rss/channel" {
            initializeNewFeedChannel(attributeDict)
            return
        }
        
        // start of atom feed item
        if self.currentPath == "/rss/channel/item" {
            initializeNewFeedItem()
        }
    }
    
    
    
    func initializeNewFeedChannel(_ attributeDict: [String: Any]!) {
        self.currentFeedChannel = FeedChannel()
        self.currentFeedChannel.channelURL = self.feedURL
        
    }
    
    func initializeNewFeedItem() {
        // if we are looking just for the channel information, stop the parser right away.
        if (self.parsingType == .channelOnly) { // do we have a valid channel?
            if self.currentFeedChannel?.isValid == true { self.successfullyCloseParsingAndReturnJustChannel(self.currentFeedChannel) }
            else {
                self.abortParsingAndReportFailure("Failed to find a valid feed channel.")
            }
            self.currentFeedChannel = nil
            return
        } else { // process items.
            // when we find the first item we can store the previously found channel information:
            if (self.currentFeedChannel != nil) {
                if (self.currentFeedChannel?.isValid == true) {
                    self.delegate?.feedParser?(self, didParseChannel: self.currentFeedChannel)
                }
                self.currentFeedChannel = nil
            }
            // set current feed item
            self.currentFeedItem = FeedItem()
            self.currentFeedItem.feedSource = self.currentFeedChannel?.channelTitle ?? self.feedURL
            return
        }
    }

    // MARK: -- Element end
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        autoreleasepool {
            // parse depending on feed type
            

            
            if self.feedType == .RSS2 { self.parseEndOfRSS2Element(elementName, qualifiedName: qName) }
        }
    }
    
    
    func parseEndOfRSS2Element(_ elementName: String, qualifiedName qName: String!) {
        // item
        if self.currentPath == "/rss/channel/item" {
            if (self.currentFeedItem?.isValid == true) {
                self.delegate?.feedParser?(self, didParseItem: self.currentFeedItem)
            }
            self.currentFeedItem = nil

            
        }
        
        // url
        else if self.currentPath == "/rss/channel/image/url" {
            self.currentFeedChannel?.channelLogoURL = self.currentElementContent
            
        }
 
        // title
        else if self.currentPath == "/rss/channel/title" {
            self.currentFeedChannel?.channelTitle = self.currentElementContent
            
            
        }
        else if self.currentPath == "/rss/channel/item/title" {
            self.currentFeedItem?.feedTitle = self.currentElementContent
        }
            
        // link
        else if self.currentPath == "/rss/channel/link" {
            self.currentFeedChannel?.channelLink = self.currentElementContent
            
        }
        else if self.currentPath == "/rss/channel/item/link" {
            self.currentFeedItem?.feedLink = self.currentElementContent
        }
            
        // description -- content
        else if self.currentPath == "/rss/channel/description" {
            self.currentFeedChannel?.channelDescription = self.currentElementContent
            
        }
        else if self.currentPath == "/rss/channel/item/description" {
            
            self.currentFeedItem?.feedContent = self.currentElementContent.stringByDecodingHTMLEntities()
        }
        
        else if self.currentPath == "/rss/channel/item/pubDate" {
            self.currentFeedItem?.feedPubDate = self.retrieveDateFromDateString(self.currentElementContent, feedType: self.feedType)
        }
            
        // language (channels only)
        else if self.currentPath == "/rss/channel/language" {
            self.currentFeedChannel?.channelLanguage = self.currentElementContent
        }
            
        // comments
        else if self.currentPath == "/rss/channel/item/comments" {
            self.currentFeedItem?.feedCommentsURL = self.currentElementContent
        }
        
        // enclosures (RSS items only)
        else if self.currentPath == "/rss/channel/item/enclosure" {
            let type:String? = self.currentElementAttributes?["type"] as? String
            let content: String? = self.currentElementAttributes?["url"] as? String
            let length:Int? = Int((self.currentElementAttributes?["length"] as? String)!)
            if content != nil && type != nil && length != nil {
                let feedEnclosure = FeedEnclosure(url: content!, type: type!, length: length!)
                self.currentFeedItem?.feedEnclosures.append(feedEnclosure)
            }
        }
            
        // category
        else if self.currentPath == "/rss/channel/category" {
            self.currentFeedChannel?.channelCategory = self.currentElementContent
        }
        else if self.currentPath == "/rss/channel/item/category" {
            self.currentFeedItem?.feedCategories.append(self.currentElementContent)
        }
            
        // author (feeds only)
        else if self.currentPath == "/rss/channel/item/author" || self.currentPath == "/rss/channel/item/dc:creator" {
            self.currentFeedItem?.feedAuthor = self.currentElementContent
        }
            
        // GUID / Identifier
        else if self.currentPath == "/rss/channel/item/guid" {
            self.currentFeedItem?.feedIdentifier = self.currentElementContent
        }
        
        // clear elements
        self.currentElementAttributes = nil
        self.currentElementIdentifier = nil
        self.currentElementContent = nil
        
        self.currentPath = (NSURL(fileURLWithPath: self.currentPath).deletingLastPathComponent?.path)!
    }
    
    
    
    // MARK: - Characters and CDATA blocks, other parsing methods
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        var string: String? = String(data: CDATABlock, encoding: String.Encoding.utf8)
        if (string == nil) { string = String (data: CDATABlock, encoding: String.Encoding.isoLatin1) }
        if (string == nil) { string = "" }
        
        self.currentElementContent = self.currentElementContent != nil ? self.currentElementContent + string! : string!
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentElementContent = self.currentElementContent != nil ? self.currentElementContent + string : string
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        self.delegate?.feedParser?(self, successfullyParsedURL: feedURL)
    }
    
    // MARK: - Utility methods
    
    
    
    func retrieveDateFromDateString(_ dateString: String, feedType: FeedType?) -> Date {
        // extract date object from string
        let currentDateFormat: DateFormat? = feedType?.feedsDateFormat()
        var currentDate: Date! = Date(fromString: dateString, format: currentDateFormat ?? .rfc822)
        // if we were unable to extract a proper date, try with other possible formats and fallback to current date.
        if currentDate == nil { currentDate = Date(fromString: dateString, format: .incompleteRFC822) }
        if currentDate == nil { currentDate = Date(fromString: dateString, format: .iso8601) }
        if currentDate == nil { currentDate = Date() }
        
        return currentDate
    }
    
    func successfullyCloseParsingAndReturnJustChannel(_ feedChannel: FeedChannel) -> Void {
        feedParser?.abortParsing()
        delegate?.feedParser?(self, didParseChannel: feedChannel)
        parsingStatus = .succeed
        delegate?.feedParser?(self, successfullyParsedURL: feedURL)
    }
    
    func successfullyCloseParsingAfterMaxItemsFound() -> Void {
        feedParser?.abortParsing()
        parsingStatus = .succeed
        delegate?.feedParser?(self, successfullyParsedURL: feedURL)
    }
    
    func abortParsingAndReportFailure(_ reason: String) {
        feedParser?.abortParsing()
        parsingStatus = .failed
        delegate?.feedParser?(self, parsingFailedReason: reason)
    }
    
    func encodingTypeFromString(_ textEncodingName: String?) -> String.Encoding? {
        if textEncodingName == nil { return nil; }
        
        let cfEncoding: CFStringEncoding = CFStringConvertIANACharSetNameToEncoding(textEncodingName! as NSString as CFString)
        if cfEncoding != kCFStringEncodingInvalidId { return String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(cfEncoding)); }
        else { return nil; }
    }
    
}

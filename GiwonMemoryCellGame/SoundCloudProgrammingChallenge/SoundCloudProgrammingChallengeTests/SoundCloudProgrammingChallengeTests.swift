//
//  SoundCloudProgrammingChallengeTests.swift
//  SoundCloudProgrammingChallengeTests
//

import XCTest
@testable import SoundCloudProgrammingChallenge

class SoundCloudProgrammingChallengeTests: XCTestCase {
    
    var client: ImageSourceClient!
    
    func testDownloadingArtWorkAndDistribution() {
        
        // see if fetching/parsing json works
        let mockSession = URLSessionMock(jsonDict: ["tracks":
            [["artwork_url": "https://i1.sndcdn.com/artworks-000082605199-ww02qv-large.jpg"],
             ["artwork_url": "https://i1.sndcdn.com/artworks-000067900006-cedza2-large.jpg"],
             ["artwork_url": "https://i1.sndcdn.com/artworks-000088814272-vfbodd-large.jpg"],
             ["artwork_url": "https://i1.sndcdn.com/artworks-000082611384-u1ifp4-large.jpg"],
             ["artwork_url": "https://i1.sndcdn.com/artworks-000020206888-ed7wyp-large.jpg"],
             ["artwork_url": "https://i1.sndcdn.com/artworks-000095495908-x73bfk-large.jpg"],
             ["artwork_url": "https://i1.sndcdn.com/artworks-000033001081-7jion0-large.jpg"],
            ["artwork_url": "https://i1.sndcdn.com/artworks-000088794783-66sail-large.jpg"]]
            ])!
        
        client = ImageSourceClient(session: mockSession)
        
        
        
        let responseExpectation = expectation(description: "APICall")
        client.fetchImageSource({error in
        
            responseExpectation.fulfill()
            XCTAssertNil(error)
        })
        
        waitForExpectations(timeout: 5, handler:nil)
        
        
        // see if the number of artworks amount to half of 16 cells
        let numberOfCells = 16
        XCTAssertNotNil(client.artWorks)
        XCTAssertEqual(client.artWorks?.count, numberOfCells/2)
        
        // see if each artwork is unique
        for artWork in client.artWorks! {
            let equivalentImages = client.artWorks?.filter({$0 == artWork})
            XCTAssertEqual(equivalentImages?.count, 1)
        }
        
        // see if artwork distribution reference array works
        let randomNumberArray = client.getUniqueRandomNumbers(ofSize: numberOfCells)
        XCTAssertEqual(randomNumberArray.count, numberOfCells)
        
        let maxIndexNum = randomNumberArray.reduce(randomNumberArray[0], { $0 > $1 ? $0 : $1 })
        let minIndexNum = randomNumberArray.reduce(randomNumberArray[0], { $0 < $1 ? $0 : $1 })
        
        XCTAssertEqual(minIndexNum, 0)
        XCTAssertEqual(maxIndexNum, numberOfCells-1)
        
        let ranNumArrayForDistribution = randomNumberArray.map {$0 % numberOfCells/2}
        
        // see if it is made of a pair of unique numbers ranging from 0 to half of numberOfCells
        for number in ranNumArrayForDistribution {
            let sameNumberCount = ranNumArrayForDistribution.filter({$0 == number})
            XCTAssertEqual(sameNumberCount.count, 2)
        }
        
    }
    
    
    func testMemoryCellViewEquivalence() {
        
        // see if a pair matching works
        let cellView1 = MemoryCellView()
        let cellView2 = MemoryCellView()
        let cellView3 = MemoryCellView()
        
        guard let imgData1 = try? Data(contentsOf: URL(string: "https://i1.sndcdn.com/artworks-000082605199-ww02qv-large.jpg")!),
            let img1 = UIImage(data: imgData1)
        else { fatalError() }
        
        let img2 = img1
        
        guard let imgData3 = try? Data(contentsOf: URL(string: "https://i1.sndcdn.com/artworks-000067900006-cedza2-large.jpg")!),
            let img3 = UIImage(data: imgData3)
            else { fatalError() }
        
        cellView1.image = img1
        cellView2.image = img2
        cellView3.image = img3
        
        XCTAssertTrue(cellView1 == cellView2)
        XCTAssertFalse(cellView2 == cellView3)
        
        
    }
    
    func testMemoryCellStateShift() {
        
        // see if memory cell's state changes as it is intended to do.
        let cellView = MemoryCellView()
        cellView.memoryCellState = .FaceDown
        
        cellView.flip()
        XCTAssertEqual(cellView.memoryCellState, .FaceUp)
        
        cellView.flip()
        XCTAssertEqual(cellView.memoryCellState, .FaceDown)
        
        // if it is in hold state, flip() doesn't change anything.
        cellView.hold()
        cellView.flip()
        XCTAssertEqual(cellView.memoryCellState, .Hold)
        
        cellView.undoHold()
        XCTAssertEqual(cellView.memoryCellState, .FaceDown)
        
        // see if the memory cell negates the user gesture if the delegate function says not to do so
        let memoryCellViewController = MemoryCellViewController()
        cellView.delegate = memoryCellViewController
        
        memoryCellViewController.memoryCellInteractionState = .NotReady
        cellView.tapRecognizer(UITapGestureRecognizer())
        XCTAssertEqual(cellView.memoryCellState, .FaceDown)
        
        // see if the memory cell state shifts from FaceDown to FaceUp and shortly to Hold since the memory cell has to stay face-up for a while for pair matching
        memoryCellViewController.memoryCellInteractionState = .Ready
        cellView.tapRecognizer(UITapGestureRecognizer())
        XCTAssertEqual(cellView.memoryCellState, .Hold)
        
           
    }
}

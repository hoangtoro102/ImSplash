//
//  DownloadManage.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/21/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
protocol DownloadManagerDelegate {
    func progressIsChanged(progress: Float, id: String)
    func didUpdateLocal(destinationURL: String, id: String, width: Int, height: Int)
}
class DownloadManager: NSObject {
    //
    // MARK: - Constants
    //
    
    /// Get local file path: download task stores tune here; AV player plays it.
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    //
    // MARK: - Variables And Properties
    //
    var activeDownloads: [URL: DownloadRequest] = [ : ]
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.ImSplash.bgSession")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    var delegate: DownloadManagerDelegate?
    
    //
    // MARK: - Internal Methods
    //
    func cancelDownload(_ photo: UnsplashPhoto) {
        guard let url = photo.urls[.raw], let download = activeDownloads[url] else {
            return
        }
        download.task?.cancel()

        activeDownloads[url] = nil
    }
    
    func pauseDownload(_ photo: UnsplashPhoto) {
        guard let url = photo.urls[.raw],  let download = activeDownloads[url],
        download.isDownloading
        else {
          return
        }

        download.task?.cancel(byProducingResumeData: { data in
        download.resumeData = data
        })

        download.isDownloading = false
    }
    
    func resumeDownload(_ photo: UnsplashPhoto) {
        guard let url = photo.urls[.raw], let download = activeDownloads[url] else {
            return
        }

        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadsSession.downloadTask(with: url)
        }

        download.task?.resume()
        download.isDownloading = true
    }
    
    func startDownload(_ photo: UnsplashPhoto) {
        print("Prepare download")
        guard let url = photo.urls[.raw] else {
            return
        }
        // 0
        if activeDownloads[url] != nil {
            return
        }
        print("Start download url: \(url)")
        // 1
        let download = DownloadRequest(photo: photo)
        // 2
        download.task = downloadsSession.downloadTask(with: url)
        // 3
        download.task?.resume()
        // 4
        download.isDownloading = true
        // 5
        activeDownloads[url] = download
    }
    
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent).appendingPathExtension("PNG")
    }
}

//
// MARK: - URL Session Download Delegate
//
extension DownloadManager: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                  didFinishDownloadingTo location: URL) {
    // 1
    guard let sourceURL = downloadTask.originalRequest?.url else {
      return
    }
    
    let download = activeDownloads[sourceURL]
    activeDownloads[sourceURL] = nil
    
    // 2
    let destinationURL = localFilePath(for: sourceURL)
    print("Destination URL: \(destinationURL)")
    
    // 3
    let fileManager = FileManager.default
    try? fileManager.removeItem(at: destinationURL)
    
    do {
      try fileManager.copyItem(at: location, to: destinationURL)
//      download?.track.downloaded = true
    } catch let error {
      print("Could not copy file to disk: \(error.localizedDescription)")
    }
    if let photo = download?.photo {
        delegate?.didUpdateLocal(destinationURL: destinationURL.absoluteString, id: photo.identifier, width: photo.width, height: photo.height)
    }
    // 4
//    if let index = download?.track.index {
//      DispatchQueue.main.async { [weak self] in
//        self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
//      }
//    }
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                  didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                  totalBytesExpectedToWrite: Int64) {
    // 1
    guard
      let url = downloadTask.originalRequest?.url,
      let download = activeDownloads[url]  else {
        return
    }
    
    // 2
    let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    download.progress = progress
    print("Session didWriteData, progress: \(progress)")
    delegate?.progressIsChanged(progress: progress, id: download.photo.identifier)
    // 3
//    let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
    
    // 4
//    DispatchQueue.main.async {
//    }
  }
}

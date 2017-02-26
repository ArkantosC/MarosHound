// MIT License
//
// Copyright (c) 2017 Diego Cortes
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

public final class HoundAdapter
{
    private var process: Bool
    private var results: [Int: [Int:String]]
    private var model: ModelHound
    private var globalCount: Int
    private var fileNames: [Int:String]
    private var filePaths: [Int:String]
    
    init (model: ModelHound)
    {
        self.model = model;
        self.process = true
        self.results = [:]
        self.globalCount = 0
        self.fileNames = [:]
        self.filePaths = [:]
    }
    
    func start()
    {
        let fileManager = FileManager.default
        
        let enumeratorFiles = fileManager.enumerator(atPath: model.folder)
        var files: [Int:FileHandle]  = [:]
        
        if (enumeratorFiles != nil)
        {
            var countQueue: Int = 0;
            while let elementFile = enumeratorFiles?.nextObject() as? String
            {
                let elementFileString: String = model.folder + "/" + elementFile
                let file = FileHandle(forReadingAtPath: elementFileString)
                
                if (file == nil)
                {
                    print("file open failed")
                }
                else
                {
                    files[countQueue] = file
                    fileNames[countQueue] = elementFile
                    filePaths[countQueue] = elementFileString
                    countQueue = countQueue + 1
                }
            }
        }

        if (files.count > 0)
        {
            for i in 0..<files.count
            {
                doProcess(file: files[i]!)
            }
        }
        
    }
    
    func doProcess(file: FileHandle)
    {
        let queue = DispatchQueue(label: "com.odreria.marosHound", qos: DispatchQoS.utility)
        
        queue.sync
        {
            let process = Process(file: file, keyWord: model.containingText)
            let chunk: [Int: String] = process.start()
            self.results[globalCount] = chunk
            globalCount = globalCount + 1
        }
    }
    
    func result() -> [Int: [Int:String]]
    {
        return self.results
    }
    
    func stop()
    {
        process = false
        print ("stopping...")
    }
    
}

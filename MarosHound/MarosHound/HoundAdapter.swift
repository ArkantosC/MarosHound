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
    private var process: Bool = false
    private var results: [Int: String] = [0: ""]
    
    func start(model: ModelHound)
    {
        let fileManager = FileManager.default
        
        let enumeratorFiles = fileManager.enumerator(atPath: model.folder)
    
        if (enumeratorFiles != nil)
        {
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
                    process = true
                    print ("Searching...")
                    let queue =
                        DispatchQueue(
                            label: "com.odreria.marosHound",
                            qos: DispatchQoS.utility)
            
                    queue.sync
                    {
                        let process = Process(file: file!, keyWord: model.containingText)
                        self.results = process.start()
                    }
                }
            }
        }
    }
    
    func result() -> [Int: String]
    {
        return self.results
    }
    
    func stop()
    {
        process = false
        print ("stopping...")
    }
    
}

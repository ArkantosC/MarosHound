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

public class Process
{
    private let file : FileHandle
    private let keyWord : String
    
    init(file : FileHandle, keyWord: String)
    {
        self.file = file
        self.keyWord = keyWord
    }
    
    func start() -> [Int: String]
    {
        var result : [Int: String] = [:]
        
        file.seek(toFileOffset: 0)
        let dataBuffer = file.readDataToEndOfFile()
        let str = String.init(data: dataBuffer, encoding: .utf8)
        file.closeFile()
        
        let exist = str?.lowercased().contains(keyWord)
        
        var lineNumber : Int = 0
        if (exist != nil)
        {
            let findings : [String] = (str?.components(separatedBy: "\n"))!
            
            for value in findings
            {
                lineNumber += 1
                if (value.lowercased().contains(keyWord))
                {
                    result[lineNumber] = value
                }
            }
        }
        return result
    }
}

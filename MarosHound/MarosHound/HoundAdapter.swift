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
    var process: Bool = false
    
    func start(model: ModelHound)
    {
        let file = FileHandle(forReadingAtPath: "/Users/diegocortes/soapui-settings.xml")
        
        if (file == nil)
        {
            print("file open failed")
        }
        else
        {
            file?.seek(toFileOffset: 10)
            let dataBuffer = file?.readDataToEndOfFile()
            let str = String.init(data: dataBuffer!, encoding: .utf8)
            let existe = str?.contains("PostgreSQL")
            print(existe)
            let arroz = str?.components(separatedBy: "\n")
            print(arroz)
            file?.closeFile()
        }
        
        process = true
        print ("Searching... :)")
        let queue =
            DispatchQueue(
                label: "com.odreria.marosHound",
                qos: DispatchQoS.utility)

        queue.async
        {
            for i in 0..<2
            {
                print("you done", i)
            }
        }
    }
    
    func stop()
    {
        process = false
        print ("stopping...")
    }
}

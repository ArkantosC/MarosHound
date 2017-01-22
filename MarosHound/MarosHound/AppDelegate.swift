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

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var runButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var folderText: NSTextField!
    @IBOutlet weak var fileNameText: NSTextField!
    @IBOutlet weak var containingText: NSTextField!
    @IBOutlet weak var selectFolder: NSButton!
    
    let adapter = HoundAdapter()
    
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        window.titleVisibility = NSWindowTitleVisibility.hidden
        window.isMovableByWindowBackground = true
        runButton.isEnabled = true
        cancelButton.isEnabled = false
        folderText.isEditable = false
    }

    func applicationWillTerminate(_ aNotification: Notification)
    {
        // Insert code here to tear down your application
    }
    
    @IBAction func runButtonAction(_ sender: Any)
    {
        if (!cancelButton.isEnabled)
        {
            if (!folderText.stringValue.isEmpty)
            {
                cancelButton.isEnabled = true
                runButton.isEnabled = false
            
                let model = ModelHound()
                model.folder = folderText.stringValue
                model.fileName = fileNameText.stringValue
                model.containingText = containingText.stringValue
            
                adapter.start(model: model)
            }
            else
            {
                let alert = NSAlert()
                alert.messageText = "You shoud select a folder."
                alert.alertStyle = NSAlertStyle.informational
                alert.addButton(withTitle: "OK")
                alert.runModal()
            }
        }
        
        for (key, value) in adapter.result()
        {
            print ("\(key): \(value)")
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any)
    {
        if (!runButton.isEnabled)
        {
            cancelButton.isEnabled = false
            runButton.isEnabled = true
            adapter.stop()
        }
    }
    
    @IBAction func selectFolderAction(_ sender: Any)
    {
        let dialog = NSOpenPanel()
        dialog.title = "Choose a folder"
        dialog.canChooseFiles = false
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = true
        dialog.accessoryView?.translatesAutoresizingMaskIntoConstraints = true

        if (dialog.runModal() == NSModalResponseOK)
        {
            let folder = dialog.directoryURL
            if (folder != nil)
            {
                folderText.stringValue = (folder?.absoluteString)!
            }
        }
    }
}

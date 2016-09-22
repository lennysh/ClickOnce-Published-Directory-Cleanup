# ClickOnce-Published-Directory-Cleanup

# Author  : Lenny Shirley
# Date    : 2016-09-22

# Put source folder name below
$srcfolder = "C:\Publish"

# Put the number of most recent versions you'd like to keep below
$keep = 3

# Let the work begin!
$folders = get-childitem -path $srcfolder | where-object {$_.Psiscontainer} | select-object FullName 

foreach ($folder in $folders)
{
    $appvpath = $folder.fullname + "\" + ($folder.name + "Application Files")
    $folders2 = get-childitem -path $appvpath | 
        where-object {$_.Psiscontainer} | 
        select-object Fullname |
        Sort-Object { 
            [Version] $(if ($_.FullName -match "(\d+_){3}\d+") { 
                        $matches[0] -replace "_", "."
                    } 
                    else { 
                        "0.0.0.0"
                    })  
        } -Descending |
        select -skip $keep
    
    foreach ($subfolder in $folders2)
    {
        $fullname = $subfolder.fullname
        
        # Change "-Verbose" below to "-WhatIf" to simulate what it will delete when running. (will not actually delete anything)
        Remove-Item -Recurse -Force -Verbose $fullname
    }
}

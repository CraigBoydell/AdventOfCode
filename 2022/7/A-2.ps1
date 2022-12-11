#Example:
$i = @'
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
'@

#$i = Get-Content .\I.txt -Raw

$ConsoleCommands = $i.split("`n")
#$ConsoleCommands = Get-Content .\I.txt

$CurrentPath = '/'; $CurrentFolder = ''; $FullFS = for ($y=0;$y -lt $ConsoleCommands.count; $y++) {
    $ConsoleCommand = $ConsoleCommands[$y]
   if ($ConsoleCommand -like '$ cd *')  {
     if ($ConsoleCommand -notlike '$ cd ..') {
       $CurrentFolder = $ConsoleCommand.split(' ')[-1].replace('/','')
       if ([string]::isnullorempty($CurrentFolder) -eq $false ) {
         $CurrentPath = $CurrentPath + $CurrentFolder + '/' 
       }
     }
     if ($ConsoleCommand -like '$ cd ..') {
       $CurrentFolder = $CurrentPath.split('/')[-2]
       write-host $CurrentPath
       if ([string]::isnullorempty($CurrentFolder) -eq $false ) {
         #$CurrentPath = $CurrentPath.replace('/' + $CurrentFolder,'') 
         $Split = $Currentpath.split('/')
         $CurrentPath = $Split[0..$($split.count-3)] -join '/'
         if ([string]::isnullorempty($CurrentPath)) {$CurrentPath = '/'} else {$CurrentPath = $CurrentPath + '/'}
         write-host $CurrentPath
       }
     }
     #$CurrentPath
   }
   if ($ConsoleCommand -like '$ ls') {
     do { 
        if ($ConsoleCommands[$y+1] -notlike '$ *') {
          $y++
          $fs = $ConsoleCommands[$y].split(' ')
          #write-host $fs
          $HT = [ordered]@{
            Type = if ($fs[0] -eq 'dir') {'d'} else {'f'}
            Size = if ($fs[0] -eq 'dir') {$null} else {[int]$fs[0]}
            Name = $fs[1]
            FullName = $CurrentPath + $fs[1]
            ParentFolderPath = $CurrentPath
            ParentFolder = $CurrentFOlder
          }
          new-object -TypeName PSCustomObject -Property $HT
        }
     } until ( $ConsoleCommands[$y+1] -like '$*' -or $y -ge $ConsoleCommands.count-1)
   }
 }

 $AllFolders = $FullFS | Select-Object -Property ParentFolderPath -Unique
 #$AllFolders | Select-Object -Property *,@{N='TotalSize';E={ $Test = $_.ParentFolderPath; ($FullFS |where-object {$_.Type -eq 'f' -and $_.FullName.StartsWith($Test)} | Measure-Object -Property Size -Sum).sum }} | where-object {$_.TotalSize -le 100000} | Measure-Object -Property TotalSize -sum

 $AllTotals = $AllFolders | Select-Object -Property *,@{N='TotalSize';E={ $Test = $_.ParentFolderPath; ($FullFS |where-object {$_.FullName.StartsWith($Test)} | Measure-Object -Property Size -Sum).sum }} | Sort-object -Property TotalSize


 $SpaceForUpdate = 30000000
 $TotalFSSpacePossible = 70000000
 $SizeToDelete = $SpaceForUpdate - $($TotalFSSpacePossible - $($AllTotals | Select-Object -last 1).totalsize)

 $AllTotals | where-object {$_.TotalSize -ge $SizeToDelete} | Sort-Object -Property TotalSize -Descending | select-object -last 1



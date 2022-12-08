#Example:
$i = @'
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
'@

$i = Get-Content .\I.txt -Raw

$Stacks = ((($i -split "`n")[0]) -split "`n")
$Stacks = ((($i -split "`n")[0]) -split "`n")

$Stacks = $Stacks[($Stacks.length-1)..0]
$Stacks[0] = $Stacks[0].trim().replace('   ',',')
#$Stacks = ($Stacks -join ';').replace('] [','],[').replace('    ',',').split(';') | ConvertFrom-Csv
$Stacks = ($Stacks |foreach { $_.replace('] [','],[').replace('    ',',').replace(' ',',')  }) | ConvertFrom-Csv
($Stacks | gm | where {$_.MemberType -eq 'NoteProperty'}).name | foreach { $varName = $('Stack' + $_); get-variable $varname -ErrorAction SilentlyContinue|Remove-Variable; New-Variable -Name $varName -Value $(New-Object -TypeName "System.Collections.ArrayList"); $Stacks.$_ | where {[string]::isnullorempty($_) -eq $false } | foreach { $(Get-Variable $varname).value.add($_) | out-null  }  }

#$WO = ((($i -split "`n`n")[1]) -split "`n")
$WO = ((($i -split "`n`r`n")[1]) -split "`n")
$WO | foreach-object {
  $WOSplit = $_.split(' ')
  $NumberToMove = $([int]$WOSplit[1])
  $StackToMoveFrom = $WOSplit[3].trim()
  $StackToMoveTo = $WOSplit[5].trim()
  1..$NumberToMove | foreach-object {
    $Container = $(get-variable -name $("Stack" + $StackToMoveFrom)).value[-1]; #$Container
    (get-variable -name $("Stack" + $StackToMoveFrom)).value.removeAt($((get-variable -name $("Stack" + $StackToMoveFrom)).value.count) -1); $(get-variable -name $("Stack" + $StackToMoveTo)).value.add($Container) | out-null
  }
  $TopOfStack = ((($Stacks | gm | where-object {$_.MemberType -eq 'NoteProperty'}).name | foreach-object { $varName = $('Stack' + $_); (get-variable $varname).value | Select-Object -Last 1}) -join '').replace('[','').replace(']','')

  #$TopOfStack
}

$TopOfStack = ((($Stacks | gm | where-object {$_.MemberType -eq 'NoteProperty'}).name | foreach-object { $varName = $('Stack' + $_); (get-variable $varname).value | Select-Object -Last 1}) -join '').replace('[','').replace(']','')

$TopOfStack


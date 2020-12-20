
############# For Example
$TicketInput = @'
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
'@

#$TicketInput = get-content .\I.txt -raw
#$TicketInput = $((get-content .\I.txt -raw) -split ("`r?`n`r?`n"))
$TicketInput = $TicketInput -split ("`n`n")
$ValidTickets = New-Object -TypeName "System.Collections.ArrayList"
$RowMapArray = New-Object -TypeName "System.Collections.ArrayList"
$RowMap = @{}

$Pattern = '(\d+-\d+)'
$InRange = ($TicketInput[0]) -split "`n" | foreach {(($_ | Select-String -Pattern $pattern -AllMatches).matches.value | foreach { $_.replace('-','..')  }) -join ';' | Invoke-Expression}
$NT = $TicketInput[2].split("`n")
$NT[1..$($NT.getupperbound(0))] | foreach { $Ticket = $_; $TicketValid = $True; $Ticket -split (",") | foreach { if ($_ -notin $InRange) {$TicketValid = $false}   }; if ($TicketValid -eq $true) {$ValidTickets.Add($Ticket) | out-null}   }

0..$(($TicketInput[0] -split ("`n")).count -1) | foreach {
  $RowCount = $_
  $Test = $ValidTickets | foreach {
    $Ticket = $($_ -split (','))[$RowCount]
    $Ticket | foreach {
      switch ($_) {
        {$_ -in $(0..1;4..19)} {'class'}
        {$_ -in $(0..5;8..19)} {'row'}
        {$_ -in $(0..13;16..19)} {'seat'}
      }
    }
  }
  $RowMap[$RowCount] = ($Test | Group-Object | where {$_.count -eq $ValidTickets.count}).Name
  $RowMapArray.Add($(new-object -TypeName PSObject -property @{RowCount=$RowCount; Rows = $(($Test | Group-Object | where {$_.count -eq $ValidTickets.count}).Name) })) | out-null
}

while (@($RowMapArray | where {$_.Rows.count -gt 1}).count -ne 0) {
  ($RowMapArray | where {$_.Rows.count -eq 1}).Rows | foreach { $RowToConsolidate = $_; $RowMapArray | where {$RowToConsolidate -in $_.rows -and $_.Rows.count -ne 1} | foreach { $_.Rows = $_.Rows | where {$_ -ne $RowToConsolidate} }  }
}

$CSV = $TicketInput[1].replace('your ticket:',$($RowMapArray.rows -join ',')) | convertfrom-csv
$(($CSV | Select-Object -Property * | gm | where {$_.MemberType -eq 'NoteProperty'}).name | foreach {$CSV.$_}) -join '*' | Invoke-Expression

############# For Input File
$TicketInput = $((get-content .\I.txt -raw) -split ("`r?`n`r?`n"))
#$TicketInput = $TicketInput -split ("`n`n")
$ValidTickets = New-Object -TypeName "System.Collections.ArrayList"
$RowMapArray = New-Object -TypeName "System.Collections.ArrayList"
#$RowMap = @{}

$Pattern = '(\d+-\d+)'
$InRange = ($TicketInput[0]) -split "`n" | foreach {(($_ | Select-String -Pattern $pattern -AllMatches).matches.value | foreach { $_.replace('-','..')  }) -join ';' | Invoke-Expression}
$NT = $TicketInput[2].split("`n")
$NT[1..$($NT.getupperbound(0))] | foreach { $Ticket = $_; $TicketValid = $True; $Ticket -split (",") | foreach { if ($_ -notin $InRange) {$TicketValid = $false}   }; if ($TicketValid -eq $true) {$ValidTickets.Add($Ticket) | out-null}   }

0..$(($TicketInput[0] -split ("`n")).count -1) | foreach {
  $RowCount = $_
  $Test = $ValidTickets | foreach {
    $Ticket = $($_ -split (','))[$RowCount]
    $Ticket | foreach {
      switch ($_) { #Consider how to build this programmatically
        {$_ -in $(49..848;871..949)} {'departure location'}
        {$_ -in $(33..670;687..969)} {'departure station'}
        {$_ -in $(41..909;916..974)} {'departure platform'}
        {$_ -in $(40..397;422..972)} {'departure track'}
        {$_ -in $(31..481;505..960)} {'departure date'}
        {$_ -in $(37..299;312..965)} {'departure time'}
        {$_ -in $(46..114;126..967)} {'arrival location'}
        {$_ -in $(28..453;478..963)} {'arrival station'}
        {$_ -in $(26..756;781..973)} {'arrival platform'}
        {$_ -in $(30..231;252..968)} {'arrival track'}
        {$_ -in $(26..820;828..967)} {'class'}
        {$_ -in $(31..901;910..958)} {'duration'}
        {$_ -in $(47..711;722..952)} {'price'}
        {$_ -in $(48..518;524..956)} {'route'}
        {$_ -in $(50..166;172..974)} {'row'}
        {$_ -in $(26..792;810..963)} {'seat'}
        {$_ -in $(28..617;637..952)} {'train'}
        {$_ -in $(30..734;748..962)} {'type'}
        {$_ -in $(41..429;454..968)} {'wagon'}
        {$_ -in $(25..129;142..971)} {'zone'}
      }
    }
  }
  #$RowMap[$RowCount] = ($Test | Group-Object | where {$_.count -eq $ValidTickets.count}).Name
  $RowMapArray.Add($(new-object -TypeName PSObject -property @{RowCount=$RowCount; Rows = $(($Test | Group-Object | where {$_.count -eq $ValidTickets.count}).Name) })) | out-null
}

while (@($RowMapArray | where {$_.Rows.count -gt 1}).count -ne 0) {
  ($RowMapArray | where {$_.Rows.count -eq 1}).Rows | foreach { $RowToConsolidate = $_; $RowMapArray | where {$RowToConsolidate -in $_.rows -and $_.Rows.count -ne 1} | foreach { $_.Rows = $_.Rows | where {$_ -ne $RowToConsolidate} }  }
}

$CSV = $TicketInput[1].replace('your ticket:','train,arrival track,departure track,type,duration,route,arrival platform,departure date,arrival station,departure location,zone,price,departure station,wagon,class,arrival location,seat,row,departure platform,departure time') | convertfrom-csv
$(($CSV | Select-Object -Property departure* | gm | where {$_.MemberType -eq 'NoteProperty'}).name | foreach {$CSV.$_}) -join '*' | Invoke-Expression

$Source = Get-Content .\ex2.txt -Raw

$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$Numbers = 0..9 | foreach {$_.tostring()}

$NumbersAsWord = @'
Name,Number
one,1
two,2
three,3
four,4
five,5
six,6
seven,7
eight,8
nine,9
'@ | ConvertFrom-Csv

#$Pattern = 'one|two|three|four|five|six|seven|eight|nine'
#$Pattern2 = '(?=(one|two|three|four|five|six|seven|eight|nine))'
$Pattern4 = '(?=(one|two|three|four|five|six|seven|eight|nine|[1-9]))'

$AllNumbers = for ($i=0;$i -lt $SourceSplit.count;$i++) {
  #Select-String $Pattern -input $SourceSplit[$i] -AllMatches | foreach {$_.Matches.value} | foreach { 
  <#
    (Select-String $Pattern2 -input $SourceSplit[$i] -AllMatches).matches.groups | where {$_.success -eq $True -and $_.Value -ne ''} | foreach {$_.value} | foreach { 
    $MatchValue = $_; $NumbersAsWord | where {
      $_.Name -eq $MatchValue
    } | foreach {
      $SourceSplit[$i] = $SourceSplit[$i].Replace($_.Name,$_.Number)
    }
  }
  #>

  @((Select-String $Pattern4 -input $SourceSplit[$i] -AllMatches).matches.groups | where {
    $_.success -eq $True -and $_.Value -ne ''
  } | foreach {$_.value} | foreach {
    $MatchValue = $_; $MatchWordToNumber = $NumbersAsWord | where {
      $_.Name -eq $MatchValue
    }
    if ($MatchWordToNumber) {
      $MatchWordToNumber.Number
    } else {
      $MatchValue
    }
    }
  )[0,-1] -join ''

}

#$AllNumbers = $SourceSplit | foreach { $Test=$_; @(for ($i=0; $i -lt $Test.Length; $i++) { if ( $Test[$i] -in $numbers  ) {$Test[$i]}  })[0,-1] -join ''  }
($AllNumbers | Measure-Object -sum).sum

# Answer:
#54249
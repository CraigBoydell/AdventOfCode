$Source = Get-Content .\ex.txt -Raw

$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")



$Numbers = 0..9 | foreach {$_.tostring()}
$AllNumbers = $SourceSplit | foreach { $Test=$_; @(for ($i=0; $i -lt $Test.Length; $i++) { if ( $Test[$i] -in $numbers  ) {$Test[$i]}  })[0,-1] -join ''  }
($AllNumbers | Measure-Object -sum).sum

#Answer:
#53194
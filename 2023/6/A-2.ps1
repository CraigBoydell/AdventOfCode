#$Source = Get-Content .\ex2.txt -Raw
#$Source = Get-Content .\I.txt -Raw

#$SourceSplit = $Source.split("`n")


$Source = get-content .\I2.txt -Raw
$Source
$DistToBeat = 277133813491063
$TotalTime = 40829166
$TimeToTest = 1

do { $TimeToTest++ } until ((($TotalTime - $TimeToTest) * $TimeToTest) -gt $DistToBeat)


$TimeToTest2 = $TotalTime - $TimeToTest

$TimetoTest2-$TimeToTest + 1

# Answer:
# 23632299
#Example:
$i = @'
mjqjpqmgbljsphdztnvjfqwrcgsmlb
bvwbjplbgvbhsrlpgdmjqwftvncz
nppdvjthqldpwncqszvftbrmjlhg
nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg
zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw
'@

#$i = Get-Content .\I.txt -Raw

$dsBuffers = $i.split("`n")
$dsBuffers = Get-Content .\I.txt -Raw

$dsBuffers | foreach {$dsBuffer = $_;  for ($i=4;$i -lt $dsBuffer.length+1;$i++) { if (($($dsBuffer.Substring($i-4,4).tochararray() | Select-Object -Unique) -join '').length -eq 4) {$i; return} else {} }}

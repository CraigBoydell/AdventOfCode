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
#$dsBuffers = Get-Content .\I.txt -Raw

$dsBuffers | foreach {$dsBuffer = $_;  for ($i=14;$i -lt $dsBuffer.length+1;$i++) { if (($($dsBuffer.Substring($i-14,14).tochararray() | Select-Object -Unique) -join '').length -eq 14) {$i; return} else {} }}

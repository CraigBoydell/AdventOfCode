$Source = Get-Content .\ex.txt
#$Source = Get-Content .\ex2.txt -Raw
#$Source = Get-Content .\I.txt


#By Sorting, this method walks the ranges and continualy process the min,max, and oldmax values.
# this means that when it reaches the end of a range it can determine how many were in that range, and also if it is the end of the range move to the next one
$sortedranges = $source | where-object {$_ -like "*-*"} | sort-object {[long]($_ -split '-')[0]}
 $oldmax=0
 $sum = 0
 $sortedranges | foreach-object {
     $min,$max = $_ -split '-'
     if ([long]$max -gt [long]$oldmax){
         $max - $min +1
         if ([long]$min -le $oldmax){
             $min - $oldmax -1
             }
         $oldmax=$max
         }
     } |foreach-object {$sum = $sum + [long]$_}
$sum


#Answer
#352946349407338
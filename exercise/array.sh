array_var=(1 2 3 4 5 6)
array_var[0]="test1"
echo ${array_var[0]}
echo ${#array_var[*]}
echo ${array_var[@]}
echo ${!array_var[*]}

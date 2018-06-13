 #============ get the file name ===========    
Folder_A="H:\git\Doc\Doc\使用指南\快速入门"    
for file_a in ${Folder_A}/*  
do    
    temp_file=`basename $file_a` 
	str=$"$temp_file \n"
	sstr=$(echo -e $str)
    echo $str >> 2.txt   
done    
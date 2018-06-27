 #============ get the file name ===========    
Folder_A="H:\git\Doc\Doc\使用指南\快速入门"  
Folder_B="H:\git\Doc\Doc\参考资料"  
Folder_C="H:\git\Doc\Doc\使用指南\API 手册"  
Folder_D="H:\git\Doc\Doc\使用指南\Demo教程"  
Folder_H="H:\git\Doc\Doc\使用指南\接入指南"  
Folder_F="H:\git\Doc\Doc\使用指南\视频教程"

for file_a in ${Folder_A}/*  
do    
    temp_file=`basename $file_a` 
	str=$"$temp_file \n"
	sstr=$(echo -e $str)
    echo $str >> 2.txt   
done    

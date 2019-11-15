#/bin/sh
# 批量打包脚本
# Author:show

bin_dir=$(cd "$(dirname "$0")"; pwd)
apk_dir=$bin_dir/apkbase
apk_out_dir=$bin_dir/apkout
apk_file_dir=$bin_dir/apkfile
apk_sign_dir=$bin_dir/apksign


HOST='192.168.0.112'
USER='apk'
PASSWD='a123456'

#获取文件夹下面文件，该文件夹不能有子文件夹，不再作判断
function read_dir(){

	# PRONUM=5               #进程个数  
	# tmpfile="$$.fifo"        #临时生成管道文件  
	# mkfifo $tmpfile  
	# exec 6<>$tmpfile  
	# rm $tmpfile  
	  
	# for(( i=0; i<$PRONUM; i++ ))  
	# do  
	#         echo "init."  
	# done >&6  

	# FILE='filelist.txt'


	echo "read:"$1;
	echo "[out_dir]:"$apk_out_dir
	for file in `ls $1`
	do
	{
		rfile=$1"/"$file
		basefilename=$(basename ${file} .apk)
		if [ $2 -eq 2 ];then
			echo 'type:2';
			# 非白包要有解压的过程
			echo "【"$file"】解包中"
			apktool d $rfile -o $apk_out_dir/$basefilename
			echo "【"file"】打包中"
			apktool b $apk_out_dir/$basefilename -o $apk_file_dir/$file
			# 删除解包文件
			rm -rf $apk_out_dir/$basefilename
			echo "【"file"】签名中"$apk_sign_dir/$basefilename"_sign.apk"
			#_sign
			echo bbq123|jarsigner -verbose -keystore /code/android/package/test.keystore -signedjar $apk_sign_dir/$basefilename".apk" $apk_file_dir/$file test.keystore
			# 删除打包文件,只保留base
			unlink $apk_file_dir/$file
		else
			echo 'type:other';
			# 白包，直接打签名
			# echo bbq123|jarsigner -verbose -keystore /code/android/package/test.keystore -signedjar $apk_sign_dir/$basefilename".apk" $apk_dir/$file test.keystore
			#已签名的包，不用再解包,直接签名
			java -jar /code/android/package/signapk.jar /code/android/package/test.pem /code/android/package/test.pk8 $apk_dir/$file $apk_sign_dir/$basefilename".apk"
			
		fi
		# 删除签名完的源文件
		unlink $rfile

		#打包完之后上传到指定的ftp
		# folder=${basefilename:0:9}
		folder=${basefilename:0-13:6}
		echo "【上传】"$basefilename"正在上传到共享盘！";

		# 有可能没打包好就上传了？
		#测试顺序执行
ftp -n<<END_SCRIPT
open $HOST
user $USER $PASSWD
binary       //二进制镜像传输
cd apk
mkdir $folder
put $apk_sign_dir/$basefilename".apk" /apk/$folder/$basefilename".apk"
prompt
quit
END_SCRIPT
		#上传完之后，删除sign文件 不能直接这样写
		# unlink $apk_sign_dir/$basefilename".apk" 
	# }& #并行的方法
	} #普通的方法
	done 
	echo 'wait'
	wait
}


echo "start"
# read_dir $apk_dir 2 #解包方式2
read_dir $apk_dir 1   #直签方式1
exit;
#先自动下载到指定文件夹
nums=(
	http://www.baidu.com
	http://www.baidu.com
)
nums=($(awk '{print $1}' filelist.txt))
for str in ${nums[@]};
do
{
	echo $str
	downloadName=$(basename ${str} )
	echo $downloadName

	wget -O ./apkbase/$downloadName $str
	# read_dir $apk_dir 2
}&	
done
wait
echo "finish";

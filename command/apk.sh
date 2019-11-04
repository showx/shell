#/bin/sh
# 批量打包脚本
# Author:show

bin_dir=$(cd "$(dirname "$0")"; pwd)
root_dir=$(dirname $bin_dir)
lib_dir=$root_dir/lib
apk_dir=$bin_dir/apkbase
apk_out_dir=$bin_dir/apkout
apk_file_dir=$bin_dir/apkfile
apk_sign_dir=$bin_dir/apksign

#todo 自动下载

#获取文件夹下面文件，该文件夹不能有子文件夹，不再作判断
function read_dir(){
	echo "read:"$1;
	echo "[out_dir]:"$apk_out_dir
	for file in `ls $1`
	do
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
			echo bbq123|jarsigner -verbose -keystore /code/android/package/test.keystore -signedjar $apk_sign_dir/$basefilename".apk" $apk_dir/$file test.keystore
		fi
	done
}



echo $(dirname "$0");
echo "pwd:"$(pwd);
echo "pwd:"$bin_dir;
echo "root:"$root_dir;
echo $lib_dir;

#先自动下载到指定文件夹

read_dir $apk_dir 2

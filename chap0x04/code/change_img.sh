#!/usr/bin/env bash

#帮助文档
function helpInfo {
	echo -e "image.sh - For Images Batch Processing.\n"
	echo -e "Tips: Before using this script, be sure you have installed ImageMagick, or input 'sudo apt install imagemagick' to install.\n"
	echo "Usage: bash image.sh [arguments]"
	echo "Arguments:"
	echo "  -d <path>		: Iuput the path of the picture that you want to operate."
	echo "  -q <percentage>	: Compress the quality of JPG images,
			  eg: -q 50% (means compress 50%)."
	echo "  -r <width>		: Compress the resolution of JPEG/PNG/SVG images,
			  eg: -r 50 (means compress width to 50)."
	echo "  -w <text>		: Embed text watermark in all images."
	echo "  -p <pre_text>		: Rename all files by adding prefix."
	echo "  -s <suf_text>		: Rename all files by adding suffix."
	echo "  -c			: Convert PNG/SVG images to JPEG images."
	echo "  -h or --help		: Print Help (this message) and exit."
}

#对jpeg格式图片进行图片质量压缩
function QualityCompress {
	directory=$1
	pecentage=$2

	[ -d "out_q" ] || mkdir "out_q"		#保存压缩后图片在该目录

	#查找具有指定后缀的文件，.*表示任意长度字符串
	jpeg_images="$(find "$directory" -regex '.*\(jpg\|JPG\|jpeg\)')"
        for img in $jpeg_images;do
		fullname="$(basename "$img")" 	#删除文件名的目录
		filename="${fullname%.*}" 	#得到文件名
		typename="${fullname##*.}" 	#得到文件后缀
		convert "$img" -quality "$pecentage" ./out_q/"$filename"."$typename"
	done

	echo "successed JPEG quality compressing."
}

#对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function ResolutionCompress {
	directory=$1
	width=$2

	[ -d "out_r" ] || mkdir "out_r"
	j_images="$(find "$directory" -regex '.*\(jpg\|JPG\|jpeg\|png\|PNG\|svg\|SVG\)')"
	for img in $j_images; do
		fullname="$(basename "$img")"
                filename="${fullname%.*}"
                typename="${fullname##*.}"
                convert "$img" -resize "$width" ./out_r/"$filename"."$typename"
        done
        
	echo "Successed resolution copressing."
}

#对图片批量添加自定义文本水印
function AddWatermark {
	directory=$1
	watermark_text=$2

	[ -d "out_w" ] || mkdir "out_w"
	j_images="$(find "$directory" -regex '.*\(jpg\|JPG\|jpeg\|png\|PNG\|svg\|SVG\)')"
        for img in $j_images;do
		fullname="$(basename "$img")"
		filename="${fullname%.*}"
		typename="${fullname##*.}"
		convert "$img" -gravity center -fill red -pointsize 50 -draw "text 5,5 '$watermark_text'" ./out_w/"$filename"."$typename"
	done
        
	echo "Successed watermark adding."

}

#批量重命名--统一添加文件名前缀
function AddPrefix {
	directory=$1
	prefix=$2

        [ -d "out_p" ] || mkdir "out_p"
	for img in "$directory"*.*; do
		fullname="$(basename "$img")"
		filename="${fullname%.*}"
		typename="${fullname##*.}"
		cp "$img" ./out_p/"$prefix""$filename"."$typename"
	done

	echo "Successed prefix adding."
}

#统一添加文件名后缀
function AddSuffix {
        directory=$1
        suffix=$2

	[ -d "out_s" ] || mkdir "out_s"
        for img in "$directory"*.*; do
                fullname="$(basename "$img")"
                filename="${fullname%.*}"
                typename="${fullname##*.}"
                cp "$img" ./out_s/"$filename""$suffix"."$typename"
        done

        echo "Successed suffix adding."
}

#将png/svg图片统一转换为jpg格式图片
function Conversion {
	directory=$1

	[ -d "out_c" ] || mkdir "out_c"
	p_images="$(find "$directory" -regex '.*\(png\|PNG\|svg\|SVG\)')"
	for img in $p_images; do
		fullname="$(basename "$img")"
		filename="${fullname%.*}"
		convert "$img" ./out_c/"$filename"".jpg"
	done

	echo "Successed coverting to JPEG."
}

#main

path=""

if [[ "$#" -eq 0 ]];then #若参数为0
	echo -e "Please input some arguments,refer the help information below:\n"
	helpInfo
fi

while [[ "$#" -ne 0 ]] #若参数为不0
do
	case "$1" in
		"-d")
			if [[ "$2" != '' ]];then
				path="$2"
				shift 2 #将参数左移两位，$#也相应减少
			else
				echo "Please input a path after '-i'."
				exit 0
			fi
			;;
		"-q")
			if [[ "$2" != '' ]];then
                QualityCompress "$path" "$2"
				shift 2
			else
				echo "please input a quality argument.eg: -q 50%"
				exit 0
			fi
			;;
		"-r")
			if [[ "$2" != '' ]];then
				ResolutionCompress "$path" "$2"
				shift 2
			else
				echo "Please input a pecentage for resizing.eg:-r 50"
				exit 0
			fi
			;;
		"-w")
			if [[  "$2" != ''  ]]; then
				AddWatermark "$path" "$2"
				shift 2
			else
				echo "Please input a watermark text. eg: -w hello"
				exit 0
			fi
			;;
		"-p")
			if [[  "$2" != ''  ]]; then
				AddPrefix "$path" "$2"
				shift 2
			else
				echo "Please input some words after '-p'(for prefix)"
				exit 0
			fi
			;;
		"-s")
			if [[  "$2" != ''  ]]; then
                AddSuffix "$path" "$2"
                shift 2
            else
                echo "Please input some words after '-s'(for suffix)"
                exit 0
            fi
            ;;
		"-c")
			Conversion "$path"
			shift
			;;
		"-h" | "--help")
			helpInfo
			exit 0
	esac
done
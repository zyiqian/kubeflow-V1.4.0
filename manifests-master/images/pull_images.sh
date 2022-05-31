#!/bin/bash
G=`tput setaf 2`
C=`tput setaf 6`
Y=`tput setaf 3`
Q=`tput sgr0`

echo -e "${C}\n\n镜像下载脚本:${Q}"
echo -e "${C}pull_images.sh将读取images.txt中的镜像\n\n${Q}"

# 清理本地已有镜像
# echo "${C}start: 清理镜像${Q}"
# for rm_image in $(cat images.txt)
# do 
#  docker rmi $aliNexus$rm_image
# done
# echo -e "${C}end: 清理完成\n\n${Q}"

# pull
#echo "${C}start: 开始拉取镜像...${Q}"
#for pull_image in $(cat images.txt)
do    
  echo "${Y}    开始拉取$pull_image...${Q}"
  fileName=${pull_image//:/_}
  docker pull $pull_image
done
echo "${C}end: 镜像拉取完成...${Q}"

# push镜像
IMAGES_LIST=($(docker images | sed '1d' | awk '{print $1}'))
IMAGES_VS_LIST=($(docker images | sed  '1d' | awk '{print $2}'| awk -F/ '{print $NF}'))
IMAGES_NM_LIST=($(docker images | sed  '1d' | awk '{print $1":"$2}'| awk -F/ '{print $NF}'))
IMAGES_NUM=${#IMAGES_LIST[*]}
echo "镜像列表....."
docker images
for((i=0;i<$IMAGES_NUM;i++))
do
  echo "-----tag ${IMAGES_LIST[$i]}:${IMAGES_VS_LIST[$i]} registry.cn-hangzhou.aliyuncs.com/kubeflow-pub/${IMAGES_NM_LIST[$i]} "
  docker tag  "${IMAGES_LIST[$i]}:${IMAGES_VS_LIST[$i]}" registry.cn-hangzhou.aliyuncs.com/kubeflow-pub/"${IMAGES_NM_LIST[$i]}"
  echo "*****push registry.cn-hangzhou.aliyuncs.com/kubeflow-pub/${IMAGES_NM_LIST[$i]}"
  docker push registry.cn-hangzhou.aliyuncs.com/kubeflow-pub/"${IMAGES_NM_LIST[$i]}"
done
echo -e "${C}end: push完成\n\n${Q}"



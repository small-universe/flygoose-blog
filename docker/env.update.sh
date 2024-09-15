#!/bin/bash

# 优先从环境变量中获取 BASE_URL 和 SEARCH_FOLDER
env_base_url=${BASE_URL:-}
env_folder_path=${SEARCH_FOLDER:-}

# 如果环境变量中没有，则从 .env 文件中获取
if [ -z "$env_base_url" ] || [ -z "$env_folder_path" ]; then
    if [ ! -f .env ]; then
        echo ".env 文件不存在"
        exit 1
    fi

    if [ ! -r .env ]; then
        echo "没有读取.env 文件的权限"
        exit 1
    fi

    while IFS='=' read -r key value; do
        if [ -z "$env_base_url" ] && [ "$key" = "BASE_URL" ]; then
            env_base_url=$value
        elif [ -z "$env_folder_path" ] && [ "$key" = "SEARCH_FOLDER" ]; then
            env_folder_path=$value
        fi
    done <.env
fi

echo "获取到的 BASE_URL 值为: $env_base_url"
echo "获取到的 SEARCH_FOLDER 值为: $env_folder_path"

# 在指定文件夹及其子目录下查找包含 BASE_URL 的文件
if [ -n "$env_folder_path" ];
then
    echo "开始在 $env_folder_path 文件夹及其子目录下查找包含 BASE_URL 的文件"
    file_list=$(find "$env_folder_path" -type f | xargs grep -l -i "BASE_URL")

    if [ -z "$file_list" ]; then
        echo "在 $env_folder_path 文件夹及其子目录下未找到包含 BASE_URL 的文件"
    else
        for file in $file_list; do
            echo "正在处理文件: $file"
            sed -i "s|\(BASE_URL\":\s*\"\)[^\"]*|\1$env_base_url|g" $file
            echo "已在文件 $file 中完成 BASE_URL 的替换"
        done
    fi
else
    echo "没有获取到有效的 SEARCH_FOLDER 配置"
    exit 1
fi

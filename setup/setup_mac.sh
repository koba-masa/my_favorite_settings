#!/bin/sh

# スクリーンショットの保存場所を変更する
dest_dir="~/Pictures/00.Screenshots"
if [ ! -d "${dest_dir}" ]; then
  mkdir -p "${dest_dir}"
fi
defaults write com.apple.screencapture location "${dest_dir}"

# 隠しファイルを常に表示する
defaults write com.apple.finder AppleShowAllFiles 1

# ディスプレイごとの操作スペースを解除する「ディスプレイごとに個別の操作スペース」
defaults write com.apple.spaces spans-displays 1

# スクロールの方向を変更する
defaults write NSGlobalDomain com.apple.swipescrolldirection 0

echo "再起動してください"

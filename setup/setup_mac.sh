#!/bin/sh

function backup() {
  local backup_dir=$1
  local file_prefix=$2

  defaults read > "${backup_dir}/${file_prefix}.json"
}

# 事前バックアップを取得する
now_date=`date +%Y%m%d_%H%M%S`
backup_dir="setup/backup_defaults_${now_date}"
if [ ! -d "${backup_dir}" ]; then
  mkdir -p "${backup_dir}"
fi
backup "${backup_dir}" "before"

# スクリーンショットの保存場所を変更する
dest_dir="${HOME}/Pictures/00.Screenshots"
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

# 事後バックアップを取得する
backup "${backup_dir}" "after"

echo "再起動してください"

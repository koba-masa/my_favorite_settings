# Gitコマンド
## ログを1行にて表示する
```sh
$ git log --date='format-local:%Y/%m/%d %H:%M:%S' --pretty='format:%C(yellow)%H %C(green)%ad %C(reset)%s %C(red)%d'
```

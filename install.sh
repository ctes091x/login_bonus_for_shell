#!/bin/sh
cd `dirname $0`
if [ -d $HOME/.login_bonus_for_shell ]; then
	echo "再インストールしますか？ (Y / n)"
	read ans
	if [ $ans == Y ]; then
		rm -rf $HOME/.login_bonus_for_shell
		echo "旧ファイルを削除しました"
		mkdir $HOME/.login_bonus_for_shell
		cp ./* $HOME/.login_bonus_for_shell
		echo "ファイルをコピーしました"
	else
		echo "インストールを中断しました"
		exit 1
	fi
else
	echo "インストールを開始します"
	mkdir $HOME/.login_bonus_for_shell
	cp ./* $HOME/.login_bonus_for_shell
	echo "ファイルをコピーしました"
fi

if [ -f $HOME/.zshrc ]; then
	echo ".zshrcが見つかりました"
  target="$HOME/.zshrc"
elif [ -f $HOME/.bashrc ]; then
	echo ".bashrcが見つかりました"
  target="$HOME/.bashrc"
elif [ -f $HOME/.bash_profile ]; then
	echo ".bash_profileが見つかりました"
  target="$HOME/.bash_profile"
else
	touch $HOME/.bash_profile
	echo ".bash_profileを作成しました"
  target="$HOME/.bash_profile"
fi

check=`grep -ci "cd $HOME/.login_bonus_for_shell" $target`

if [ $check -eq 0 ]; then
	ver=`python -V 2>&1 | cut -c 8`
	if [ $? -eq 127 ]; then
		echo "Python3またはPython2が必要です"
		rm -rf $HOME/.login_bonus_for_shell
		echo "インストールを中断しました"
		exit 1
	fi

	dec=`expr "$ver" = "3"`
	if [ $dec -eq 1 ]; then
		echo "Python3を確認しました"
		echo "cd $HOME/.login_bonus_for_shell" >> $target
		echo "python logger.py" >> $target
	fi

	dec=`expr "$ver" = "2"`
	if [ $dec -eq 1 ]; then
		echo "Python2を確認しました"
		echo "cd $HOME/.login_bonus_for_shell" >> $target
		echo "python logger_for_python2.py" >> $target
	fi

	echo "cd $HOME/" >> $target
	echo "$target を変更しました"
	echo "インストール完了"
	exit 0
else
	echo "再インストール完了"
	exit 0
fi

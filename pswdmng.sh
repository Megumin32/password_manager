echo パスワードマネージャーへようこそ！
echo パスワードを入力してください．（初めての場合は作成します．）

################################################################
#未完成部分
#secret.txt.gpg がない場合，パスワードを新規作成
#パスワードが正しくないと空のsecret.txtが作成されるため，この場合はExit
read -s pass
gpg --batch --passphrase="$pass" -d secret.txt.gpg > secret.txt 2> /dev/null #パスフレーズを$passに指定して復号
head -n secret.txt
if [ -e secret.txt = 0] ; then 
    Choice=1 #Exit以外ならなんでもよい
else
    echo パスワードが違います．
    rm secret.txt
    Choice="Exit"
fi
#################################################################

while [ $Choice != "Exit" ]
do
    rm secret.txt
    echo "次の選択肢から入力してください(Add Password / Get Password / Exit)："
    read Choice
    if [ $Choice = "Add Password" ] ; then
        echo サービス名を入力してください：
        read Svs
        echo ユーザー名を入力してください：
        read Usrz
        echo パスワードを入力してください：
        read Pwd
        gpg --batch --passphrase="$pass" -d secret.txt.gpg > secret.txt 2> /dev/null #パスフレーズを$passに指定して復号
        echo "$Svs:$Usr:$Pwd" >> secret.txt
        gpg --batch --yes --passphrase="$pass" -c secret.txt  #パスフレーズを$passに指定して暗号化
        echo パスワードの追加は成功しました．
    elif [ $Choice = "Get Password" ] ; then
        echo サービス名を入力してください．
        read Svs
        gpg --batch --passphrase="$pass" -d secret.txt.gpg > secret.txt 2> /dev/null #パスフレーズを$passに指定して復号
        if [ $Svs = $(grep "^$Svs:" secret.txt | cut -d : -f 1) ] ; then #完全一致しているかのチェック
            echo サービス名：$Svs
            echo ユーザー名：$(grep "^$Svs:" secret.txt | cut -d : -f 2)
            echo パスワード：$(grep "^$Svs:" secret.txt | cut -d : -f 3)
        else
            echo そのサービス名は登録されていません．
        fi
        gpg --batch --yes --passphrase="$pass" -c secret.txt  #パスフレーズを$passに指定して暗号化
    elif [ $Choice = "Exit" ] ; then
        echo Thank you!
    else
        echo 入力が間違っています．Add Password / Get Password いずれかを入力してください．
    fi
done
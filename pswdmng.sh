echo パスワードマネージャーへようこそ！
################keyを作成済みの場合はkeyが正しいか判定，未作成の場合新規作成################
if [ -e key.txt.gpg ] ; then
    echo パスワードマネージャーのパスワードを入力してください．
    read -s IPwd
    gpg --batch --passphrase="$IPwd" -d key.txt.gpg > key.txt 2> /dev/null #keyの復号
    if [ $IPwd = $(cat key.txt)  ] ; then
        rm key.txt 
        Choice=1 #Exit以外ならなんでもよい
    else
        echo パスワードが違います．
        rm key.txt
        Choice="Exit"
    fi
else
    echo 新規にパスワードを作成します．入力したらEnterを押してください．
    read -s IPwd
    echo $IPwd > key.txt 2> /dev/null
    gpg --batch --yes --passphrase="$IPwd" -c key.txt  #keyの暗号化
    rm key.txt
    Choice=1 #Exit以外ならなんでもよい
fi
##################################################################################
while [ "$Choice" != "Exit" ]
do
    rm secret.txt 2> /dev/null
    echo "次の選択肢から入力してください(Add Password / Get Password / Exit)："
    read Choice
    if [ "$Choice" = "Add Password" ] ; then
        echo サービス名を入力してください：
        read Svs
        echo ユーザー名を入力してください：
        read Usr
        echo パスワードを入力してください：
        read Pwd
        gpg --batch --passphrase="$IPwd" -d secret.txt.gpg > secret.txt 2> /dev/null #secretの復号
        echo "$Svs:$Usr:$Pwd" >> secret.txt
        gpg --batch --yes --passphrase="$IPwd" -c secret.txt  #secretの暗号化
        echo パスワードの追加は成功しました．
    elif [ "$Choice" = "Get Password" ] ; then
        echo サービス名を入力してください．
        read Svs
        gpg --batch --passphrase="$IPwd" -d secret.txt.gpg > secret.txt 2> /dev/null #secretの復号
        if [ "$Svs" = "$(grep "^$Svs:" secret.txt | cut -d : -f 1)" ] ; then #入力したサービス名とsecret内のサービス名が完全一致しているかのチェック
            echo サービス名：$Svs
            echo ユーザー名：$(grep "^$Svs:" secret.txt | cut -d : -f 2)
            echo パスワード：$(grep "^$Svs:" secret.txt | cut -d : -f 3)
        else
            echo そのサービス名は登録されていません．
        fi
        gpg --batch --yes --passphrase="$IPwd" -c secret.txt  #secretの暗号化
    elif [ "$Choice" = "Exit" ] ; then
        echo Thank you!
    else
        echo 入力が間違っています．Add Password / Get Password いずれかを入力してください．
    fi
done
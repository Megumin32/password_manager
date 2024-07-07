echo パスワードマネージャーへようこそ！
Choice=1
while [ $Choice != "Exit" ]
do
    echo "次の選択肢から入力してください(Add Password / Get Password / Exit)："
    read Choice
    if [ $Choice = "Add Password" ] ; then
        echo サービス名を入力してください：
        read SName
        echo ユーザー名を入力してください：
        read UName
        echo パスワードを入力してください：
        read Pswd
        echo $SName:$UName:$Pswd >> secret.txt
        echo パスワードの追加は成功しました．
    elif [ $Choice = "Get Password" ] ; then
        echo サービス名を入力してください．
        read SName
        CheckSName=$(grep $SName secret.txt | cut -d : -f 1)1
        if [ "$SName"1 = $CheckSName ] ; then
            echo サービス名：$SName
            echo ユーザー名：$(grep $SName secret.txt | cut -d : -f 2)
            echo パスワード：$(grep $SName secret.txt | cut -d : -f 3)
        else
            echo そのサービス名は登録されていません
        fi
    elif [ $Choice = "Exit" ] ; then
        echo Thank you!
    else
        echo 入力が間違っています．
    fi
done
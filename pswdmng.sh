echo パスワードマネージャーへようこそ！
Choice=1 #Choiceの初期値．Exit以外ならば何でもよい．
while [ $Choice != "Exit" ]
do
    echo "次の選択肢から入力してください(Add Password / Get Password / Exit)："
    read Choice
    if [ $Choice = "Add Password" ] ; then
        echo サービス名を入力してください：
        read Svs
        echo ユーザー名を入力してください：
        read Usr
        echo パスワードを入力してください：
        read Pwd
        echo $Svs:$Usr:$Pwd >> secret.txt
        echo パスワードの追加は成功しました．
    elif [ $Choice = "Get Password" ] ; then
        echo サービス名を入力してください．
        read Svs
        if [ $Svs = $(grep "^$Svs:" secret.txt | cut -d : -f 1) ] ; then #完全一致しているかのチェック
            echo サービス名：$Svs
            echo ユーザー名：$(grep "^$Svs:" secret.txt | cut -d : -f 2)
            echo パスワード：$(grep "^$Svs:" secret.txt | cut -d : -f 3)
        else
            echo そのサービス名は登録されていません．
        fi
    elif [ $Choice = "Exit" ] ; then
        echo Thank you!
    else
        echo 入力が間違っています．Add Password / Get Password いずれかを入力してください．
    fi
done
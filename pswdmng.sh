echo パスワードマネージャーへようこそ！

function fileDecrypt () { #復号（引数は $1->パスワード $2->ファイル名）
    gpg --batch --passphrase=$1 -d $2.txt.gpg > $2.txt 2> /dev/null 
}
function fileEncrypt () { #暗号化（引数は $1->パスワード $2->ファイル名）
    gpg --batch --yes --passphrase=$1 -c $2.txt  
}

if [ -e key.txt.gpg ] ; then
    read -p "パスワードマネージャーのパスワードを入力してください．>" thisPassword
    fileDecrypt $thisPassword key
    cat key.txt
    if [ $thisPassword = $(cat key.txt) 2> /dev/null ] ; then
        rm key.txt 
        option="start" #Exit以外ならなんでもよい
    else
        echo パスワードが違います．
        rm key.txt
        option="Exit"
    fi
else
    read -p "新規にパスワードを作成します．入力したらEnterを押してください．>" -s thisPassword
    echo $thisPassword > key.txt 2> /dev/null
    fileEncrypt $thisPassword "key"
    rm key.txt
    option="start" #Exit以外ならなんでもよい
fi

while [ "$option" != "Exit" ]
do
    rm secret.txt 2> /dev/null
    read -p "次の選択肢から入力してください(Add Password / Get Password / Exit)．>" option
    if [ "$option" = "Add Password" ] ; then
        read -p "サービス名を入力してください．>" serviceName
        read -p "ユーザー名を入力してください．>" userName
        read -p "パスワードを入力してください．>" servicePassword
        fileDecrypt $thisPassword "secret" 
        echo "$serviceName:$userName:$servicePassword" >> secret.txt
        fileEncrypt $thisPassword "secret" 
        echo パスワードの追加は成功しました．
    elif [ "$option" = "Get Password" ] ; then
        read -p "サービス名を入力してください．>" serviceName
        fileDecrypt $thisPassword "secret"
        if [ "$serviceName" = "$(grep "^$serviceName:" secret.txt | cut -d : -f 1)" ] ; then #入力したサービス名とsecret内のサービス名が完全一致しているかのチェック
            echo サービス名：$serviceName
            echo ユーザー名：$(grep "^$serviceName:" secret.txt | cut -d : -f 2)
            echo パスワード：$(grep "^$serviceName:" secret.txt | cut -d : -f 3)
        else
            echo そのサービス名は登録されていません．
        fi
        fileEncrypt $thisPassword "secret"
    elif [ "$option" = "Exit" ] ; then
        echo Thank you!
    else
        echo 入力が間違っています．Add Password / Get Password いずれかを入力してください．
    fi
done
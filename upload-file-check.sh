#!/bin/bash

#ディレクトリの数を確認
count=`ssh rionerelaypoint "cd ~/share; ls -1 | wc -l"`
for ((var = 1; var < $count + 1; var++))
do
  #一つ目のディレクトリから調べる
  VAR1=`ssh rionerelaypoint "cd ~/share; ls -t | sed -n ${var}P"`
  #ファイルサーバーに送るファイルの数を調べる
  uploadcount=`ssh rionerelaypoint "cd ~/share/$VAR1; ls -1 | wc -l"`
  #ファイルサーバーのどこに置くかを確認
  dlname=`ssh rionerelaypoint "cd ~/share/$VAR1; cat .absolutePathOfFileServer"`
  #ファイルの数だけループを回す
  for ((i=1 ; i < ${uploadcount} + 1 ; i++))
  do
    #送るファイルまたはディレクトリの名前を取得
    name=`ssh rionerelaypoint "cd ~/share/$VAR1; ls -t | sed -n ${i}P"`
    math=`ssh rionerelaypoint "cd ~/share/$VAR1; test -d $name"`
    if [ $math ] ; then
      echo "ディレクトリ"
      #ディレクトリを送る
      scp -i ~/.ssh/ri-oneFileServerRelayPoint.pem ec2-user@52.192.59.159:~/share/${VAR1}/${name} ${dlname}
    elif [ !$math ] ; then
      echo "ファイル"
      scp -i ~/.ssh/ri-oneFileServerRelayPoint.pem ec2-user@52.192.59.159:~/share/${VAR1}/${name} ${dlname}
      echo "成功"
    fi
  done
done

#!/bin/bash

DB_USER='root'
DB_PASSWD='mysql-123'
DB_NAME='my_database'
DB_HOST='172.17.0.2'

#sudo docker ps -a

#mysql -u root -h 172.17.0.2 -pmysql-123

# Haciendo ping a google
#ping -c4 google.com.mx

#mysqldump -u $DB_USER -h $DB_HOST -p$DB_PASSWD $DB_NAME > "backup_$(date +"%F_%T")".sql 

#xviewer > /dev/null 2>&1 & sleep 2

#/bin/xviewer $HOME/Documents/imagenes/* & /bin/sleep 3

#/bin/killall -9 /bin/xviewer

echo "Obteniendo nombres"
#/bin/curl -s https://names.drycodes.com/10\?nameOptions\=boy_names | tr -d [ | tr -d ] | tr "_" " " > data.txt
#/bin/curl -s https://names.drycodes.com/10\?nameOptions\=boy_names --output data.txt

function getRandomNames(){
        echo '' > names.tmp
        while [ "$(cat names.tmp | wc -l )" == "1" ]; do
                curl -s https://names.drycodes.com/10\?nameOptions\=boy_names | html2text > names.tmp
        done
        names=$(cat names.tmp)
        for name in $names; do
                echo $name
        done
}

function getImages(){
        echo '' > data.tmp

        while [ "$(cat data.tmp | wc -l )" == "1" ]; do
                curl -s https://unsplash.com/s/photos/linux | html2text > data.tmp
        done

        urls=$(cat data.tmp | grep "https://images" | tr -d [)
        i=1

        for url in $urls; do
                wget $url -O $i.png
                /bin/sleep 0.6
                if [[ $i -eq 3 ]]; then
                        break
                fi
                i=$(( $i +1))
        done
        rm data.tmp
}
echo "Creando la carpeta imagenes"
#rm -rf images
#mkdir images
#clear

echo "Obteniendo las imagenes"
#getImages

echo "Moviendo las imagenes a la carpeta images"
#mv *.png images/

echo "Abriendo una imagen random"
#/bin/xviewer images/$((1 + $RANDOM % 3)).png & /bin/sleep 3
echo "Cerrando la imagen"
#/bin/killall -9 /bin/xviewer


curl -s https://names.drycodes.com/\10\?nameOptions\=boy_names > names.tmp
names=$(cat names.tmp | tr -d [ | tr -d ] | tr "," "\n")

#mysqldump -u $DB_USER -h $DB_HOST -p$DB_PASSWD $DB_NAME

TABLE='users'

function insertData(){
mysql -u $DB_USER -h $DB_HOST -p$DB_PASSWD $DB_NAME <<EOF
INSERT INTO $TABLE (\`name\`) VALUES ($1);
EOF
}

echo "ingresando datos a la base de datos"
for name in $names; do
        newName=$(echo $name | tr "_" " ")
        echo $newName
        insertData "$newName" > /dev/null 2>&1
        /bin/sleep 0.123
done

rm names.tmp

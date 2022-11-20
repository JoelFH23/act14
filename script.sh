#!/bin/bash

DB_USER='root'
DB_PASSWD='mysql-123'
DB_NAME='my_database'
DB_HOST='172.17.0.2'
rm *.sql
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


#mysql -u root -h 172.17.0.2 -pmysql-123

# 1
echo  Haciendo ping a google
#ping -c2 google.com.mx

# 2
echo "Creando la carpeta imagenes"
rm -rf images
mkdir images
clear

# 3
echo "Obteniendo las imagenes"
#getImages

# 4
echo "Moviendo las imagenes a la carpeta images"
#mv *.png images/


# 5
echo "Abriendo una imagen random"
#/bin/xviewer images/$((1 + $RANDOM % 3)).png & /bin/sleep 3

# 6
echo "Cerrando la imagen"
#/bin/killall -9 /bin/xviewer

#xviewer > /dev/null 2>&1 & sleep 2
/bin/sleep 0.4

clear
TABLE='users'

function insertData(){
mysql -u $DB_USER -h $DB_HOST -p$DB_PASSWD $DB_NAME <<EOF
INSERT INTO $TABLE (\`name\`) VALUES ($1);
EOF
}

function getRandomNames(){
        curl -s https://names.drycodes.com/\10\?nameOptions\=boy_names > names.tmp
        names=$(cat names.tmp | tr -d [ | tr -d ] | tr "," "\n")
        for name in $names; do
                newName=$(echo $name | tr "_" " ")
                echo $newName
                /bin/sleep 0.123
        done
}

clear
# 7
echo "obteniendo datos aleatorios"
getRandomNames

function insertToDatabase(){
        names=$(cat names.tmp | tr -d [ | tr -d ] | tr "," "\n")
        for name in $names; do
                newName=$(echo $name | tr "_" " ")
                echo "Ingresando: $newName"
                insertData "$newName" > /dev/null 2>&1
                /bin/sleep 0.123
        done
        rm names.tmp
}

clear
# 8
echo "ingresando datos a la base de datos"
insertToDatabase

#mysqldump -u $DB_USER -h $DB_HOST -p$DB_PASSWD $DB_NAME

clear
# 9
echo "Creando Backup de la base de datos $DB_NAME"
mysqldump -u $DB_USER -h $DB_HOST -p$DB_PASSWD $DB_NAME > "backup_$(date +"%F_%T")".sql 

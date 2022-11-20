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

# 1
echo  Haciendo ping a google
ping -c2 google.com.mx

/bin/sleep 2
clear

# 3
echo "Abriendo navegador"
brave-browser https://unsplash.com/s/photos/linux & /bin/sleep 5
/bin/killall -9 brave > /dev/null 2>&1

# 3
echo "Creando la carpeta imagenes"
rm -rf images
mkdir images

/bin/sleep 2
clear

# 4
echo "Obteniendo las imagenes"
getImages

/bin/sleep 2
clear

# 5
echo "Moviendo las imagenes a la carpeta images"
mv *.png images/

/bin/sleep 2
clear

# 6
echo "Abriendo una imagen random"
/bin/xviewer images/$((1 + $RANDOM % 3)).png & /bin/sleep 3

/bin/sleep 2
clear

# 7
echo "Cerrando la imagen"
/bin/killall -9 /bin/xviewer

/bin/sleep 2
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

# 8
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

/bin/sleep 2
clear

# 9
echo "ingresando datos a la base de datos"
insertToDatabase


/bin/sleep 2
clear

# 10
echo "Creando Backup de la base de datos $DB_NAME"
mysqldump -u $DB_USER -h $DB_HOST -p$DB_PASSWD $DB_NAME > "backup_$(date +"%F_%T")".sql

/bin/sleep 2
clear

# 11
echo "Abriendo backup"
/bin/xed *.sql & /bin/sleep 4

/bin/killall -9 /bin/xed

/bin/sleep 2
clear

#12
echo "Listando los procesos"
/bin/ps -a

clear
/bin/sleep 0.6

# 13
echo "Creando index.html"
echo "<h1>Hello World</h1>" > index.html
brave-browser index.html & /bin/sleep 6
/bin/killall -9 brave
rm index.html
/bin/sleep 0.6

clear
# 14
echo "Listando todos los archivos"
lsd -la

/bin/sleep 3
clear

echo "Listando el /etc/passwd"
/bin/bat /etc/passwd & /bin/sleep 3

/bin/killall -9 /bin/bat

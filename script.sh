set -e

URL=https://raw.githubusercontent.com/jeromedecoster/dog/master
FILES=(xaa xab xac xad)
NAME=dog.jpg
MD5=11c36b1f9b769d787ee1da6b90984547

log() { echo -e "\033[0;4m${1}\033[0m ${@:2}"; }

[[ -f $NAME ]] && { log abort $NAME already exists; exit; }

CWD=$(pwd)
TEMP=$(mktemp --directory)

cd $TEMP
for file in "${FILES[@]}"
do
    log download $URL/$file
    if [[ -n $(which curl) ]]
    then
        curl $URL/$file \
            --location \
            --remote-name \
            --progress-bar
    else
        wget $URL/$file \
            --quiet \
            --show-progress
    fi
done

log merge xa*
cat xa* > $NAME

if [[ $(md5sum $NAME | cut -d ' ' -f 1) != $MD5 ]]
then
    log checksum error
fi

# check if $CWD is writable by the user
if [[ -z $(sudo --user $(whoami) --set-home bash -c "[[ -w $CWD ]] && echo 1;") ]]
then
    log warn sudo access is required
    sudo mv $NAME $CWD
else
    mv $NAME $CWD
fi

log complete $NAME successfully created

rm --force --recursive $TEMP

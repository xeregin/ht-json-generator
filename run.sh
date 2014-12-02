if [[ `ls devices` == "" ]]; then
    echo "Could not find 'devices' file!"
    echo "This script requires a list of Core device IDs, in a file named 'devices'..."
    exit
fi

for i in `cat devices | awk '{print $1}'`; do
    ht -i $i > $i.info
done

for i in `ls *.info`; do
    FILE_SIZE=$( wc -l $i | awk '{print $1}' )
    if [[ $FILE_SIZE == "6" ]]; then
        cat $i >> hammertime-info
    fi
done
rm *.info

# Use for root user
echo { > inventory-root.json
cat hammertime-info | sed '/^$/d' | sed '/Account/d' | sed '/Type/d' | sed '/User/d' | sed 's/.*: *//' | sed 's/ \/ /\//' | sed 's/.* //' | sed 's/\//\npassword": "/' | sed 's/^/    "/' | sed 's/$/"/' | sed 's/\.com"/\.com":{/' | sed 's/"10/    "ip": "10/' | sed 's/"root"/    "username": "root"/' | sed 's/"pass/    "pass/' | sed 's/\("ip".*\)/\1\,/' | sed 's/\("username".*\)/\1\,/' | sed 's/\("password".*\)/\1}/' | sed 's/\(password.*\)/\1\,/' | sed '$s/}\,/}/' >> inventory-root.json
echo } >> inventory-root.json

# Use for rack user
echo { > inventory-rack.json
cat hammertime-info | sed '/^$/d' | sed '/Account/d' | sed '/Type/d' | sed '/user/d' | sed 's/.*: *//' | sed 's/ \/ /\//' | sed 's/.* //' | sed 's/\//\npassword": "/' | sed 's/^/    "/' | sed 's/$/"/' | sed 's/\.com"/\.com":{/' | sed 's/"10/    "ip": "10/' | sed 's/"rack"/    "username": "rack"/' | sed 's/"pass/    "pass/' | sed 's/\("ip".*\)/\1\,/' | sed 's/\("username".*\)/\1\,/' | sed 's/\("password".*\)/\1}/' | sed 's/\(password.*\)/\1\,/' | sed '$s/}\,/}/' >> inventory-rack.json
echo } >> inventory-rack.json

rm hammertime-info

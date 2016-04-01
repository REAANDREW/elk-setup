echo "Add some todos"

curl -X POST -H 'Content-type:application/json' -d '{"text":"test 1","complete":false}' http://192.168.56.50:8000/api/v1/todos
curl -X POST -H 'Content-type:application/json' -d '{"text":"test 2","complete":false}' http://192.168.56.50:8000/api/v1/todos
curl -X POST -H 'Content-type:application/json' -d '{"text":"test 3","complete":false}' http://192.168.56.50:8000/api/v1/todos

echo
echo "See what todos we have"
curl http://192.168.56.50:8000/api/v1/todos

echo
echo "Make some updates and complete the last TODO"
href="$(curl -s http://192.168.56.50:8000/api/v1/todos | jq '.[length-1]' | jq -c '.links[] | select(.method=="put") | .href')"
href='${href/"//}'

curl -X PUT -H 'Content-type:application/json' -d '{"text":"TEXT UPDATED - updated","complete":false}' $href
curl -X PUT -H 'Content-type:application/json' -d '{"text":"TEST UPDATED - updated","complete":true}' $href

echo 
echo "Delete the todo if it is complete"
curl -X DELETE $href

echo
echo "See what todos we have"
curl http://192.168.56.50:8000/api/v1/todos

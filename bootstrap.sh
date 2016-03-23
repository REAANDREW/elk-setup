mkdir -p keys/{public,private}
ssh-keygen -t rsa -f keys/id_rsa
mv keys/id_rsa keys/private
chmod 400 keys/private/id_rsa
mv keys/id_rsa.pub keys/public



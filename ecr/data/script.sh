# Получаем актуальный SHA1 сертификата GitHub
CURRENT_SHA=$(echo | openssl s_client -connect token.actions.githubusercontent.com:443 2>/dev/null \
  | openssl x509 -fingerprint -sha1 -noout \
  | awk -F'=' '{print $2}' \
  | tr -d ':' \
  | tr 'A-Z' 'a-z')

# Записываем в файл, который потом читает Terraform
echo $CURRENT_SHA > ./data/github_thumbprint.txt




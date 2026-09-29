# Estado remoto do Terraform

O bucket de state deve ser criado uma única vez, com versionamento, criptografia e bloqueio de acesso público. Ele também deve nascer com a tag obrigatória `Project=Base_dos_Dados_Datalake`.

Como o nome do bucket e a região precisam ser definidos na conta do cliente, este diretório não cria automaticamente o backend antes dessa decisão. Após a criação, configurar o bloco `backend "s3"` no `terraform` raiz e executar `terraform init -migrate-state`.

Não excluir o bucket nem remover sua tag de projeto.

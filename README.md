# mpb-infra

Infraestrutura como código do Portal de Dados do Movimento pela Base.

## Guardrails obrigatórios do cliente

- Todo recurso tagueável deve nascer com `Project=Base_dos_Dados_Datalake`.
- O provider AWS usa `default_tags`; não sobrescrever nem remover a tag `Project`.
- O usuário de arquitetura não possui permissão de deleção nem de remoção de tags.
- Exclusões exigem solicitação ao administrador informando tipo, nome/ID, região e motivo.
- Roles, policies e instance profiles criados pelo projeto devem permanecer no path `/bdd-datalake/`.
- `iam:PassRole` é restrito ao path autorizado e aos serviços liberados pelo cliente.
- Não alterar o próprio usuário nem o grupo `bdd-datalake-architects`.
- Serviços habilitados incluem EC2, VPC, S3, ECR, Secrets Manager, SSM, CloudWatch/Logs, Load Balancers, ACM, Route 53, Backup, KMS e RDS. A V1 usa apenas o subconjunto necessário.


## Região AWS

A V1 utiliza `sa-east-1` (São Paulo) como região padrão. A decisão mantém a residência dos dados do projeto no Brasil como padrão conservador de governança. A LGPD não é documentada aqui como obrigação de hospedagem nacional. Mudanças de região exigem revisão arquitetural.

A conta é tratada como ambiente novo dentro do escopo disponibilizado ao projeto: a VPC, a subnet pública, o Internet Gateway, a tabela de rotas, o Security Group, a EC2, o EBS, o S3, o IAM e o monitoramento necessários à V1 são declarados por este repositório.

## Arquitetura V1

Uma EC2 executa Nginx, CKAN, PostgreSQL, Solr, Redis e DataPusher/XLoader via Docker Compose. Dados e backups duráveis vão para S3. A EC2 é administrada por SSM; não há SSH público. A V1 não cria RDS, ElastiCache, ECS/EKS, NAT Gateway, OpenSearch, MWAA, Multi-AZ ou ALB.

## Ordem segura de uso

1. Preencher `environments/production/terraform.tfvars` a partir do exemplo.
2. Configurar o backend remoto conforme `bootstrap/terraform-state/README.md`.
3. Executar `terraform init`.
4. Executar `terraform fmt -check` e `terraform validate`.
5. Executar `terraform plan -out=tfplan` e revisar tags e qualquer ação destrutiva.
6. Aplicar somente após revisão: `terraform apply tfplan`.

Nunca executar `terraform destroy` com as credenciais fornecidas ao projeto.

## Contribuição e automação

Consulte `CONTRIBUTING.md` para o fluxo baseado em Pull Request e
`.github/BRANCH_PROTECTION.md` para a ruleset recomendada. O workflow de CI
somente formata e valida a configuração offline; provisionamento permanece em
um fluxo de CD separado e não está habilitado nesta etapa.

## O que mudou e por quê

## Como foi validado

## Impacto

- Configuração alterada:
- Migração necessária: não / sim — detalhe abaixo
- Impacto em custo, segurança, persistência ou disponibilidade:
- Contratos afetados (`mpb-ckan` / `mpb-data-pipelines`):
- ADR necessário: não / sim — link abaixo

## Checklist

- [ ] `terraform fmt -check -recursive`
- [ ] `terraform init -backend=false -input=false`
- [ ] `terraform validate`
- [ ] O plano não executa deleções proibidas
- [ ] Nenhum segredo ou credencial foi versionado
- [ ] Não há `apply` ou `destroy` automatizado por este PR
- [ ] Documentação e contratos foram atualizados quando necessário

# Contribuição

O repositório usa desenvolvimento baseado em `main`: a branch é protegida e
toda mudança entra por Pull Request a partir de uma branch curta.

## Branches

Use `feature/<descricao>`, `fix/<descricao>`, `chore/<descricao>` ou
`docs/<descricao>`. Mantenha a branch pequena, atualize-a com `main` quando
necessário e remova-a após o merge. Não há branches permanentes `develop` ou
`release/*`.

## Validação local

```bash
terraform fmt -check -recursive
terraform init -backend=false -input=false
terraform validate
```

O CI executa apenas formatação, inicialização sem backend e validação. Aplicar
ou destruir infraestrutura exige fluxo de CD separado, revisão do plano e as
permissões IAM do cliente. Nunca adicione credenciais AWS, arquivos `.tfvars`
reais, state ou segredos ao repositório.

Mudanças de custo, segurança, persistência, disponibilidade, serviços AWS ou
fronteiras entre repositórios exigem revisão arquitetural e, quando alterarem
uma decisão existente, ADR.

Pull Requests abertos pelo Dependabot seguem os mesmos checks e revisão; não
há merge automático de atualizações.

# Playbooks Ansible para deploy do Brasil Participativo (Decidim) em Produção

Este repositório contém um conjunto de Playbooks Ansible para realizar o deploy do Brasil Participativo (Decidim) de um servidor linux em modo produção. 

Os serviços são configurados da seguinte maneira:
  - Postgres (docker container via docker compose)
  - Redis Cache and Redis Queue (docker container via docker compose)
  - Sidekiq (systemd service)
  - Puma (systemd service)
  - Nginx (systemd service)
  

Configurações gerais como o endereço do servidor de destino e o repositório e tag a serem usadas como base estão configuradas no arquivo `inventory/hosts.ini`.

```
[decidim_server_base]
servidor ansible_host=x.x.x.x ansible_user=admin_user

[all:vars]
admin_user=<admin_user>
regular_user=decide
repo_url=https://gitlab.com/lappis-unb/decidimbr/decidim-govbr.git
repo_tag=v1.1.10
```

Além disso, arquivos de configuração das variáveis de ambiente estão definidos na pasta `arquivos_de_ambiente` e não copiados para o servidor durante a execução dos playbooks.

O deploy foi testado nas distribuições `Debian 11` e `Debian 12`. 

O pré-requisito para executar os playbooks é:

1. Instalar o Ansible no computador `host` [Ansible Install](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
2. Configurar o servidor linux com usuário administrador (sudo) que seja acessível à partir do computador `host` via [SSH com chave](https://www.cyberciti.biz/faq/how-to-set-up-ssh-keys-on-linux-unix/).

A ordem de execução dos Playbooks é:

1. `instala_dependencias_ambiente.yaml`
2. `clona_projeto_e_arquivos.yaml`
3. `realiza_build_deploy.yaml`
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
3. Ajuste o arquivo `inventory/hosts.ini` com as configurações da sua maquina.

A ordem de execução dos Playbooks é:

1. `instala_dependencias_ambiente.yaml`
2. `clona_projeto_e_arquivos.yaml`
3. `realiza_build_deploy.yaml`

```bash
ansible-playbook -i inventory/hosts.ini instala_dependencias_ambiente.yaml && ansible-playbook -i inventory/hosts.ini clona_projeto_e_arquivos.yaml  && ansible-playbook -i inventory/hosts.ini realiza_build_deploy.yaml
```
# Configurando SSH na Sua Máquina Virtual (Opcional)

1. instale o [virtualbox](https://www.virtualbox.org/)

``` bash
sudo apt install virtualbox

```
2. Configuração de Rede no VirtualBox

Abra o VirtualBox e selecione a sua máquina virtual. Vá em "Configurações", clique na aba "Rede" e altere a conexão para o Modo Bridge.

> O Modo Bridge permite que a sua máquina virtual (VM) se conecte diretamente à rede física da sua máquina host, como se fosse outro dispositivo na mesma rede. Isso significa que a VM receberá um endereço IP diretamente do roteador, em vez de compartilhar o IP da máquina host.


3. Verifique o IP da Sua Máquina Virtual

``` bash
ifconfig

```

> O comando `ifconfig` lista todas as interfaces de rede ativas na sua máquina, juntamente com seus endereços IP. Procure pela interface correspondente à sua conexão de rede (geralmente algo como ethX ou enpXsY para conexões Ethernet, ou wlanX ou wlpXsY para conexões Wi-Fi) e anote o endereço IP listado.

> O endereço IP da interface de rede, que você precisa anotar, aparece logo após `inet`, `geralmente no formato 192.168.x.x`


4. instale o sudo openssh-server


``` bash
sudo apt install openssh-server

```
> O OpenSSH Server é um servidor que permite conexões SSH (Secure Shell) para a sua máquina. SSH é um protocolo que fornece uma conexão segura e criptografada entre duas máquinas, sendo amplamente usado para administração remota.

5. habilete o serviçõ de ssh


```
sudo systemctl enable --now ssh

```

Se tudo estiver configurado corretamente, você poderá se conectar à sua máquina virtual a partir da sua máquina host (ou qualquer outra máquina na mesma rede) usando o comando SSH:


```bash
ssh <nome_do_usuario>@<ip_da_VM>
```

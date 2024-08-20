ansible-playbook -i ./../inventory/hosts.ini ./../instala_dependencias_ambiente.yaml --ask-become-pass -vvv

ansible-playbook -i ./../inventory/hosts.ini ./../clona_projeto_e_arquivos.yaml --ask-become-pass -vvv

ansible-playbook -i ./../inventory/hosts.ini ./../realiza_build_deploy.yaml --ask-become-pass -vvv

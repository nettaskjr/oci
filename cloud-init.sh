#!/bin/bash
# Este script é executado pelo cloud-init na primeira inicialização da instância.
# Toda a saída será registrada em /root/cloud-init-output.log para facilitar a depuração. Utilize tail -f /root/cloud-init-output.log para acompanhar o progresso.
exec > >(tee /root/cloud-init-output.log|logger -t user-data -s 2>/dev/console) 2>&1

# Para o script imediatamente se um comando falhar.
set -e

echo "Aguardando a liberação do bloqueio do apt..."
# Em algumas imagens de nuvem, processos automáticos de atualização (como unattended-upgrades)
# podem bloquear o apt logo após a inicialização. Este loop espera que esse processo termine.
while fuser /var/lib/dpkg/lock* >/dev/null 2>&1 || fuser /var/lib/apt/lists/lock >/dev/null 2>&1 ; do
  echo "Outro processo apt está em execução. Aguardando 5 segundos..."
  sleep 5
done

# Atualiza o sistema e instala o curl
echo "Atualizando pacotes e instalando dependências..."
apt-get update 
apt-get dist-upgrade -y 
apt-get install -y curl

# Baixa, torna executável e roda o script de instalação principal a partir do repositório
echo "Baixando e executando script de setup..."
cd /root
curl -L -o install.sh https://raw.githubusercontent.com/nettaskjr/cloud-setup/refs/heads/main/install.sh 
chmod +x install.sh 
./install.sh 
cloud-setup/cloud-setup.sh -b -a nginx

echo "Nginx instalado. Criando página de teste..."

# Cria uma página de teste personalizada para o Nginx para confirmar a instalação
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Nginx - Teste</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f0f2f5; margin: 0; }
        .container { text-align: center; background-color: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        h1 { color: #009f6b; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Instalação Concluída!</h1>
        <p>Se você está vendo esta página, o Nginx foi instalado com sucesso na sua instância OCI via Terraform e cloud-init.</p>
    </div>
</body>
</html>
EOF

echo "Página de teste criada. Script de inicialização concluído com sucesso."
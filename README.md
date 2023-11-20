# Docker

## Introdução

### Objetivos

#### O que são Containers
Um container é um padrão de unidade de software que empacota código e todas as dependências de uma aplicação fazendo que a mesma seja executada rapidamente de forma confiável de um ambiente computacional para outro.
[What is a container](https://www.docker.com/resources/what-container/)


#### Como funcionam os Containers
O exemplo do sistema operacional vai ser Linux
Sistema operacional tem diversos processos e, em geral, existe processos para cada tarefa.
* **Namespaces**
    * Um processo sempre tem um **Namespaces** = Isola os processos
        * Isso significa que tem um processo pai com o namespace informado, e todos os processos oriundos do processo pai também terão o mesmo namespace. Ou seja, aquele conjunto de processos fazem referência àquele namespace.
    Por conta dos namespaces que foi possível trabalhar com containers, criando:
    * Processo pai Container 1
        * Processo filho Container 1
        * Processo filho Container 1
        * Processo filho Container 1
    * Processo pai Container 2
        * Processo filho Container 2
        * Processo filho Container 2
        * Processo filho Container 2

Os containers são processos que são isolados com filhos.

Tipos de processos para isolar processos como:
* Pid
* User
* Network
* File system

* **Cgroups:** controla os recursos computacionais do container
    * supondo que o processo em execução tem uma grande demanda de memória que acaba afetando os outros processos desse SO que estão fora do namespace. O CGroups isola os recursos computacionais desses processos informando que o processo pode usar:
        * memory = 500MB
        * cpu_shares = 512

* **File System:** OFS (Overlay File System)
    * Supondo que temos um container tem a aplicação MyApp:v1 que tem 70MB e para essa aplicação funcionar, preciso de duas dependências, sendo Dep 1 com 200MB e Dep 2 com 250MB.
    * O Docker utiliza o OFS que caso eu tenha que criar uma nova imagem da aplicação, por exemplo, MyApp:v2 eu não preciso tirar as dependências, porque elas já são utilizadas na aplicação anterior. O OFS trabalha com camadas (layers) e esses layers trabalham de forma individualizada. Pega a diferença do que foi atualizada e só guarda essa diferença. O que significa que não precisa guardar cópias inteiras do Sistema Operacional.
    **Obs.:** **snapshots** é uma cópia fiel daquela máquina para funcionar o todo

**Imagens:** as imagens são criadas a partir de camadas de dependências
* Supondo que temos uma imagem Scratch
    * É instalado o Ubuntu
        * Bash (uma camada que roda em cima do Ubuntu)
        * ssh.d(uma outra camada que roda em cima do Ubuntu)
            * MyApp:v1

* Acima temos diversas camadas de dependências, ou seja, o MyApp:v1 vai precisar do ssh.d, Ubuntu e do Scratch
* Caso a camada do Ubuntu tenha alguma vulnerabilidade, ele vai impactar toda a árvore de camadas.
* Todas as camadas acima são cobertas pela MyAppImage:v1
* Imagem é um conjunto de dependências encadeadas

**Dockerfile**
Uma das formas de criar imagens no Docker, é ter uma arquivo de definição de imagens onde é escrito como vai ser a imagem que vai ser construída.
O arquivo é criado
**FROM:** ImageName (falamos o nome da image e quando esse Dockerfile rodar, vamos baixar toda a imagem e as dependências dessa imagem)
**RUN:** Comandos ex: apt-get install (podemos customizar essa imagem, ou seja, quais comandos queremos rodar quando essa aplicação rodar)
**EXPOSE:** 8000 (portas que queremos expor essa imagem)
Um dockerfile serve apenas para modificar e construir essa imagem, caso a imagem não precise de modificações, não é necessário o dockerfile

Indo mais a fundo em um processo, nós temos uma imagem que é de **Estado Imutável** (ela não é alterada enquanto o container está rodando). Existe uma camada que é criada de **Read/Write** para fazer alterações no comportamento do container. Essa camada não altera a imagem.

A partir do **Dockerfile** -> **build** -> **Imagem**
Caso eu queira fazer mudanças eu posso pegar a **Imagem** fazer um **commit** e gerar a **Imagem:v2**.
Ou seja, há duas formas de criar imagem, uma a partir do dockerfile e o outro é pegar um container que já está rodando e escrever dentro dele e fazer um commit.

**Onde ficam as imagens?**
No **Image Registry**, que é como se fosse um repositório
* Image N
* Image Y
* Image X

Por exemplo, o **Dockerfile** faz um **pull** do **Image Registry** que tem o **ImageName**.
Quando **criamos uma nova imagem**, nós fazemos um **push** no **Image Registry**.
* ImageName:v2
* ImageName
* Image Y


#### Como o Docker funciona
O Docker fez uma solução onde integra namespace, Cgroups e File System que é o DockerHost

**DockerHost**
* **Network** (comunicação entre containers)
* **Volumes** (Containers são imutáveis, quando container morre, tudo se perde)
* **Cache** (quando faz pull do Image Registry ele guarda as imagens dentro do cache e quando faz push ele manda para o Registry)
* **daemon - API** (disponibilizado para manipular o docker)

* Docker Client: acessa o Docker Host com a daemon
    * faz as chamadas na API que: 
        * Cria Containers
        * Run, Pull, Push
        * Gerenciamento de Volumes
        * Network


## Conhecendo o WSL 2
Docker foi construído e pensado para Linux, não para Windows ou Mac.

Como se executava Docker no Windows?
* Docker Toolbox
    * Roda com VirtualBox
    * É lento

* Docker Desktop
    * Rodar com Hyper-V (tecnologia de virtualização da Microsoft, concorrente do VirtualBox)
    * Precisa da licença PRO do Windows
    * Exige mais recursos da máquina
    * Desempenho bem superior ao Toolbox

### WSL (Windows Subsystem for Linux)
#### WSL 1
* Ambiente Linux embarcado dentro do Windows
* Acesso a "quase" todos os comandos Linux
* Acessos aos drivers C, D e etc.
* Possibilidade de escolher distribuição do Linux: Debian, Ubuntu, OpenSuse, RedHat e etc.
* Manipulação através do terminal, não há GUI.

##### Problemas do WSL 1
* Não ter Kernel completo do Linux
* Desempenho ruim rodando aplicações dentro do Linux
* Não ter suporte ao Docker
* Vários problemas de compatibilidade com programas e ferramentas

#### WSL 2
* Execução completa do Kernel do Linux
* Manipulação através do terminal, não há GUI
* Grande desempenho executando aplicativos dentro do Linux
* Suporte ao Docker e Kubernetes
* Usa o Virtual Machine Platform como base para a execução

[Acesse o guia de instalação do WSL 2 e do Docker](https://github.com/codeedu/wsl2-docker-quickstart)


## Dicas truques com WSL2 e Windows Terminal
Para não travar o terminal, porque tem um servidor rodando:

**Obs.: Diferença entre terminal e Shell** - Shell é um programa que é usado para operar o Sistema Operacional para rodar comandos. O terminal é um agregado de Shell. O Windows nunca teve um terminal, só teve Shell que é o DOS e o PowerShell.

cd /mnt/c para acessar a pasta do Windows
cd /home/rafaelpeinado para acessar o Linux

explorer.exe . (para abrir a pasta no explorer)


**wsl -l -v** para listar as distribuições
**wsl --shutdown** para parar a execução de todas
**wsl** para entrar na distribuição padrão

arquivo **.wslconfig** para limitar o uso de recursos do computador
[wsl2]
memory=8GB
processors=6
swap=1GB

Instalar **Remote Development**


## Backup com WSL 2
É uma máquina virtual Linux
podemos acessar o %appdata% -> Local -> Packages -> CanonicalGroup (WSL 2) -> LocalState -> ext4.vhdx


## Integrando Docker com WSL 2
Docker Desktop -> Resources -> WSL Integration

**wsl -d "docker-desktop"** para escutar o docker-desktop


## Errata - Instalação do Docker no WSL/Windows
[Rodando Docker no WSL 2 sem Docker Desktop](https://www.youtube.com/watch?v=wpdcGgRY5kk)
[Docker Engine (Docker Nativo) diretamente instalado no WSL2](https://github.com/codeedu/wsl2-docker-quickstart#docker-engine-docker-nativo-diretamente-instalado-no-wsl2)


## Código-fonte
### Repositório
[Repositório](https://github.com/devfullcycle/fc-devops-docker)


## Iniciando com Docker
### Hello World
docker ps: comando para mostrar os containers que estão rodando na máquina
docker run hello-world

### Executando Ubuntu
docker run roda uma imagem. A imagem possui uma configuração chamada entrypoint ou command. Nesse entrypoint ele vai chamar o executável.

docker ps -a: mostra containers ativos e que já rodaram

docker run -it ubuntu bash
* docker run: roda alguma coisa
* -it: parâmetros (pode ser -i -t)
  * i: modo interativo: manter o stdin para manter o processo rodando
  * t: tty: é para poder digitar no terminal
* ubuntu: nome da imagem
  * como não coloquei ubuntu:<versao-da-imagem>, ele executará o ubuntu:latest
* bash: comando que vai ser executado no container depois que for baixado essa imagem

**Ctrl + D:** sai do container

* docker start <nome-do-container>: para iniciar algum container

**Obs.:** o container é um processo e se o que mantém do processo funcionando (nesse exemplo é o bash), o container cai.

* docker run -it --rm ubuntu bash
  * rm: quando o processo finalizar, o container será removido automaticamente


### Publicando portas com [nginx](https://www.nginx.com/)
[Proxy reverso](https://www.cloudflare.com/pt-br/learning/cdn/glossary/reverse-proxy/) que funciona como um servidor web comum.

* docker run nginx: ele disponibiliza a porta 80/tcp, porque é um web server
    * A porta não fica disponível para acessar pelo navegador, porém se tivéssemos um outro container seria possível acessá-lo. Não conseguimos, porque somos host e não estamos na rede Docker.

* docker run -p 8080:80 nginx
    * p: publica (significa um apontamento, um redirecionamento de porta) a porta que queremos usar com a máquina que está executando o Docker
    * **8080:80**: quando eu acessar a porta 8080 (http://localhost:8080/) da minha máquina, ele redirecionará para a porta 80 do container do nginx


* docker run -d -p 80:80 nginx (se eu rodar 80, basta eu executar http://localhost)
  * d: não trava o console, pois desassocia o processo do terminal


### Removendo containers
* docker stop <id-do-container>
* docker start <id-do-container>
* docker rm <id-do-container> ou docker rm <nome-do-container>
    * não é possível parar um container que está executando, sendo assim devemos parar o container e apagar ou forcá-lo com docker rm <nome-do-container> -f


### Acessando e alterando arquivos de um container
* docker run -d --name nginx nginx
    * name: para dar um nome ao container

* docker run --name nginx -d -p 8080:80 nginx
    * o nginx já está rodando e posso usar o comando **docker exec**

* docker exec <nome-do-container> ls
  * exec: para dar comandos a um container que já está rodando
  * ls: comando de listar

* docker exec -it nginx bash
  * cd /usr/share/nginx/html/
  * o index.html é o arquivo padrão

* **Obs.:** Para deixar o container o mais leve possível o cache do apt-get vem vazio, então é necessário fazer um update com **apt-get update** e então instalar o vim com **apt-get install vim**.
    * para edição precisa apertar i
    * esc para sair do modo insert
    * :w para write
    * :q para sair
    * Essas alterações que foram feitas dentro do container serão perdidas após matar o container, pois não é possível salvar na imagem, visto que ela é imutável.


### Iniciando com bind mounts
* Bind mounts montamos um volume que está no computador para dentro do container
* docker run --name nginx -d -p 8080:80 -v /home/peinado/html/:/usr/share/nginx/html nginx
    * v: com a ideia de montar um volume (um comando bem antigo e foi substituído por **--mount**)
    * se eu editar o html/index.html que foi criado no /home/peinado ele será exibido no navegador

É assim que mantemos o docker dentro do ambiente de desenvolvimento com php, nginx, python etc, mas o arquivo que estou mexendo está no meu computador e aí eu faço o bind para ver as mudanças.

* docker run --name nginx -d -p 8080:80 --mount type=bind,source="$(pwd)"/html,target=/usr/share/nginx/html nginx
  * type: é o tipo de mount
  * source: a origem dos arquivos
  * $(pwd): perca o caminho atual em que está, poderia usar o caminho completo também /home/peinado/html/
  * target: o caminho onde vamos enviar os arquivos

**Obs.:** quando usamos o -v, caso a pastar de origem não exista, ele cria no momento de fazer o direcionamento e quando usamos o --mount, ele dá erro, porque a pasta não existe.


### Trabalhando com volumes
O bind mount serve para montar a pasta de dentro do computador para dentro do container
Volumes é específico e conseguimos criar especificamente no Docker

* docker volume
* docker volume ls
* docker volume create meuvolume
* docker volume inspect meuvolume

* docker run --name nginx -d --mount type=volume,source=meuvolume,target=/app nginx
    * Se eu criar algum arquivo dentro da pasta app e criar um nginx2, esse arquivo será exibido no nginx2 também, pois estou compartilhando esse volume entre os dois container
* docker run --name nginx2 -d --mount type=volume,source=meuvolume,target=/app nginx
* docker run --name nginx3 -d -v meuvolume:/app nginx

As vezes estamos usando containers de terceiro e sistemas que acabamos configurando na nossa máquina e percebemos que a máquina está ficando lotada e não sabemos de onde vem os arquivos. Geralmente isso acontece quando o diretório de volume enchem e tudo o que não está sendo utilizado podemos fazer um prune.
* docker volume prune
  * mata tudo o que está dentro do volume

## Trabalhando com imagens
### Entendendo imagens e DockerHub
Tudo o que usamos no Docker são baseados em imagens (por exemplo: Ubuntu, nginx etc)
[DockerHub](https://hub.docker.com/), aqui é onde fica o Container Docker Registry. É onde ficam todas as imagens do Docker.
Os provedores de Cloud (AWS, Azure etc) têm o próprio Container Docker Registry e ficam armazenados de forma privada.

* docker images: consigo ver quais imagens estão no meu computador
* docker pull <nome-da-imagem>: baixa a imagem da máquina no computador
  * docker pull php
* docker pull php:rc-alpine
  * rc-alpine: é uma tag específica do php que pode ser encontrado no DockerHub
* docker rmi php:latest
  * rmi: para remover uma imagem

### Criando primeira imagem com Dockerfile
[Dockerfile](./Dockerfile)
Dockerfile define o passo a passo que precisa ser feito
As vezes precisamos fazer alteração de algum arquivo dentro da imagem, por exemplo, o nginx já com o vim instalado

* RUN apt-get install vim -y
  * RUN: executa um comando
  * -y: já confirma com sim quando fizer a instalação

* docker build -t rafaelpeinado/nginx-com-vim:latest .  Para gerar a imagem no Docker
  * -t: é o nome da imagem, no caso a tag
  * rafaelpeinado: é meu nome de usuário no DockerHub
  * .: para dizer que meu arquivo Docker file está na pasta atual

* docker images e podemos ver que temos a imagem rafaelpeinado/nginx-com-vim
* docker run -it rafaelpeinado/nginx-com-vim bash
* vim oi (e abrimos o vim)

### Avançando com Dockerfile
* **WORKDIR:** é o diretório que vou trabalhar dentro do container. Quando criar o container, ele vai criar uma pasta dentro do container.
* **COPY:** vai copiar a pasta html para a pasta html do nginx

Nesse caso já começou por padrão na pasta /app

* **USER**: o Dockerfile usa o root por padrão, mas podemos definir outros usuários

### ENTRYPOINT vs CMD
Depois de criar a imagem, precisamos fazer com que após que tudo tenha sido executado, precisamos fazer que algo execute para o processo funcionar.

* docker ps -a -q
  * q: exibe os IDs
* docker rm $(docker ps -a -q) -f

* docker run --rm rafaelpeinado/hello:latest echo "oi"
  * Substituiu o echo Hello World pelo oi
Quando informamos o docker run --rm rafaelpeinado/hello:latest **bash**, por exemplo, ele substitui tudo o que está no CMD pelo bash

* **CMD:** é varíavel e substituível
* **ENTRYPOINT:** é fixo
**Obs.:** O CMD entra como parâmetro para o ENTRYPOINT

* docker run --rm rafaelpeinado/hello:latest Rafael

### Docker entrypoint exec
Se eu quiser ver o entrypoint de alguma imagem, eu posso ir no DockerHub indo na imagem do [nginx](https://hub.docker.com/_/nginx) e clicar na tag que está usando, nesse caso o [latest](https://github.com/nginxinc/docker-nginx/blob/4bf0763f4977fff7e9648add59e0540088f3ca9f/mainline/debian/Dockerfile)

* **LABEL:** escrever maintainer, por exemplo
* **ENV:** para criar variáveis de ambiente
* **EXPOSE:** para expor a porta

No nginx temos o arquivos docker-entrypoint.sh que tem um exec $@"
* Todo arquivo sh que tiver **exec $@"** significa que ele vai aceitar os parâmetros que vai ser passado depois desse arquivo docker-entrypoint. Esse exec executa os parâmetros na execução do arquivo.
* docker run --rm -it nginx bash
* ./docker-entrypoint.sh echo "hello"
Isso quer dizer que se eu tirar o exec $@", o CMD não vai funcionar.

### Publicando imagem no DockerHub
* docker run --rm -d -p 8080:80 rafaelpeinado/nginx-fullcycle
* docker push rafaelpeinado/nginx-fullcycle

* https://hub.docker.com/r/rafaelpeinado/nginx-fullcycle
* https://hub.docker.com/u/rafaelpeinado

Se a imagem não tiver download por uns 90 dias, o Docker remove a imagem automaticamente do Hub.


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






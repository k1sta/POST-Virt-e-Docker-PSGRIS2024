# POST Virtualização e Docker - Olá, ARM!
Olá! Este *write-up* contém a solução para o POST da GET de Virtualização e Docker do processo seletivo do [GRIS (Grupo de Respostas a Incidentes de Segurança)](https://blog.gris.dcc.ufrj.br/) da Universidade Federal do Rio de Janeiro.

## Enunciado
Escreva um programa simples (Um "ola mundo" é suficiente) em C, porém ele é cross compiled de x86 pra ARM (qualquer ARM).
- Use o qemu para testar ele.
- Bote o binário de arm e o qemu dentro de um container docker.
- Faça um repositório no git para o projeto e teste que o container executa o aplicativo compilado para ARM
- Envie o link para o repositório (pode deixar público mesmo)

## Configurando o ambiente
A fim de realizar a compilação e teste do programa que será feito, temos que realizar a instalação dos seguintes programas:
- QEMU
- gcc-arm-linux-gnueabihf
- qemu-system-arm
- qemu-user
- gdb-multiarch

## Cross-Compiling o programa em C
Chamamos de *Cross-compiling* a ação de compilar um programa para uma arquitetura diferente da máquina que está realizando a compilação. Para isso, utilizaremos um *cross compiler*, o `gcc-arm-linux-gnueabihf`. Ele permite a compilação direta para a ARM64, que é o nosso objetivo.

Portanto, após sintetizar o programa:

```C
#include <stdio.h>

int main (void){
	puts("Olá, mundo! ARM? O que é isso?");
	return 0;
}
```

pude compilá-lo com o comando:

`arm-linux-gnueabihf-gcc olaMundo.c -o olaMundo -Wall`

Dessa maneira, temos, agora, um binário para arquiteturas ARM64 com o nosso programa!

## Testando o código através do QEMU
Para testá-lo, utilizei o QEMU através do comando:

`qemu-arm -L /usr/arm-linux-gnueabihf olaMundo`

E *voilà*!

![[Pasted image 20240223192418.png]]

## Montando a imagem do Docker
A imagem do Docker foi construída a partir de um [repositório](https://github.com/qemus/qemu-docker) existente. Fazendo as alterações necessárias, cheguei na seguinte Dockerfile:

```Dockerfile
FROM arm32v7/debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc-arm-linux-gnueabihf \
    crossbuild-essential-armhf \
    qemu-user \
    ca-certificates \
    libc6-dev-armhf-cross \
    && rm -rf /var/lib/apt/lists/*

COPY olaMundo.c .

RUN arm-linux-gnueabihf-gcc -o olaMundo olaMundo.c

CMD ["qemu-arm", "./olaMundo"]
```

## Bibliografia
[GitHub - WojciechMigda/how-to-qemu-arm-gdb-gtest: How to run, debug, and unit test ARM code on X86 ubuntu](https://github.com/WojciechMigda/how-to-qemu-arm-gdb-gtest)
[qemus/qemu-docker: QEMU in a docker container. (github.com)](https://github.com/qemus/qemu-docker)

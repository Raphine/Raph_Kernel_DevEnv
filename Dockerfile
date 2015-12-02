FROM ubuntu:14.04
RUN useradd raphine -m -s /bin/bash
RUN adduser raphine sudo
RUN echo "%raphine ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN apt-get update
RUN apt-get install -y git g++ make parted emacs language-pack-ja-base language-pack-ja
RUN update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
RUN source /etc/default/locale
WORKDIR /home/raphine
ADD config .ssh/
ADD raph_rsa .ssh/
RUN chmod 700 .ssh
RUN chown -R raphine:raphine .ssh
USER raphine
RUN git clone git@raphine:Raphine/Raph_Kernel.git


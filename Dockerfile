FROM ubuntu:14.04
RUN useradd raphine -m -s /bin/bash
RUN adduser raphine sudo
RUN echo "%raphine ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN apt-get update
RUN apt-get install -y git g++ make parted emacs
WORKDIR /home/raphine
ADD config .ssh/
ADD raph_rsa .ssh/
RUN chmod 700 .ssh
RUN chown -R raphine:raphine .ssh
USER raphine
RUN git clone git@raphine:Raphine/Raph_Kernel.git


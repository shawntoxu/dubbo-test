FROM xxx:5000/paas/ubuntu-sshd:1.0.2
ADD ./jdk1.8.0_131 ./app/soft/jdk1.8.0_131
ENV JAVA_HOME=/app/soft/jdk1.8.0_131
ENV LANG C.UTF-8
RUN echo 'PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc && \
    echo 'export PATH' >>  ~/.bashrc && \
    echo 'export JAVA_HOME=/app/soft/jdk1.8.0_131' >> /etc/profile && \
    echo 'PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile && \
    echo 'export PATH' >> /etc/profile


FROM ubuntu

# uncomment following line to use an http proxy
# RUN echo 'Acquire::http::Proxy "INSERT HTTP PROXY";' > /etc/apt/apt.conf

RUN apt update \
    && apt install -y firefox \
                      openssh-server \
                      xauth \
    && mkdir /var/run/sshd \
    && mkdir /root/.ssh \
    && chmod 700 /root/.ssh \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config \
    && grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config \
    && echo "root:root" | chpasswd

ENTRYPOINT ["sh", "-c", "/usr/sbin/sshd && tail -f /dev/null"]

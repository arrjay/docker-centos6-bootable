FROM upstream

RUN yum install -q -y dracut kernel kernel-devel dkms && \
    yum clean all && rm -rf /var/cache/yum && \
    find / -type d \( -name proc -o -name sys \) -prune -o -iname \*.rpmnew -exec rm {} \;

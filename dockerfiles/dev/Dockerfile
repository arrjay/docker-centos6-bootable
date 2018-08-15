FROM build/0common

MAINTAINER Compute Tools <id-computetools-team@palantir.com>

RUN yum install -q -y rpm-build && \
    yum clean all && rm -rf /var/cache/yum && \
    find / -type d \( -name proc -o -name sys \) -prune -o -iname \*.rpmnew -exec rm {} \;

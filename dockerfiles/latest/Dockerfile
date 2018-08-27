FROM build/0common

MAINTAINER Compute Tools <id-computetools-team@palantir.com>

# install packages
RUN yum install -q -y \
                 parted lvm2 cryptsetup xfsprogs \
                 openssh-server openssh-clients augeas \
                 selinux-policy-targeted \
                 cloud-init \
		 nvme-cli \
		 open-vm-tools \
                 sudo passwd chrony \
                 systemd-networkd systemd-resolved \
                 grub grub2-pc-modules grub2-tools grub2-efi-modules grub2-efi shim efibootmgr && \
    printf 'GRUB_DISABLE_OS_PROBER=true\n' >> /etc/default/grub && \
    yum clean all && rm -rf /var/cache/yum && \
    find / -type d \( -name proc -o -name sys \) -prune -o -iname \*.rpmnew -exec rm {} \;

# add dracut and modprobe config for additional drivers
ADD modprobe.d/* /etc/modprobe.d/
ADD dracut.conf.d/* /etc/dracut.conf.d/

# add udev config for stabilized madness
ADD etc-udev/* /etc/udev/

# reconfigure cloud-init the files to replace os-shipped and add things...
ADD cloud.cfg.d/* /etc/cloud/cloud.cfg.d/
# but this sed line should stop locale reconfiguration. because these images are not really for humans.
# we also shot datasource enumeration in oooold cloud init. eh.
RUN sed -i -e '/ - locale/d' \
     -e '/datasource_list/d' \
     -e '/ - apt-pipelining/d' \
     -e '/ - apt-configure/d' \
    /etc/cloud/cloud.cfg

# NO REALLY CLOUD-INIT STOPPIT. let's configure what we can for grub here, sure.
# this will likely need reconsideration in vmware.
RUN bash -c 'set -eux ; \
     f="/etc/default/grub" ; \
     c="nomodeset quiet net.ifnames=0 network-config=e2NvbmZpZzogZGlzYWJsZWR9" ; \
     sed -i -e "/^GRUB_CMDLINE_LINUX_DEFAULT=/d" "${f}" && \
     printf "GRUB_CMDLINE_LINUX_DEFAULT=\"%s\"\n" "${c}" >> "${f}"'

# when/if we run grub-install
ADD grub.d/* /etc/grub.d/

# custom script to dump platform info to a directory for systemd hooks
ADD platform-info/platform-info.sh      /usr/local/sbin/platform-info.sh

# image installation scripts
ADD /scripts /scripts

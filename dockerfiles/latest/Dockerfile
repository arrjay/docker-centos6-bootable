FROM centos:6

MAINTAINER RJ Bergeron <rbergero@gmail.com>

# install packages
RUN yum -y install hostname parted lvm2 cryptsetup mdadm xfsprogs \
                   grub grub2-tools grub2 grub2-efi grub2-efi-modules \
                   grub2-efi-ia32 grub2-efi-ia32-modules \
                   shim efibootmgr \
                   augeas \
                   selinux-policy-targeted \
                   NetworkManager openssh-server openssh-clients cloud-init \
                   sudo extendroot passwd authconfig epel-release chrony \
                   systemd-networkd \
                   smartmontools ethtool lm_sensors usbutils \
                   vim-minimal \
                   tboot \
                   kernel \
                   terminus-fonts-console fbset \
                   tmux \
                   && \
    yum clean all && rm -rf /var/cache/yum &&\
    find / -type d \( -name proc -o -name sys \) -prune -o -iname \*.rpmnew -exec rm {} \;

# add grub bits
ADD default-grub /etc/default/grub

# add vconsole config
ADD vconsole.conf /etc/vconsole.conf

# add user
RUN groupadd -g 1024 ejusdem && \
    useradd --uid 1024 --gid 1024 ejusdem && \
    usermod -G wheel ejusdem

# reconfigure sudo
RUN bash -c 'autosudo=$(mktemp) && \
    printf \#\!/bin/bash\\nsed\ -i\ -e\ \"s@^%%wheel.*@%%wheel\ ALL=\(ALL:ALL\)\ NOPASSWD:\ ALL@\"\ \${2} > "${autosudo}" && \
    chmod +x "${autosudo}" && \
    env EDITOR="${autosudo}" visudo && \
    rm "${autosudo}"'

# when/if we run grub-install
ADD grub.d/* /etc/grub.d/

# add drivers to initramfs
RUN echo 'add_drivers+=" nouveau vfio-pci "' >> /etc/dracut.conf

# reconfigure cloud-init
RUN sed -i -e '/ - locale/d' /etc/cloud/cloud.cfg
ADD /cloud.cfg.d /etc/cloud/cloud.cfg.d

# custom script to dump platform info to a directory for systemd hooks
ADD platform-info/platform-info.service /etc/systemd/system/platform-info.service
ADD platform-info/platform-info.sh      /usr/local/sbin/platform-info.sh

# disable smartd on virtual hosts
ADD smartd.service.d /etc/systemd/system/smartd.service.d

# service to start console if we find a hvc0 console *shrug*
ADD hvc0-console.service /etc/systemd/system/hvc0-console.service

# image installation scripts
ADD /scripts /scripts

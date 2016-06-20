FROM  gentoo/stage3-amd64
MAINTAINER Josh Cox <josh 'at' webhosting.coop>

ENV PACKAGES vim colordiff

RUN useradd git; mkdir /home/git;chown git. /home/git; \
mkdir /usr/portage

RUN emerge-webrsync; for d in /etc/portage/package.*; do touch $d/zzz_autounmask; done ; \
emerge --autounmask-write $PACKAGES; \
etc-update --automode -5; \
emerge $PACKAGES ; \
rm -Rf /usr/portage; \
rm -Rf /portage

CMD ["/bin/bash"]

FROM jupyter/scipy-notebook:latest AS deploy
# this is a Jupyter-notebook install that will work with canfar.net... also works as an xterm desktop container
USER root
RUN apt upgrade -y
RUN apt update -y

# system settings and permissions
COPY src/nofiles.conf /etc/security/limits.d/
COPY src/nsswitch.conf /etc/
RUN apt-get -y install	sssd-ad 
RUN apt-get -y install	sssd-tools 
# put the standard start up script into place
COPY src/startup.sh /skaha/startup.sh
# see https://bugzilla.redhat.com/show_bug.cgi?id=1773148
RUN touch /etc/sudo.conf && echo "Set disable_coredump false" > /etc/sudo.conf

# packages needed for a good iraf environment
RUN apt-get -y install	gcc  
RUN apt-get -y install	curl 
RUN apt-get -y install	xterm 
RUN apt install -y xrdp
RUN apt-get -y install	vim 
RUN apt-get -y install	adcli 
RUN apt-get -y install	git 
RUN apt-get -y install	parallel 
RUN apt-get -y install	realmd 
RUN apt-get -y install	emacs 
RUN apt-get -y install	gfortran 
RUN apt-get -y install  python3.9 pip 
RUN apt-get -y install	libx11-dev 
RUN apt-get -y install	libxpa-dev 
RUN apt-get -y install	xpa-tools 
RUN apt-get -y install	iraf 
RUN apt-get -y install	python3-pyds9 

# installs needed for X11 IRAF
RUN apt install -y make bison flex libncurses-dev tcl-dev
RUN apt install -y libxaw7-dev libxmu-dev xaw3dg-dev libxpm-dev
RUN apt install -y iraf-dev

COPY src/x11iraf-2.1.tar.gz /opt/x11iraf-2.1.tar.gz
WORKDIR /opt
RUN tar xzf x11iraf-2.1.tar.gz
WORKDIR /opt/x11iraf-2.1/
RUN make
RUN make install

# put the initialization of IRAF into the global setup
COPY src/iraf.sh /etc/profile.d/

# RUN pip install for various things I like to have
RUN pip install scipy numpy vos cadctap cadcdata astropy matplotlib ephem 
RUN pip install pyraf stsci.tools==3.6.0
RUN pip install mp_ephem
RUN pip install pandas

# get a good version of ds9
RUN curl https://ds9.si.edu/download/ubuntu20/ds9.ubuntu20.8.2.1.tar.gz -o ds9.ubuntu20.8.2.1.tar.gz ; tar zxf ds9.ubuntu20.8.2.1.tar.gz  ; mv ds9 /usr/bin/ds9 ; rm ds9.ubuntu20.8.2.1.tar.gz

# Two build sets, deploy and test
# Stuff here below here is for setting up a test user that sort of looks like a canfar science portal user
FROM deploy as test
RUN groupadd -g 1001 jkavelaars && useradd -u 1001 -g 1001 -s /bin/bash --home-dir /arc/home/jkavelaars --create-home jkavelaars
WORKDIR /arc/home/jkavelaars
USER jkavelaars
ENV HOME=/arc/home/jkavelaars
ENTRYPOINT [ "/skaha/startup.sh" ]

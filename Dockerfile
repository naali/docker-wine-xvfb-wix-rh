FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:wine/wine-builds
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get upgrade -y
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
RUN apt-get install -y --install-recommends wine-staging \
  curl \
  xvfb \
  unzip \
  winetricks
RUN useradd -d /home/wix -m -s /bin/bash wix
USER wix
WORKDIR /wix
ENV HOME /home/wix
ENV WINEPREFIX /home/wix/.wine
ENV WINEARCH win32
RUN printf "\nexport PATH=\${PATH}:/opt/wine-staging/bin\n" >> ~/.bashrc
RUN winecfg && wine cmd.exe /c echo '%ProgramFiles%' && sleep 5
RUN wine wineboot && xvfb-run winetricks --unattended dotnet40 corefonts

RUN curl -L -o /tmp/wix.zip https://github.com/wixtoolset/wix3/releases/download/wix3111rtm/wix311-binaries.zip
RUN unzip /tmp/wix.zip -d ~/wix
RUN rm /tmp/wix.zip

RUN curl -L -o /tmp/resource_hacker.zip http://www.angusj.com/resourcehacker/resource_hacker.zip
RUN unzip /tmp/resource_hacker.zip ResourceHacker.exe -d ~/wix
RUN rm /tmp/resource_hacker.zip

# Update system and install main dependencies
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
  apt-get update -y && \
  apt-get install -y --no-install-recommends wget unzip &&\
  apt-get install -y google-chrome-stable

# Chromedriver Environment variables
export CHROMEDRIVER_DIR=/usr/bin

# Download and install Chromedriver
chrome_version=$(google-chrome-stable --version | awk -F'[ \.]' '{ print $3 }') && \
  chromedriver_version=$(curl http://chromedriver.storage.googleapis.com/LATEST_RELEASE_${chrome_version}) && \
  echo $chromedriver_version && \
  wget -q --continue -P $CHROMEDRIVER_DIR "http://chromedriver.storage.googleapis.com/${chromedriver_version}/chromedriver_linux64.zip" && \
  unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR && \
  rm $CHROMEDRIVER_DIR/chromedriver*.zip

# Development tools
apt-get update && \
  apt-get install -y apt-transport-https && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  # for build vim
  python-dev libncurses5-dev libncursesw5-dev \
  python3-dev ruby-dev lua5.1 liblua5.1-dev \
  zsh silversearcher-ag locales sudo less netcat-openbsd \
  && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

chsh --shell /bin/zsh && \
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen && \
  groupadd --gid 1000 docker && \
  useradd --gid 1000 --uid 1000 --create-home docker && \
  echo "docker ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
  chmod 0440 /etc/sudoers.d/user && \
  # build vim
  cd /tmp && \
  git clone https://github.com/vim/vim.git && \
  cd /tmp/vim && \
  ./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-rubyinterp=yes \
    --enable-pythoninterp=yes \
    --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
    --enable-python3interp=yes \
    --with-python3-config-dir=/usr/lib/python3.4/config-3.4m-x86_64-linux-gnu \
    --enable-luainterp=yes \
    --enable-cscope \
  && \
  make && \
  make install && \
  cd ~ && \
  rm -rf /tmp/*

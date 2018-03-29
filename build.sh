# add-apt-repository -y ppa:nginx/stable
# sed -i '/deb-src/s/^# //g' /etc/apt/sources.list.d/nginx-stable-trusty.list # to get the nginx source 
apt update
apt install -y wget dpkg-dev libssl-dev libpcre3-dev gcc make zlib1g-dev

NGINX_PATH='/opt/nginx'
LUA_MOD_VER='0.10.11'
LUAJIT_VER='2.0.5'
NGX_DEVKIT_VER='0.3.1rc1'
NGINX_VER='1.12.2'

cd /tmp/
mkdir luaforngx && cd luaforngx

wget http://luajit.org/download/LuaJIT-${LUAJIT_VER}.tar.gz -O luajit-${LUAJIT_VER}.tar.gz
wget https://github.com/simpl/ngx_devel_kit/archive/v${NGX_DEVKIT_VER}.tar.gz -O ngx_devel_kit-${NGX_DEVKIT_VER}.tar.gz
wget https://github.com/openresty/lua-nginx-module/archive/v${LUA_MOD_VER}.tar.gz -O lua-nginx-module-${LUA_MOD_VER}.tar.gz
wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O nginx-${NGINX_VER}.tar.gz

tar xzf luajit-${LUAJIT_VER}.tar.gz
tar xzf lua-nginx-module-${LUA_MOD_VER}.tar.gz
tar xzf ngx_devel_kit-${NGX_DEVKIT_VER}.tar.gz
tar xzf nginx-${NGINX_VER}.tar.gz
rm -f *.tar.gz

cd LuaJIT-${LUAJIT_VER} && make install && cd ..
NGX_DEVKIT_PATH=$PWD/ngx_devel_kit-${NGX_DEVKIT_VER}
LUA_MOD_PATH=$PWD/lua-nginx-module-${LUA_MOD_VER}

cd nginx-${NGINX_VER} && \
    LUAJIT_LIB=/usr/local/lib/lua LUAJIT_INC=/usr/local/include/luajit-${LUAJIT_VER%.*} \
    ./configure --prefix=${NGINX_PATH} --conf-path=${NGINX_PATH}/nginx.conf --pid-path=/var/run/nginx.pid \
    --sbin-path=/usr/sbin/nginx --lock-path=/var/run/nginx/lock \
    --with-ld-opt='-Wl,-rpath,/usr/local/lib/lua' \
    --add-module=${NGX_DEVKIT_PATH} --add-module=${LUA_MOD_PATH} \
    && make -j2 && make install && ldconfig

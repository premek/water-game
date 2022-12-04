#TODO checksums
TMP="/tmp/lovestarter"

if [ "$1" = "cleanDeps" ]; then
    echo "This will delete everything in src/lib... [enter / Ctrl+C]"
    read
    rm -r src/lib/*
    rm -r "$TMP"
    exit $?
fi

mkdir -p "$TMP"
mkdir -p src/lib

function single {
    local url="$1"
    local basename=$(basename "$url")
    wget -nc -O "src/lib/$basename" "$url"
}

function arch {
  local file="$1"
  local strip="$2"
  local url="$3"
  local basename=$(basename "$url")
  wget -nc -O "$TMP/$basename" "$url"
  tar -C "src/lib" --strip-components=$strip -xvzf "$TMP/$basename" "$file"

}

single https://raw.githubusercontent.com/orangeturtle739/luafmt/2aefa3bfc2b250113c300c24085c62876dc329e0/luafmt.lua

single https://raw.githubusercontent.com/rxi/json.lua/11077824d7cfcd28a4b2f152518036b295e7e4ce/json.lua
#single https://raw.githubusercontent.com/rxi/autobatch/v0.1.1/autobatch.lua
#single https://raw.githubusercontent.com/rxi/lovebird/e84abe7b56a65ccb3ec6288e1955b6d772d41431/lovebird.lua
#single https://raw.githubusercontent.com/rxi/lurker/v1.0.1/lurker.lua
#single https://raw.githubusercontent.com/rxi/lume/v2.3.0/lume.lua
single https://raw.githubusercontent.com/rxi/classic/e5610756c98ac2f8facd7ab90c94e1a097ecd2c6/classic.lua
single https://raw.githubusercontent.com/kikito/inspect.lua/v3.1.2/inspect.lua
single https://raw.githubusercontent.com/premek/inspect-print.lua/v1.0.0/inspect-print.lua
single https://raw.githubusercontent.com/premek/love-ase-pal/7598b62f30bd9f82544f9fdeda15ff1297556c34/palease.lua
#single https://raw.githubusercontent.com/kikito/anim8/v2.3.1/anim8.lua
#single https://raw.githubusercontent.com/vrld/hump/3ac246dd33501e0a1b20d0318dedba16782fb1d5/gamestate.lua
single https://raw.githubusercontent.com/vrld/hump/0dea46b0b5c48ff4ccfe9037dbd44e28ffe76852/vector.lua
#single https://raw.githubusercontent.com/bjornbytes/cargo/b93228f36cd85699a2e12506c961f341b2e4d4b0/cargo.lua
#single https://raw.githubusercontent.com/premek/require.lua/v1.0.0/require.lua
#single https://raw.githubusercontent.com/bakpakin/tiny-ecs/1.3-3/tiny.lua
#single https://raw.githubusercontent.com/airstruck/knife/8e5ad88d049b549d5ef28bd5e0f6fbbc7193d2fa/knife/system.lua

#single https://raw.githubusercontent.com/rm-code/screenmanager/2.1.1/ScreenManager.lua
#single https://raw.githubusercontent.com/rm-code/screenmanager/2.1.1/Screen.lua

#arch "Simple-Tiled-Implementation-1.2.3.0/sti/" 1 https://github.com/karai17/Simple-Tiled-Implementation/archive/refs/tags/v1.2.3.0.tar.gz

single https://raw.githubusercontent.com/kyleconroy/lua-state-machine/2.0.0/statemachine.lua

echo

for F in src/img/*png; do
  optipng -strip all "$F"
done

# remove lines with absolute path to image
for F in src/img/*json; do sed -i '/"image"/d' "$F"; done

for f in src/*.lua ; do 
    lua src/lib/luafmt.lua --f "$f" 120
    luacheck "$f" --globals love
done

for F in src/img/*png; do
  optipng -strip all "$F"
done

for f in src/*.lua ; do 
    lua src/lib/luafmt.lua --f "$f" 120
    luacheck "$f" --globals love

done

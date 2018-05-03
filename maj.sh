if [[ "x$USER" == "xsylvain" ]]; then
    login=boulme
else
    login="$USER"
fi
make admin
git commit -a -m "opam update"
git pull
git push

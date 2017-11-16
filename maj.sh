if [[ "x$USER" == "xsylvain" ]]; then
    login=boulme
else
    login="$USER"
fi
make deps
make admin
git commit -a -m "opam update"
git pull
git push
ssh ${login}@ssh-veri.imag.fr "cd /import/www/PEOPLE/boulme/opam-vpl/ ; ./update.sh"

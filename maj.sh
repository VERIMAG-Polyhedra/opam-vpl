make deps
make admin
git commit -a -m "opam update"
git pull
git push
ssh ssh-veri.imag.fr "cd /import/www/PEOPLE/boulme/opam-vpl/ ; ./update.sh"

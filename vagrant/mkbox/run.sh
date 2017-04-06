#!/bin/bash


set -e # abort on error.

# ensures that I run in my directory
myselfdir="$(dirname $0)"
cd "$(myselfdir)"

# vagrant init ubuntu/xenial64
vagrant up --provider virtualbox
vagrant ssh <<EOF

# INSTALL SCRIPT on ubuntu/xenial64 box
set -e
sudo apt-get update
sudo locale-gen fr_FR.UTF-8
sudo apt-get install -y opam m4 libgmp-dev

# START INSTALL GLPK
# sudo apt-get install -y libltdl-dev   # for glpk with --enable-dl
wget http://ftp.gnu.org/gnu/glpk/glpk-4.61.tar.gz
tar zxf glpk-4.61.tar.gz
cd glpk-4.61/
./configure --with-gmp # --enable-dl   # is it needed ?
make
sudo make install
cd ..
sudo ldconfig
rm -rf glpk-4.61*
# END INSTALL GLPK

# START OPAM INSTALL vpl-core
opam init -a
opam config env
opam install -y depext
opam depext -y zarith
opam install -y zarith
opam repo add vpl http://www-verimag.imag.fr/~boulme/opam-vpl
opam depext -y vpl-core
opam install -y vpl-core
# END OPAM INSTALL vpl-core

# START INSTALL coq-vpltactic
opam install -y coq
opam install -y coq-vpltactic
# END INSTALL coq-vpltactic

# START INSTALL coqide
opam depext -y coqide
opam install -y coqide
# END INSTALL coqide

EOF


# VARIOUS TESTS

vagrant ssh <<EOF
set -e

cp /vagrant/test.v .
coqc test.v
rm -f test.glob test.vo

mkdir -p .local
mkdir -p .local/share
rm -rf .config
cp -r /vagrant/coq_config .config
EOF

rm -f ../vpl.box
vagrant package --output ../vpl.box

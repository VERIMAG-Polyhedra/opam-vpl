#!/bin/bash

COQFILE=test.v
set -e # abort on error.

# vagrant init ubuntu/xenial64
vagrant up --provider virtualbox
vagrant ssh <<EOF

# INSTALL SCRIPT on ubuntu/xenial64 box
set -e
sudo apt-get update
sudo locale-gen fr_FR.UTF-8
sudo apt-get install -y opam m4 libgmp-dev

# START INSTALL GLPK
sudo apt-get install -y libltdl-dev   # for glpk with --enable-dl
wget ftp://ftp.gnu.org/gnu/glpk/glpk-4.61.tar.gz
tar zxf glpk-4.61.tar.gz
cd glpk-4.61/
./configure --with-gmp --enable-dl   # is it needed ?
make
sudo make install
cd ..
sudo ldconfig
rm -rf glpk-4.61*
# END INSTALL GLPK

# START OPAM INSTALL
opam init -a
opam config env
opam install -y depext
opam depext -y zarith
opam install -y zarith
opam repo add vpl http://www-verimag.imag.fr/~boulme/opam-vpl
opam depext -y vpl-core
opam install -y vpl-core
opam install -y coq
opam install -y coq-vpltactic
# END OPAM INSTALL

# START TEST COQ VPLTACTIC
echo "Require Import VplTactic.Tactic." > ${COQFILE}
echo "Add Field Qcfield: Qcft (decidable Qc_eq_bool_correct, constants [vpl_cte])." >> ${COQFILE}
echo "" >> ${COQFILE}
echo "Lemma ex_intro (x: Qc) (f: Qc -> Qc):" >> ${COQFILE}
echo "  x <= 1" >> ${COQFILE}
echo "  -> (f x) < (f 1)"  >> ${COQFILE}
echo "  -> x < 1." >> ${COQFILE}
echo "Proof." >> ${COQFILE}
echo "  vpl_oracle a." >> ${COQFILE}
echo "  vpl_compute a." >> ${COQFILE}
echo "  vpl_post." >> ${COQFILE}
echo "Qed." >> ${COQFILE}

coqc ${COQFILE}
rm -f test.glob test.vo
# END TEST COQ VPLTACTIC

# START INSTALL coqide
opam depext -y coqide
opam install -y coqide

EOF


# TEST coqide on the virtualbox

vagrant ssh -- -X <<EOF
coqide ${COQFILE} 
EOF

rm -f ../vpl.box
vagrant package --output ../vpl.box

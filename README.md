# Opam repository for VPL packages

## Installing the [opam](https://opam.ocaml.org/) packages of the [VPL](https://github.com/VERIMAG-Polyhedra/VPL)

First, install the [external dependencies](https://github.com/VERIMAG-Polyhedra/VPL/blob/master/README.md#installation) of VPL.

Then, add the following repository in your opam system:

    opam repo add vpl https://raw.githubusercontent.com/VERIMAG-Polyhedra/opam-vpl/master

At last, install the following packages (depending on your needs):

* `vpl-core`: the ocaml library

    ```
    opam install vpl-core
    ```
     
* `coq-vpl`: the coq library

    ```
    opam install coq-vpl
    ```

* `coq-vpltactic`: the coq plugin (also install `coq-vpl` and `vpl-core`)

    ```
    opam install coq-vpltactic
    ```

## Using the [VPL](https://github.com/VERIMAG-Polyhedra/VPL) on a [vagrant](http://www.vagrantup.com/)/[virtualbox](http://www.virtualbox.org/) virtual machine

Installing the libraries required by the [VPL](https://github.com/VERIMAG-Polyhedra/VPL) Library with the appropriate version might not be easy in your environment. We propose here some alternatives. Alternative 1, try the VPL in a pre-built virtual machine emulating a Ubuntu-64 bits. Alternative 2, the [script](https://github.com/VERIMAG-Polyhedra/opam-vpl/blob/master/vagrant/mkbox/run.sh) that we use to configure this machine, may help you for an opam install on a Ubuntu.

For alternative 1, you need to have virtualization activated in your BIOS (on linux, you should have a `/dev/kvm` device). 
Then, you need to install [vagrant](http://www.vagrantup.com/) with [virtualbox](http://www.virtualbox.org/).
On Ubuntu you may simply run:

    sudo apt-get install virtualbox vagrant
 
Then, create a directory to store the files of the virtual machine and download this [Vagrantfile](http://www-verimag.imag.fr/~boulme/opam-vpl/vagrant/usebox/Vagrantfile) in it. In other words, do something like:

    mkdir vagrant_test/
    cd vagrant_test/
    wget http://www-verimag.imag.fr/~boulme/opam-vpl/vagrant/usebox/Vagrantfile
    
You can now boot the vagrant box (aka the virtual machine) by the following command (this may take a while on the first time).

    vagrant up
    
When, the box is ready, you connect on it through ssh

    vagrant ssh

or better, if you have a X server:

    vagrant ssh -- -X

In principle, you can now run commands like `ls` in the box (you are here connected as `ubuntu` user):

    ubuntu@ubuntu-xenial:~$ ls
    test.v

Thus, if you have the X connection, you can run [`coqide`](https://coq.inria.fr/refman/Reference-Manual018.html)
on `test.v`, a test file for the [VplTactic](https://github.com/VERIMAG-Polyhedra/VplTactic) described 
[here](https://github.com/VERIMAG-Polyhedra/VplTactic/blob/master/README.md#using-vpltactic).

    coqide test.v &

Just type `exit` to quit the ssh connection, and halt or suspend the machine by `vagrant halt` or  `vagrant suspend` 
(see [vagrant doc](https://www.vagrantup.com/docs/cli) for details). In order to clean the box, run

    vagrant destroy -f          # remove your version of the box 
    vagrant box remove vpl.box  # remove the box downloaded from verimag

Of course, through `vagrant ssh` you can modify your box (e.g. through `sudo apt-get install`), install files from your computer on it, etc
(see [vagrant doc](https://www.vagrantup.com/docs/) for details).

## Rebuilding our vagrant box

See directory `vagrant/mkbox` (file `run.sh`). Directory `vagrant/usebox` contains the vagrant file to download and use the pre-built box.

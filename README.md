# Opam repository for VPL packages

First, add the following repository in your opam system:

    opam repo add vpl https://github.com/VERIMAG-Polyhedra/opam-vpl

Then, install only one of the following package (depending on your needs):

* `vpl-core`: the ocaml library

    ```
    opam install vpl-core
    ```
     
* `coq-vpl`: the coq library (also install `vpl-core`)

    ```
    opam install coq-vpl
    ```

* `coq-vpltactic`: the coq plugin (also install `coq-vpl`)

    ```
    opam install coq-vpltactic
    ```

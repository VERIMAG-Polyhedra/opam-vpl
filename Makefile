admin:
	opam-admin make
	
deps:
	opam-admin depexts add vpl-core --os ubuntu --dep libeigen3-dev
	opam-admin depexts add vpl-core --os debian --dep libeigen3-dev
	opam-admin depexts add vpl-core --os darwin --dep eigen

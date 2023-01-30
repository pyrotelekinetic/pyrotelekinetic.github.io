{

description = "pyrosite: my personal website";

inputs = {
	nixpkgs = {
		type = "github";
		owner = "NixOS";
		repo = "nixpkgs";
		ref = "release-22.11";
	};

	yip = {
		type = "github";
		owner = "pyrotelekinetic";
		repo = "yip";
		ref = "main";
		rev = "c5a68b12e56aea7e0e2713bfafaa5fce5baf5dbf";
	};
};

outputs = { self, nixpkgs, yip }:
	{
	packages.x86_64-linux.default =
		with import nixpkgs { system = "x86_64-linux"; };
		pkgs.stdenv.mkDerivation {
			name = "static site";
			src = ./site;
			buildInputs = [ yip.packages.x86_64-linux.default ];
			buildPhase = "yip index.html > new-index.html";
			installPhase = "mkdir -p $out/site; cp new-index.html $out/site/index.html";
		};
	};

}

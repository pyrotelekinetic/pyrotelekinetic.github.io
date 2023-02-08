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
	};
};

outputs = { self, nixpkgs, yip }:
	{
	packages.x86_64-linux.default =
		with import nixpkgs { system = "x86_64-linux"; };
		pkgs.stdenv.mkDerivation {
			name = "static site";
			src = ./site;
			buildInputs = [
				pkgs.fd
				yip.packages.x86_64-linux.default
			];
			buildPhase = ''
				fd -t d -E assets/ -E templates/ -x mkdir -p out/{};
				fd -t f -E assets/ -E templates/ -e html -e css -x sh -c 'yip {} > out/{}';
			'';
			#buildPhase = ''fd -e html -e css -E templates/ -x sh -c 'yip {} > {}' '';
			#checkPhase = "fd";
			#doCheck = true;
			installPhase = ''
				mkdir -p $out/site;
				cp -r out/* $out/site;
				cp -r assets/ $out/site;
			'';
		};
	};

}

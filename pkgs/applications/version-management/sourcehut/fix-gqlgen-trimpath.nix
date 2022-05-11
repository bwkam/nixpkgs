{ unzip }:
{
  overrideModAttrs = (_: {
    # No need to workaround -trimpath: it's not used in go-modules,
    # but do download `go generate`'s dependencies nonetheless.
    preBuild = ''
      set -x
      go generate ./loaders
      go generate ./graph
      set +x
    '';
  });

  # Workaround:
  #   go: git.sr.ht/~emersion/go-emailthreads@v0.0.0-20220412093310-4fd792e343ba: module lookup disabled by GOPROXY=off
  #   tidy failed: go mod tidy failed: exit status 1
  #   graph/generate.go:10: running "go": exit status 1
  proxyVendor = true;

  # Workaround -trimpath in the package derivation:
  # https://github.com/99designs/gqlgen/issues/1537
  # This is to give `go generate ./graph` access to gqlgen's *.gotpl files
  # If it fails, the gqlgenVersion may have to be updated.
  preBuild = let gqlgenVersion = "0.17.2"; in ''
    set -x
    ${unzip}/bin/unzip ''${GOPROXY#"file://"}/github.com/99designs/gqlgen/@v/v${gqlgenVersion}.zip
    go generate ./loaders
    go generate ./graph
    rm -rf github.com
    set +x
  '';
}

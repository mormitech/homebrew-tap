# homebrew-tap

Homebrew tap for the [mormitech](https://github.com/mormitech) tools.

## mcDiskFree

[mcDiskFree](https://github.com/mormitech/mcdiskfree) is a free disk space analyzer.

```
brew install --cask mormitech/tap/mcdiskfree   # macOS, Apple silicon
brew install mormitech/tap/mcdiskfree          # Linux x64 (needs GTK 3 and WebKitGTK 4.1 from the distribution)
```

After `brew tap mormitech/tap`, `brew search disk` and `brew search --desc "disk usage"` find it.

Both are generated from a published release: in the mcdiskfree repository, `node scripts/make-cask.mjs > ../homebrew-tap/Casks/mcdiskfree.rb` and `node scripts/make-formula.mjs > ../homebrew-tap/Formula/mcdiskfree.rb`.
The app is not notarized yet, so the cask clears the download quarantine flag after installing.

## mcPrint

[mcPrint](https://github.com/mormitech/mcprint) scans pages of documents from network scanners (eSCL / AirScan).

```
brew install --cask mormitech/tap/mcprint   # macOS, Apple silicon
brew install mormitech/tap/mcprint          # Linux x64 (needs GTK 3 and WebKitGTK 4.1 from the distribution)
```

Both are generated from a published release: in the mcprint repository, `node scripts/make-cask.mjs > ../homebrew-tap/Casks/mcprint.rb` and `node scripts/make-formula.mjs > ../homebrew-tap/Formula/mcprint.rb`.
The app is not notarized yet, so the cask clears the download quarantine flag after installing.

## mctwain

Homebrew tap for [mctwain](https://github.com/mormitech/mctwain), a local helper that lets web pages scan from
network scanners.

```
brew install mormitech/tap/mctwain
brew services start mctwain
```

## Updating the formula for a new mctwain release

1. In `Formula/mctwain.rb`, change the version in `url`.
2. Update `sha256`:
   `curl -fsSL https://github.com/mormitech/mctwain/archive/refs/tags/vX.Y.Z.tar.gz | shasum -a 256`
3. `brew install --build-from-source ./Formula/mctwain.rb && brew test mctwain`, then commit and push.

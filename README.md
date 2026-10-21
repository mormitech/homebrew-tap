# homebrew-tap

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

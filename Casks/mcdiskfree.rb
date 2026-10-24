cask "mcdiskfree" do
  version "0.6.0"

  name "mcDiskFree"
  desc "Disk space and disk usage analyzer with an interactive sunburst chart"
  homepage "https://github.com/mormitech/mcdiskfree"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_macos do
    sha256 "891e7c732d9fc11bba6bd4112367a0176d0c6b2cd6e58d1c7f928820b7bff1bb"

    url "https://github.com/mormitech/mcdiskfree/releases/download/v#{version}/mcdiskfree-#{version}-macos-arm64.zip"

    depends_on arch: :arm64
    depends_on macos: :monterey

    app "mcdiskfree.app"

    # The app is not notarized yet, so Gatekeeper would block its first launch; clear the quarantine flag it got
    # when it was downloaded. (A third-party tap may do this; the main homebrew-cask repository does not allow it.)
    postflight_steps do
      run "/usr/bin/xattr",
          args:         ["-dr", "com.apple.quarantine", "{{appdir}}/mcdiskfree.app"],
          must_succeed: false
    end

    zap trash: "~/Library/Caches/mcdiskfree"
  end

  on_linux do
    sha256 "366ff0a52b61f2a6df2cb260fc5073ce420bc0938ffdc9be5bfb6bcb153043bd"

    url "https://github.com/mormitech/mcdiskfree/releases/download/v#{version}/mcdiskfree-#{version}-linux-x64.tar.gz"

    depends_on arch: :x86_64

    binary "mcdiskfree"

    zap trash: "~/.cache/mcdiskfree"

    caveats <<~EOS
      mcdiskfree needs GTK 3 and WebKitGTK 4.1 from your system, for example on Debian and Ubuntu:
        sudo apt install libgtk-3-0 libwebkit2gtk-4.1-0
    EOS
  end
end

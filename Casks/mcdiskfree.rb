cask "mcdiskfree" do
  version "0.6.2"

  name "mcDiskFree"
  desc "Disk space and disk usage analyzer with an interactive sunburst chart"
  homepage "https://github.com/mormitech/mcdiskfree"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_macos do
    sha256 "3fdc4f91c170f6d49b2e3cdd888f4b39bb5b564c99a7859777969610622ed16c"

    url "https://github.com/mormitech/mcdiskfree/releases/download/v#{version}/mcdiskfree-#{version}-macos-arm64.zip"

    depends_on arch: :arm64
    depends_on macos: :monterey

    app "mcdiskfree.app"
    # also a command, so mcdiskfree (and mcdiskfree --mock macos) works in a terminal
    binary "#{appdir}/mcdiskfree.app/Contents/MacOS/mcdiskfree"

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
    sha256 "24b831336a258c94fc0368f27b2c4d92b641eed5aea8c3f4d16e9fc76e1fa0d1"

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

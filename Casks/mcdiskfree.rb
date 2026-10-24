cask "mcdiskfree" do
  version "0.6.3"

  name "mcDiskFree"
  desc "Disk space and disk usage analyzer with an interactive sunburst chart"
  homepage "https://github.com/mormitech/mcdiskfree"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_macos do
    sha256 "0267fe8afe6c0955a1f163c4ceba75e01457b8b81969abfa42230c0b1f2c2567"

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
    sha256 "921104f0b1deef018f1674e96a77918d2c7bc43fb5b9230971f2dbd680a54604"

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

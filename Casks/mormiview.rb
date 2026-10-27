cask "mormiview" do
  version "0.51.8"

  name "mormiView"
  desc "Picture viewer and small editor with GIF frames and a chat for Claude"
  homepage "https://github.com/mormitech/mormiview"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_macos do
    sha256 "5bb23c538aa2cbc9dc5f6489df38a2ad984ffa696445ab5ad6ab4975cdd9a1dc"

    url "https://github.com/mormitech/mormiview/releases/download/v#{version}/mormiview-#{version}-macos-arm64.zip"

    depends_on arch: :arm64
    depends_on macos: :monterey

    app "mormiview.app"
    # also a command, so mormiview (and mormiview picture.jpg) works in a terminal
    binary "#{appdir}/mormiview.app/Contents/MacOS/mormiview"

    # The app is not notarized yet, so Gatekeeper would block its first launch; clear the quarantine flag it got
    # when it was downloaded. (A third-party tap may do this; the main homebrew-cask repository does not allow it.)
    postflight_steps do
      run "/usr/bin/xattr",
          args:         ["-dr", "com.apple.quarantine", "{{appdir}}/mormiview.app"],
          must_succeed: false
    end

    zap trash: "~/Library/Caches/mormiview"
  end

  on_linux do
    sha256 "12bbadb2e9251d2add69ece8edd25eb8d7925c387b3cc6f78e87fd78bd2f675d"

    url "https://github.com/mormitech/mormiview/releases/download/v#{version}/mormiview-#{version}-linux-x64.tar.gz"

    depends_on arch: :x86_64

    binary "mormiview"

    zap trash: "~/.cache/mormiview"

    caveats <<~EOS
      mormiview needs GTK 3 and WebKitGTK 4.1 from your system, for example on Debian and Ubuntu:
        sudo apt install libgtk-3-0 libwebkit2gtk-4.1-0
    EOS
  end
end

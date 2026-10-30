cask "mormidiskfree" do
  version "0.8.2"

  name "mormiDiskFree"
  desc "Disk space and disk usage analyzer with an interactive sunburst chart"
  homepage "https://github.com/mormitech/mormidiskfree"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_macos do
    sha256 "de17f9d61987a288007dddf433d7afcf44c93677a9b8c5ccfa60f148f44dee85"

    url "https://github.com/mormitech/mormidiskfree/releases/download/v#{version}/mormidiskfree-#{version}-macos-arm64.zip"

    depends_on arch: :arm64
    depends_on macos: :monterey

    app "mormidiskfree.app"
    # also a command, so mormidiskfree (and mormidiskfree --mock macos) works in a terminal
    binary "#{appdir}/mormidiskfree.app/Contents/MacOS/mormidiskfree"

    # The app is not notarized yet, so Gatekeeper would block its first launch; clear the quarantine flag it got
    # when it was downloaded. (A third-party tap may do this; the main homebrew-cask repository does not allow it.)
    postflight_steps do
      run "/usr/bin/xattr",
          args:         ["-dr", "com.apple.quarantine", "{{appdir}}/mormidiskfree.app"],
          must_succeed: false
    end

    zap trash: "~/Library/Caches/mormidiskfree"
  end

  on_linux do
    sha256 "82f7f0c84319b84c4fd71feafbf9ec0ba614daee6b1b96f9ac8c297f5f70e0c3"

    url "https://github.com/mormitech/mormidiskfree/releases/download/v#{version}/mormidiskfree-#{version}-linux-x64.tar.gz"

    depends_on arch: :x86_64

    binary "mormidiskfree"

    zap trash: "~/.cache/mormidiskfree"

    caveats <<~EOS
      mormidiskfree needs GTK 3 and WebKitGTK 4.1 from your system, for example on Debian and Ubuntu:
        sudo apt install libgtk-3-0 libwebkit2gtk-4.1-0
      On Debian and Ubuntu the .deb from the GitHub release installs them for you:
        https://github.com/mormitech/mormidiskfree/releases/latest
    EOS
  end
end

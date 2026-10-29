cask "mormidiskfree" do
  version "0.8.1"

  name "mormiDiskFree"
  desc "Disk space and disk usage analyzer with an interactive sunburst chart"
  homepage "https://github.com/mormitech/mormidiskfree"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_macos do
    sha256 "d661936be5311b51aa0a348f234d2eec2c36678fea1cb7ed8898d2e4d24f3e80"

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
    sha256 "b6d8d19887f62234c5587daff436a660eba7d2884173f287e82925bf3f2f04f7"

    url "https://github.com/mormitech/mormidiskfree/releases/download/v#{version}/mormidiskfree-#{version}-linux-x64.tar.gz"

    depends_on arch: :x86_64

    binary "mormidiskfree"

    zap trash: "~/.cache/mormidiskfree"

    caveats <<~EOS
      mormidiskfree needs GTK 3 and WebKitGTK 4.1 from your system, for example on Debian and Ubuntu:
        sudo apt install libgtk-3-0 libwebkit2gtk-4.1-0
    EOS
  end
end

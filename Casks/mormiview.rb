cask "mormiview" do
  version "0.57.1"

  name "mormiView"
  desc "Picture viewer and small editor with GIF frames and a chat for Claude"
  homepage "https://github.com/mormitech/mormiview"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_macos do
    sha256 "2bc7e132438a0733baf80ce7c54b4ee853b66f4eeb236591c5d1ada115ce18f0"

    url "https://github.com/mormitech/mormiview/releases/download/v#{version}/mormiview-#{version}-macos-arm64.zip"

    depends_on arch: :arm64
    depends_on macos: :monterey

    app "mormiview.app"
    # also a command, so mormiview picture.jpg works in a terminal (a launcher in the app, since 0.51.11; it starts the app the way Finder does)
    binary "#{appdir}/mormiview.app/Contents/Resources/bin/mormiview"

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
    sha256 "24de6de3e6887caabc65a04f12c378c54849987207e7b5e0cafb2378be52c8cb"

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

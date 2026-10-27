cask "mormiview" do
  version "0.51.11"

  name "mormiView"
  desc "Picture viewer and small editor with GIF frames and a chat for Claude"
  homepage "https://github.com/mormitech/mormiview"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_macos do
    sha256 "eb9e7b204b95a18b4016083b3b6aa5d81a74a85c77786398abf7c2f9db26647b"

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
    sha256 "a879b458c556638be334568bfeb6d0a030b268fc6338274cd995b9edb162fb18"

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

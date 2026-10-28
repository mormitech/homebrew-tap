cask "mormiview" do
  version "0.51.12"

  name "mormiView"
  desc "Picture viewer and small editor with GIF frames and a chat for Claude"
  homepage "https://github.com/mormitech/mormiview"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_macos do
    sha256 "0448e97be26a898a5f465ab77b27c6e24beee44e13d588eb4a05880154f03562"

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
    sha256 "87b03f84dca7acad21901acf9d419b2f3436f6dd0bcd6de819c2e38475652eec"

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

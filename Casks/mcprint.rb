cask "mcprint" do
  version "0.7.1"

  name "mcPrint"
  desc "Scan pages of documents from network scanners (eSCL / AirScan)"
  homepage "https://github.com/mormitech/mcprint"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_macos do
    sha256 "b4bf2b6980ae83bd4cbcde656c5f97508ba6d565e8db60bb3f4d9dc8b8f6189a"

    url "https://github.com/mormitech/mcprint/releases/download/v#{version}/mcprint-#{version}-macos-arm64.zip"

    depends_on arch: :arm64
    depends_on macos: :monterey

    app "mcprint.app"
    # also a command, so mcprint works in a terminal
    binary "#{appdir}/mcprint.app/Contents/MacOS/mcprint"

    # The app is not notarized yet, so Gatekeeper would block its first launch; clear the quarantine flag it got
    # when it was downloaded. (A third-party tap may do this; the main homebrew-cask repository does not allow it.)
    postflight_steps do
      run "/usr/bin/xattr",
          args:         ["-dr", "com.apple.quarantine", "{{appdir}}/mcprint.app"],
          must_succeed: false
    end

    zap trash: [
      "~/Library/Application Support/mcprint",
      "~/Library/Caches/mcprint",
    ]
  end

  on_linux do
    sha256 "1ea98b150e9c6077311f6ab532f5da6911956dae9a1aa443116a0c7ce1d1dc20"

    url "https://github.com/mormitech/mcprint/releases/download/v#{version}/mcprint-#{version}-linux-x64.tar.gz"

    depends_on arch: :x86_64

    binary "mcprint"

    zap trash: [
      "~/.cache/mcprint",
      "~/.config/mcprint",
    ]

    caveats <<~EOS
      mcprint needs GTK 3 and WebKitGTK 4.1 from your system, for example on Debian and Ubuntu:
        sudo apt install libgtk-3-0 libwebkit2gtk-4.1-0
    EOS
  end
end

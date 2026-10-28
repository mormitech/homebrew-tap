cask "mormiprint" do
  version "0.8.2"

  name "mormiPrint"
  desc "Scan pages of documents from network scanners (eSCL / AirScan)"
  homepage "https://github.com/mormitech/mormiprint"

  livecheck do
    url :url
    strategy :github_latest
  end

  on_macos do
    sha256 "7e12d284e15f699e44d5b94e561a79536453161b5b021dcad333f96e0c59b64c"

    url "https://github.com/mormitech/mormiprint/releases/download/v#{version}/mormiprint-#{version}-macos-arm64.zip"

    depends_on arch: :arm64
    depends_on macos: :monterey

    app "mormiprint.app"
    # also a command, so mormiprint works in a terminal
    binary "#{appdir}/mormiprint.app/Contents/MacOS/mormiprint"

    # The app is not notarized yet, so Gatekeeper would block its first launch; clear the quarantine flag it got
    # when it was downloaded. (A third-party tap may do this; the main homebrew-cask repository does not allow it.)
    postflight_steps do
      run "/usr/bin/xattr",
          args:         ["-dr", "com.apple.quarantine", "{{appdir}}/mormiprint.app"],
          must_succeed: false
    end

    zap trash: [
      "~/Library/Application Support/mormiprint",
      "~/Library/Caches/mormiprint",
    ]
  end

  on_linux do
    sha256 "84a3352ca54e05a4c93f3e914c799f672ae436867ded6f82beb39a25bb9fb44d"

    url "https://github.com/mormitech/mormiprint/releases/download/v#{version}/mormiprint-#{version}-linux-x64.tar.gz"

    depends_on arch: :x86_64

    binary "mormiprint"

    zap trash: [
      "~/.cache/mormiprint",
      "~/.config/mormiprint",
    ]

    caveats <<~EOS
      mormiprint needs GTK 3 and WebKitGTK 4.1 from your system, for example on Debian and Ubuntu:
        sudo apt install libgtk-3-0 libwebkit2gtk-4.1-0
    EOS
  end
end

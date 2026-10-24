cask "mcprint" do
  version "0.6.0"
  sha256 "b0d2db106c5c4325ebe0daec1e3b9c826e8ec7d2e50213e72b75e8ac7696f8ae"

  url "https://github.com/mormitech/mcprint/releases/download/v#{version}/mcprint-#{version}-macos-arm64.zip"
  name "mcPrint"
  desc "Scan pages of documents from network scanners (eSCL / AirScan)"
  homepage "https://github.com/mormitech/mcprint"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :monterey

  app "mcprint.app"

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

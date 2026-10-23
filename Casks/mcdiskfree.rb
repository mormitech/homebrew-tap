cask "mcdiskfree" do
  version "0.5.0"
  sha256 "17b7210d8e1d586ad88ac4454569c7c0ade1bee4b5a9112478d1e0802a0cc82a"

  url "https://github.com/mormitech/mcdiskfree/releases/download/v#{version}/mcdiskfree-#{version}-macos-arm64.zip"
  name "mcdiskfree"
  desc "Free disk space analyzer with an interactive sunburst chart"
  homepage "https://github.com/mormitech/mcdiskfree"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :monterey

  app "mcdiskfree.app"

  # The app is not notarized yet, so Gatekeeper would block its first launch; clear the quarantine flag it got
  # when it was downloaded. (A third-party tap may do this; the main homebrew-cask repository does not allow it.)
  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/mcdiskfree.app"],
        must_succeed: false
  end

  zap trash: "~/Library/Caches/mcdiskfree"
end

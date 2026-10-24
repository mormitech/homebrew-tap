class Mcdiskfree < Formula
  desc "Free disk space analyzer with an interactive sunburst chart"
  homepage "https://github.com/mormitech/mcdiskfree"
  url "https://github.com/mormitech/mcdiskfree/releases/download/v0.5.0/mcdiskfree-0.5.0-linux-x64.tar.gz"
  sha256 "9b57ada852a129ceb28bf36f560cf905458505e0202295086c6e2fcfa3f3d59d"
  license "MIT"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The macOS app is the cask of the same name: brew install --cask mormitech/tap/mcdiskfree
  depends_on arch: :x86_64
  depends_on :linux

  def install
    bin.install "mcdiskfree"
  end

  def caveats
    <<~EOS
      mcdiskfree needs GTK 3 and WebKitGTK 4.1 from your system, for example on Debian and Ubuntu:
        sudo apt install libgtk-3-0 libwebkit2gtk-4.1-0
    EOS
  end

  test do
    assert_predicate bin/"mcdiskfree", :executable?
  end
end

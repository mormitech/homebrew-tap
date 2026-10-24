class Mcdiskfree < Formula
  desc "Disk space and disk usage analyzer with an interactive sunburst chart"
  homepage "https://github.com/mormitech/mcdiskfree"
  url "https://github.com/mormitech/mcdiskfree/releases/download/v0.6.0/mcdiskfree-0.6.0-linux-x64.tar.gz"
  sha256 "366ff0a52b61f2a6df2cb260fc5073ce420bc0938ffdc9be5bfb6bcb153043bd"
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

class Mcprint < Formula
  desc "Scan pages of documents from network scanners (eSCL / AirScan)"
  homepage "https://github.com/mormitech/mcprint"
  url "https://github.com/mormitech/mcprint/releases/download/v0.6.0/mcprint-0.6.0-linux-x64.tar.gz"
  sha256 "fd420c9eee10c88398767aa3d8f201c6dfb13a46e5aa36bbc89be53d8b97a8a6"
  license "MIT"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The macOS app is the cask of the same name: brew install --cask mormitech/tap/mcprint
  depends_on arch: :x86_64
  depends_on :linux

  def install
    bin.install "mcprint"
  end

  def caveats
    <<~EOS
      mcprint needs GTK 3 and WebKitGTK 4.1 from your system, for example on Debian and Ubuntu:
        sudo apt install libgtk-3-0 libwebkit2gtk-4.1-0
    EOS
  end

  test do
    assert_predicate bin/"mcprint", :executable?
  end
end

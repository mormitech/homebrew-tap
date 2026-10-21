class Mctwain < Formula
  desc "Local helper that lets web pages scan documents from network scanners"
  homepage "https://github.com/mormitech/mctwain"
  url "https://github.com/mormitech/mctwain/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "35d1393da808a272171e3d2e5cafc89fd87abbe70c7cf135d65366c7221ea7be"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  service do
    run [opt_bin/"mctwain"]
    keep_alive successful_exit: false
    log_path var/"log/mctwain.log"
    error_log_path var/"log/mctwain.log"
  end

  test do
    port = free_port
    pid = fork do
      ENV["MCTWAIN_PORT"] = port.to_s
      exec bin/"mctwain"
    end
    sleep 3
    assert_match "\"name\":\"mctwain\"", shell_output("curl -s http://127.0.0.1:#{port}/ping")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

class Mctwain < Formula
  desc "Local helper that lets web pages scan documents from network scanners"
  homepage "https://github.com/mormitech/mctwain"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mormitech/mctwain/releases/download/v0.4.0/mctwain-bin-0.4.0-macos-arm64.tar.gz"
      sha256 "a98dba34ffcccef7c46bb6c45c65188b6af2ba9eaa8fb2a3195bd3da8fe47302"
    end
    on_intel do
      url "https://github.com/mormitech/mctwain/archive/refs/tags/v0.4.0.tar.gz"
      sha256 "6a9f1af18eceb41e40112d95eda20991b9f64c2d3285020f0e0894bc03131fab"
      depends_on "node"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mormitech/mctwain/releases/download/v0.4.0/mctwain-bin-0.4.0-linux-arm64.tar.gz"
      sha256 "a6a228b650c1965bc61c479fa9ce53b678e30c3edc2cd8f3360716bf9520291a"
    end
    on_intel do
      url "https://github.com/mormitech/mctwain/releases/download/v0.4.0/mctwain-bin-0.4.0-linux-x64.tar.gz"
      sha256 "6ffbcaeba434aed1d7dff2c89caa01e2a06d5f2dedda2e6f18b7dbe37bbc9c9f"
    end
  end

  def install
    if OS.mac? && Hardware::CPU.intel?
      system "npm", "install", *std_npm_args
      bin.install_symlink Dir["#{libexec}/bin/*"]
    else
      bin.install "mctwain"
      if File.exist?("mctwain-tray")
        bin.install "mctwain-tray"
        # One launchd job for both: the menu bar tray in the background, then the helper itself.
        # launchd stops them together, so `brew services stop mctwain` also removes the icon.
        (bin/"mctwain-run").write <<~SH
          #!/bin/sh
          "#{opt_bin}/mctwain-tray" &
          exec "#{opt_bin}/mctwain"
        SH
        chmod 0755, bin/"mctwain-run"
      end
    end
  end

  service do
    run [opt_bin/((OS.mac? && !Hardware::CPU.intel?) ? "mctwain-run" : "mctwain")]
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

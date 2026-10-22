class Mctwain < Formula
  desc "Local helper that lets web pages scan documents from network scanners"
  homepage "https://github.com/mormitech/mctwain"
  version "0.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mormitech/mctwain/releases/download/v0.3.0/mctwain-bin-0.3.0-macos-arm64.tar.gz"
      sha256 "b498f8d94c7dbbed0373880dab8ceabce54c6d72603c97154f325d853570f2dc"
    end
    on_intel do
      url "https://github.com/mormitech/mctwain/archive/refs/tags/v0.3.0.tar.gz"
      sha256 "4e2a0e8d643a8afe959c2512226d3936c2b3596d458ca2f523ac502d64e66a95"
      depends_on "node"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mormitech/mctwain/releases/download/v0.3.0/mctwain-bin-0.3.0-linux-arm64.tar.gz"
      sha256 "3266c9dc56917fed7b0a857e7586f6b6e1538f39b626ac7506a405a8fc322d55"
    end
    on_intel do
      url "https://github.com/mormitech/mctwain/releases/download/v0.3.0/mctwain-bin-0.3.0-linux-x64.tar.gz"
      sha256 "0ebc37b5950f4689750b602c391855cfd119e2cb21866aa4fac645b108b9bade"
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

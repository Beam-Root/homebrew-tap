class BeamcaAgent < Formula
  desc "Beam CA agent — short-lived machine certificates for private PKI"
  homepage "https://github.com/beam-root/beamca"
  version "0.0.0-dev"
  license "Proprietary"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/beam-root/releases/releases/download/v0.0.0-dev/beamca-agent-darwin-arm64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"

      def install
        bin.install "beamca-agent-darwin-arm64" => "beamca-agent"
      end
    else
      url "https://github.com/beam-root/releases/releases/download/v0.0.0-dev/beamca-agent-darwin-amd64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"

      def install
        bin.install "beamca-agent-darwin-amd64" => "beamca-agent"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/beam-root/releases/releases/download/v0.0.0-dev/beamca-agent-linux-arm64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"

      def install
        bin.install "beamca-agent-linux-arm64" => "beamca-agent"
      end
    else
      url "https://github.com/beam-root/releases/releases/download/v0.0.0-dev/beamca-agent-linux-amd64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"

      def install
        bin.install "beamca-agent-linux-amd64" => "beamca-agent"
      end
    end
  end

  def caveats
    <<~EOS
      Quick start — first enrollment:

        1. Get an enrollment token from your Beam CA operator. Tokens are
           single-use, expire by default in 24 h, and bind to a specific
           machine_id.

        2. Pin a stable machine identity (recommended) and enroll:

             sudo beamca-agent --enroll \\
               --machine-id <stable-id> \\
               --token tk_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx \\
               --config /etc/beamca-agent/agent.yaml

           The agent writes its private key + cert under the configured
           paths and (on macOS) installs the CA chain into the System
           keychain so other tools on the host can validate the chain.

        3. Renew on demand or run as a daemon:

             sudo beamca-agent --renew --config /etc/beamca-agent/agent.yaml
             sudo beamca-agent --daemon --config /etc/beamca-agent/agent.yaml

      The brew install does NOT auto-start the agent. Use `brew services
      start beamca-agent` only after you have a config file in place.

      Logs: /var/log/beamca-agent.log
    EOS
  end

  service do
    run [opt_bin/"beamca-agent", "--daemon", "--config", "/etc/beamca-agent/agent.yaml"]
    require_root true
    keep_alive true
    log_path "/var/log/beamca-agent.log"
    error_log_path "/var/log/beamca-agent.log"
  end

  test do
    assert_match "beamca-agent", shell_output("#{bin}/beamca-agent --help 2>&1", 0)
  end
end

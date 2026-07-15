class GmlDaemon < Formula
  desc "Background daemon for the gml GPU machine management CLI"
  homepage "https://salazar-99.github.io/gml/"
  version "0.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Salazar-99/gml/releases/download/v0.2.0/gml-daemon-aarch64-apple-darwin.tar.xz"
    sha256 "0ebdc88bff29640986eba7355b854d092f2da6ef433717b41e09742a07fca1df"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Salazar-99/gml/releases/download/v0.2.0/gml-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1c6b8b8f139c7d4c8f803c1b8ae20f8e05cbbbe54bb1d1f26004a0868447727a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Salazar-99/gml/releases/download/v0.2.0/gml-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "29cc76e0eed515124b6a955261dde2698c6f2d6956b898e97ea28965681e43eb"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "gmld" if OS.mac? && Hardware::CPU.arm?
    bin.install "gmld" if OS.linux? && Hardware::CPU.arm?
    bin.install "gmld" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

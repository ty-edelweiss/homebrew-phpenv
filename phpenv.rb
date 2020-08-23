class Phpenv < Formula
  desc "Simple PHP version management"
  homepage "https://github.com/phpenv/phpenv"
  # url "https://github.com/phpenv/phpenv/archive/master.tar.gz"
  # sha256 "b2b8671006ed27609cc389fedc5e6096e767b60e8fb2712d24a1fa357ef32a87"
  license "MIT"
  head "https://github.com/phpenv/phpenv.git"

  bottle :unneeded

  depends_on "php-build" => :recommended

  def install
    if build.head?
      # Record exact git revision for `rbenv --version` output
      git_revision = `git rev-parse --short HEAD`.chomp
      inreplace "libexec/phpenv---version", /^(version=)"([^"]+)"/,
                                            %Q(\\1"\\2-g#{git_revision}")
    end

    prefix.install ["bin", "completions", "libexec"]
  end

  test do
    shell_output("eval \"$(#{bin}/phpenv init -)\" && phpenv versions")
  end
end

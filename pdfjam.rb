class Pdfjam < Formula
  desc "Simple shell interface to the pdfpages package for pdfLaTeX"
  homepage "https://github.com/rrthomas/pdfjam"
  url "https://github.com/rrthomas/pdfjam/archive/refs/tags/v3.03.tar.gz"
  head "https://github.com/rrthomas/pdfjam.git"
  sha256 "bd27e44e75909cac2a53f0c8d0b253d9c95e496a181b7837f7919724dff78b69"
  
  depends_on "gnu-sed" => :build

  def install
    if build.head?
      opoo "Building from HEAD may not work because of GNU/BSD sed differences"
      ENV["PATH"] = Formula["gnu-sed"].libexec/"gnubin"
      system "bash", "build.sh"
      build_dir = buildpath / "built_package/pdfjam-#{version}"
    else
      build_dir = buildpath
    end

    bin.install(Dir[build_dir/"bin/pdf*"])
    man1.install(Dir[build_dir/"man1/pdf*.1"])
    etc.install(build_dir/"pdfjam.conf")
  end

  def caveats; <<~EOS
    pdfjam requires the installation of pdfLaTeX. You may need to install
    TeX Live. Both MacTeX and BasicTeX are acceptable.

    brew install mactex
    brew install basictex
    EOS
  end

  test do
    system "#{bin}/pdfjam", "--version"
  end
end

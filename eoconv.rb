class Eoconv < Formula
  desc "Convert text files between various Esperanto encodings"
  homepage "https://files.nothingisreal.com/software/eoconv/eoconv.html"
  url "https://files.nothingisreal.com/software/eoconv/eoconv-1.5.tar.bz2"
  version "1.5"
  sha256 "85a8284268f7885d702e2e44e85b523375af3b8e9f043ffa4ed87c609b64d5ca"
  license ""

  depends_on "coreutils" => :build
  uses_from_macos "perl"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    # -D is a GNU install option, create leading directories, that's handled
    # inclusively by -d on BSD install. However, it doesn't quite work the same
    # way on macOS so let's just depend on and use GNU coreutils.
    inreplace "Makefile", 'install -D', 'ginstall -D'

    system "make", "PREFIX=#{prefix}", "install"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    (testpath/"test.txt").write("Sxangxu vian retposxtadreson")
    # using x->h in order to avoid UTF-8 problems
    assert_match "Shanghu vian retposhtadreson", pipe_output("#{bin}/eoconv --from=post-x --to=post-h test.txt")
  end
end

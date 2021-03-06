require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Tern < EmacsFormula
  desc "JavaScript code analyzer"
  homepage "http://ternjs.net/"
  url "https://github.com/ternjs/tern/archive/0.18.0.tar.gz"
  sha256 "ac7b04825b825247e9c775c4e2b5007ddeba82b3b2502fbf456d193a423c15d0"
  head "https://github.com/ternjs/tern.git"

  depends_on "node"
  depends_on :emacs => "24"
  depends_on "homebrew/emacs/auto-complete" => :optional
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"
    system "npm", "install"
    system "npm", "test"

    lisps = %w[emacs/tern.el]
    lisps << "emacs/tern-auto-complete.el" if build.with? "auto-complete"
    byte_compile lisps
    elisp.install Dir["emacs/*"]

    doc.install Dir["doc/*"]
    libexec.install Dir["*"]
    bin.install_symlink (libexec/"bin/tern")
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "tern")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

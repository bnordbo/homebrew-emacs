require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Pcache < EmacsFormula
  desc "Persistent caching for Emacs"
  homepage "https://github.com/sigma/pcache"
  url "https://github.com/sigma/pcache/archive/v0.4.0.tar.gz"
  sha256 "01ea5596fe1da59f035069e133e571efe852f240692a9d9a609b16618b862bcf"
  head "https://github.com/sigma/pcache.git"

  depends_on :emacs

  def install
    ert_run_tests "test/pcache-test.el"
    byte_compile "pcache.el"
    elisp.install "pcache.el", "pcache.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "pcache")
      (print (let ((repo (pcache-repository "plop")))
        (pcache-put repo 'home "brew")
        (pcache-get repo 'home)))
    EOS
    assert_equal "\"brew\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

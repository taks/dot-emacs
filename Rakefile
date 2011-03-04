# -*- coding: utf-8; mode: ruby -*-

require 'rake/clean'

ROOT = '.'
EMACS = 'emacs'
ELISP_OPTIONS = []
ELISP_OPTIONS << '-batch -no-site-file'

ELISP_DIRS = FileList["**/*.el"].map { |x| File.dirname(x) }.uniq
ELISP_DIRS.each { |dir| ELISP_OPTIONS << "-L #{dir}" }

ELISP_OPTIONS << '-f batch-byte-compile'
EL_FILES = FileList["elisp/*.el"]
EL_FILES.exclude("inits/gauche-mode/*")

desc "Compile el to elc"
task :compile

EL_FILES.each do |el_file|
  elc_file = el_file.ext('.elc')
  task :compile => elc_file
  file elc_file => el_file do |t|
    sh "#{EMACS} #{ELISP_OPTIONS.join(' ')} #{t.prerequisites[0]}"
  end
end

desc "remove old backupfiles"
task :clean_backupfiles do
  sh 'find ~/.emacs.d/backup -mtime +30 -exec rm -f {} \ '
end

CLEAN.exclude(".git/*")
CLEAN.exclude("backup/*~")
CLOBBER.include("elisp/*.elc")

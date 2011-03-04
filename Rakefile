# -*- coding: utf-8; mode: ruby -*-

$: << File.join(ENV["HOME"], "lib")
require 'rake/clean'

ROOT = '.'
EMACS = 'emacs'
ELISP_OPTIONS = []
ELISP_OPTIONS << '-batch -no-site-file'

ELISP_DIRS = FileList["**/*.el"].map { |x| File.dirname(x) }.uniq
ELISP_DIRS.each { |dir| ELISP_OPTIONS << "-L #{dir}" }

ELISP_OPTIONS << '-f batch-byte-compile'
EL_FILES = FileList["**/*.el"]
EL_FILES.exclude("init.el")
EL_FILES.exclude("init_util.el")
EL_FILES.exclude("gauche-mode/*.el")
EL_FILES.exclude("init-el-get.el")
EL_FILES.exclude("el-get/el-get/*")

desc "Compile el to elc"
task :compile

EL_FILES.each do |el_file|
  elc_file = el_file.ext('.elc')
  task :compile => elc_file
  file elc_file => el_file do |t|
    sh "#{EMACS} #{ELISP_OPTIONS.join(' ')} #{t.prerequisites[0]}"
  end
end

desc "make symbolic link (~/.emacs.d)"
task :install do
  from = Dir.getwd
  to = File.join(ENV["HOME"], ".emacs.d")
  ln_s from, to
end

desc "remove old backupfiles"
task :clean_backupfiles do
  sh 'find ~/.emacs.d/backup -mtime +30 -exec rm -f {} \ '
end

desc "cheack init.el"
# @see http://d.hatena.ne.jp/rubikitch/20101125/emacs
task :init_check do
  sh "emacs -batch --eval '(setq debug-on-error t)' -l init.el"
end

CLEAN.exclude(".bzr/*")
CLEAN.exclude("backup/*~")
CLOBBER.include("*.elc")

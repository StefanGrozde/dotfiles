(setq user-full-name "Ivan Trajkov"
      user-mail-address "itrajkov999@gmail.com")

(setq default-tab-width 4)
(setq company-minimum-prefix-length 2)
(setq company-idle-delay 0)

(defun greedily-do-daemon-setup ()
  (require 'org)
  (when (require 'mu4e nil t)
    (setq mu4e-confirm-quit t)
    (setq +mu4e-lock-greedy t)
    (setq +mu4e-lock-relaxed t)
    (+mu4e-lock-add-watcher)
    (when (+mu4e-lock-available t)
      (mu4e~start)))
  (when (require 'elfeed nil t)))

(when (daemonp)
  (add-hook 'emacs-startup-hook #'greedily-do-daemon-setup))

(setq auth-sources '("~/.authinfo.gpg"))

(map! :leader
      :desc "Start ERC"
      "o i" #'my/erc-start-or-switch
      "i i" #'erc-switch-to-buffer)

;;(map! :map specific-mode-map :n "J" (cmd! (a-function) (b-function)))

(map! :map erc-mode-map :n "J" #'erc-join-channel)
(map! :map erc-mode-map :n "qq" #'my/erc-stop)
(map! :map erc-mode-map :n "c u" #'my/erc-count-users)

(map! :leader
      :desc "Start ERC"
      "o h n" #'hackernews)

(setq +doom-dashboard-banner-file (expand-file-name "images/banner.png" doom-private-dir))

(setq doom-font (font-spec :family "FiraCode" :size 20))
(setq doom-unicode-font (font-spec :family "FontAwesome" :size 15))

(setq doom-line-numbers-style 'relative)

(setq doom-theme 'doom-nord)
(setq doom-modeline-height 15)

(add-hook 'vue-mode-hook #'lsp!)

(add-hook `c++-mode-hook `irony-mode)
(add-hook `c-mode-hook `irony-mode)
(add-hook `irony-mode `irony-cdb-autosetup-compile-options)

(setq inferior-lisp-program "sbcl")

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(setq mu4e-change-filename-when-moving t)

(setq mu4e-update-interval (* 1 60))
(setq mu4e-get-mail-command "mbsync -a")
(setq mu4e-maildir "~/Mail")

(setq message-send-mail-function 'smtpmail-send-it)
(setq mu4e-compose-context-policy 'ask-if-none)
(setq smtpmail-queue-mail t)  ;; start in queuing mode


(setq +org-msg-accent-color "#1a5fb4"
      org-msg-greeting-fmt "\nHi %s,\n\n"
      org-msg-signature "\n\n#+begin_signature\nAll the best,\\\\\n*Ivan*\n#+end_signature")


(after! mu4e (setq mu4e-contexts
                   (list
                    ;; Personal gmail account
                    (make-mu4e-context
                     :name "Main-Gmail"
                     :match-func
                     (lambda (msg)
                       (when msg
                         (string-prefix-p "/itrajkov999" (mu4e-message-field msg :maildir))))
                     :vars '((user-mail-address . "itrajkov999@gmail.com")
                             (user-full-name    . "Ivan Trajkov")
                             (smtpmail-smtp-server . "smtp.gmail.com")
                             (smtpmail-smtp-service . 465)
                             (smtpmail-stream-type . ssl)
                             (smtpmail-smtp-user . "itrajkov999@gmail.com")
                             (mu4e-drafts-folder  . "/itrajkov999/[Gmail]/Drafts")
                             (mu4e-sent-folder  . "/itrajkov999/[Gmail]/Sent Mail")
                             (mu4e-refile-folder  . "/itrajkov999/[Gmail]/All Mail")
                             (mu4e-trash-folder  . "/itrajkov999/[Gmail]/Trash")
                             (smtpmail-queue-dir .  "~/Mail/itrajkov999/queue/cur")
                             (mu4e-maildir-shortcuts .
                                                     (("/itrajkov999/Inbox"             . ?i)
                                                      ("/itrajkov999/[Gmail]/Sent Mail" . ?s)
                                                      ("/itrajkov999/[Gmail]/Trash"     . ?t)
                                                      ("/itrajkov999/[Gmail]/Drafts"    . ?d)
                                                      ("/itrajkov999/[Gmail]/All Mail"  . ?a)))))


                    ;;Ivchepro gmail
                    (make-mu4e-context
                     :name "All-Gmail"
                     :match-func
                     (lambda (msg)
                       (when msg
                         (string-prefix-p "/ivchepro" (mu4e-message-field msg :maildir))))
                     :vars '((user-mail-address . "ivchepro@gmail.com")
                             (user-full-name    . "Беден Буџи")
                             (smtpmail-smtp-server . "smtp.gmail.com")
                             (smtpmail-smtp-service . 465)
                             (smtpmail-stream-type . ssl)
                             (smtpmail-smtp-user . "ivchepro@gmail.com")
                             (mu4e-drafts-folder  . "/ivchepro/[Gmail]/Drafts")
                             (mu4e-sent-folder  . "/ivchepro/[Gmail]/Sent Mail")
                             (mu4e-refile-folder  . "/ivchepro/[Gmail]/All Mail")
                             (mu4e-trash-folder  . "/ivchepro/[Gmail]/Trash")
                             (smtpmail-queue-dir .  "~/Mail/ivchepro/queue/cur")
                             (mu4e-maildir-shortcuts .
                                                     (("/ivchepro/Inbox"             . ?i)
                                                      ("/ivchepro/[Gmail]/Sent Mail" . ?s)
                                                      ("/ivchepro/[Gmail]/Trash"     . ?t)
                                                      ("/ivchepro/[Gmail]/Drafts"    . ?d)
                                                      ("/ivchepro/[Gmail]/All Mail"  . ?a))))))))


(map! (:map org-msg-edit-mode-map
       :n "<tab>" #'org-msg-tab
       :localleader
       (:prefix "m"
        "k" #'org-msg-edit-kill-buffer
        "s" #'message-goto-subject
        "b" #'org-msg-goto-body
        "a" #'org-msg-attach)))

(mu4e-alert-set-default-style 'libnotify)
(add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
(add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)
(setq mu4e-alert-email-notification-types '(count))

(use-package mu4e-views
  :after mu4e
  :defer nil
  :bind (:map mu4e-headers-mode-map
         ("M-a" . mu4e-views-mu4e-select-view-msg-method) ;; select viewing method
         ("M-j" . mu4e-views-cursor-msg-view-window-down) ;; from headers window scroll the email view
         ("M-k" . mu4e-views-cursor-msg-view-window-up) ;; from headers window scroll the email view
         ("f" . mu4e-views-toggle-auto-view-selected-message) ;; toggle opening messages automatically when moving in the headers view
         )
  :config
  (setq mu4e-views-completion-method 'ivy) ;; use ivy for completion
  (setq mu4e-views-default-view-method "gnus") ;; make xwidgets default
  (mu4e-views-mu4e-use-view-msg-method "gnus") ;; select the default
  (setq mu4e-views-next-previous-message-behaviour 'stick-to-current-window) ;; when pressing n and p stay in the current window
  (setq mu4e-views-auto-view-selected-message t)) ;; automatically open messages when moving in the headers view

(require 'erc)
(require 'erc-log)
(require 'erc-notify)
(require 'erc-nick-notify)
(require 'erc-spelling)
(require 'erc-autoaway)

;; Join the a couple of interesting channels whenever connecting to Freenode.
(setq erc-autojoin-channels-alist '(("freenode.net"
                                     "#lugola" "#emacs")
                                    ("myanonamouse.net"
                                     "#am-members")
                                    ("libera.chat"
                                     "#commonlisp" "#erc")))

 (add-hook 'window-configuration-change-hook
	   '(lambda ()
	      (setq erc-fill-column (- (window-width) 2))))

;; Interpret mIRC-style color commands in IRC chats
(setq erc-interpret-mirc-color t)

;; The following are commented out by default, but users of other
;; non-Emacs IRC clients might find them useful.
;; Kill buffers for channels after /part
(setq erc-kill-buffer-on-part t)
;; Kill buffers for private queries after quitting the server
(setq erc-kill-queries-on-quit t)
;; Kill buffers for server messages after quitting the server
(setq erc-kill-server-buffer-on-quit t)

;; open query buffers in the current window
(setq erc-query-display 'buffer)

(setq erc-track-shorten-function nil)
;; exclude boring stuff from tracking
(erc-track-mode t)
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                "324" "329" "332" "333" "353" "477"))

;; truncate long irc buffers
(erc-truncate-mode +1)

;; reconnecting
(setq erc-server-reconnect-attempts 5)
(setq erc-server-reconnect-timeout 30)

;; share my real name
(setq erc-user-full-name "Ivan Trajkov")

;; enable spell checking
(erc-spelling-mode 1)
;; set different dictionaries by different servers/channels
;;(setq erc-spelling-dictionaries '(("#emacs" "american")))

(defvar erc-notify-timeout 10
  "Number of seconds that must elapse between notifications from
the same person.")

(defun my/erc-notify (nickname message)
  "Displays a notification message for ERC."
  (let* ((channel (buffer-name))
         (nick (erc-hl-nicks-trim-irc-nick nickname))
         (title (if (string-match-p (concat "^" nickname) channel)
                    nick
                  (concat nick " (" channel ")")))
         (msg (s-trim (s-collapse-whitespace message))))
    (alert (concat nick ": " msg) :title title)))

;; autoaway setup
(setq erc-auto-discard-away t)
(setq erc-autoaway-idle-seconds 600)
(setq erc-autoaway-use-emacs-idle t)
(setq erc-prompt-for-nickserv-password nil)

;; utf-8 always and forever
(setq erc-server-coding-system '(utf-8 . utf-8))

(defun my/erc-start-or-switch ()
  "Connects to ERC, or switch to last active buffer."
  (interactive)
  (if (get-buffer "irc.freenode.net:6697")
      (erc-track-switch-buffer 1)
    (when (y-or-n-p "Start ERC? ")
      (erc-tls :server "irc.freenode.net" :port 6697 :nick "ivche")
      (erc-tls :server "irc.libera.chat" :port 6697 :nick "ivche")
      (erc-tls :server "irc.myanonamouse.net" :port 6697 :nick "Ivche1337")
      )))

(defun my/erc-count-users ()
  "Displays the number of users connected on the current channel."
  (interactive)
  (if (get-buffer "irc.freenode.net:6697")
      (let ((channel (erc-default-target)))
        (if (and channel (erc-channel-p channel))
            (message "%d users are online on %s"
                     (hash-table-count erc-channel-users)
                     channel)
          (user-error "The current buffer is not a channel")))
    (user-error "You must first start ERC")))

(defun filter-server-buffers ()
  (delq nil
        (mapcar
         (lambda (x) (and (erc-server-buffer-p x) x))
         (buffer-list))))

(defun my/erc-stop ()
  "Disconnects from all irc servers"
  (interactive)
  (dolist (buffer (filter-server-buffers))
    (message "Server buffer: %s" (buffer-name buffer))
    (with-current-buffer buffer
      (erc-quit-server "Adios! - sent from ERC"))))

(use-package erc-hl-nicks
  :after erc)

(with-eval-after-load "ispell"
  (setenv "LANG" "en_US.UTF-8")
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_US")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US")
  (setq ispell-personal-dictionary "/usr/share/hunspell/"))
  (unless (file-exists-p ispell-personal-dictionary)
  (write-region "" nil ispell-personal-dictionary nil 0))

(add-hook 'org-mode-hook 'turn-on-flyspell)
(setq org-list-demote-modify-bullet '(("+" . "-") ("-" . "+") ("*" . "+") ("1." . "a.")))

(cl-defmacro lsp-org-babel-enable (lang)
  "Support LANG in org source code block."
  (setq centaur-lsp 'lsp-mode)
  (cl-check-type lang stringp)
  (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
         (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
    `(progn
       (defun ,intern-pre (info)
         (let ((file-name (->> info caddr (alist-get :file))))
           (unless file-name
             (setq file-name (make-temp-file "babel-lsp-")))
           (setq buffer-file-name file-name)
           (lsp-deferred)))
       (put ',intern-pre 'function-documentation
            (format "Enable lsp-mode in the buffer of org source block (%s)."
                    (upcase ,lang)))
       (if (fboundp ',edit-pre)
           (advice-add ',edit-pre :after ',intern-pre)
         (progn
           (defun ,edit-pre (info)
             (,intern-pre info))
           (put ',edit-pre 'function-documentation
                (format "Prepare local buffer environment for org source block (%s)."
                        (upcase ,lang))))))))
(defvar org-babel-lang-list
  '("go" "python" "ipython" "bash" "sh"))
(dolist (lang org-babel-lang-list)
  (eval `(lsp-org-babel-enable ,lang)))

(add-hook 'org-mode-hook #'+org-pretty-mode)

(custom-set-faces!
  '(outline-1 :weight extra-bold :height 1.25)
  '(outline-2 :weight bold :height 1.15)
  '(outline-3 :weight bold :height 1.12)
  '(outline-4 :weight semi-bold :height 1.09)
  '(outline-5 :weight semi-bold :height 1.06)
  '(outline-6 :weight semi-bold :height 1.03)
  '(outline-8 :weight semi-bold)
  '(outline-9 :weight semi-bold))

(custom-set-faces!
  '(org-document-title :height 1.2))


(setq org-agenda-deadline-faces
      '((1.001 . error)
        (1.0 . org-warning)
        (0.5 . org-upcoming-deadline)
        (0.0 . org-upcoming-distant-deadline)))


(setq org-fontify-quote-and-verse-blocks t)

(add-to-list 'org-modules 'org-habit t)

(setq org-reveal-mathjax t)
;; (use-package ox-reveal
;;   :ensure ox-reveal)
(setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
;;(setq org-reveal-root "file:///home/ivche/node_modules/reveal.js/")

(setq org-directory "~/Dropbox/org")

(setq org-agenda-files '("~/Dropbox/org"))

;; (after! org (setq org-todo-keywords
                  ;; '((sequence "TODO" "DOING" "WAITING" "LATER" "DONE" "DELEGATED" "CANCELED"))))

;; (after! org (setq +org-capture-notes-file (concat org-directory "/ivches_system/general/quick_notes.org")))
;; (after! org (setq +org-capture-todo-file (concat org-directory "/ivches_system/mygtd.org")))

;; (after! org (setq org-capture-templates
                  ;; '(("t" "Todo" entry (file+headline +org-capture-todo-file "Inbox")
                     ;; "* TODO %? %i %a\n+ Added: %U"))))

;; (after! org (setq org-archive-location (concat org-directory "/ivches_system/archive/task_archive.org::")))

;; (use-package! org-super-agenda
;;   :after org-agenda
;;   :init
;;   (setq org-super-agenda-grous '((:name "Today"
;;                                   :time-grid t
;;                                   :scheduled today)
;;                                  (:name "Due Today"
;;                                   :deadline today)
;;                                  (:name "Important"
;;                                   :priority "A")
;;                                  (:name "Overdue"
;;                                   :deadline past)
;;                                  (:name "Due soon"
;;                                   :deadline future)
;;                                  (:name "Big Outcome"
;;                                   :tag "bo")))
;;   :config
;;   (org-super-agenda-mode))

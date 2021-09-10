(setq user-full-name "Ivan Trajkov"
      user-mail-address "itrajkov999@gmail.com")

(defun greedily-do-daemon-setup ()
  (require 'org)
  (when (require 'mu4e nil t)
    (setq mu4e-confirm-quit t)
    (setq +mu4e-lock-greedy t)
    (setq +mu4e-lock-relaxed t)))

(when (daemonp)
  (add-hook 'emacs-startup-hook #'greedily-do-daemon-setup)
  (add-hook! 'server-after-make-frame-hook (switch-to-buffer +doom-dashboard-name)))

(setq doom-fallback-buffer-name "► Doom"
      +doom-dashboard-name "► Doom")

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
      :desc "Hackernews"
      "o h n" #'hackernews)

(map! :map evil-motion-state-map "C-u" #'my/evil-scroll-up-and-center)
(map! :map evil-motion-state-map "C-d" #'my/evil-scroll-down-and-center)
(map! :map evil-normal-state-map "C-x" #'evil-numbers/dec-at-pt-incremental)
(map! :map evil-normal-state-map "C-a" #'evil-numbers/inc-at-pt-incremental)
(map! :map evil-normal-state-map "C--" #'doom/decrease-font-size)
(map! :map evil-normal-state-map "C-+" #'doom/increase-font-size)

(setq doom-font (font-spec :family "Hack Nerd Font" :size 15))
(setq doom-unicode-font (font-spec :family "Material Icons" :size 25))

(setq display-line-numbers-type 'relative)
(setq truncate-lines nil)
(setq scroll-margin 9)

(setq doom-theme 'doom-nord-light)

(custom-set-faces!
  '(mode-line :family "Noto Sans" :height 0.9)
  '(mode-line-inactive :family "Noto Sans" :height 0.9))

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(setq mu4e-change-filename-when-moving t)
(setq mu4e-get-mail-command "mbsync -a")
(setq mu4e-maildir "~/Mail")

(setq message-send-mail-function 'smtpmail-send-it)
(setq mu4e-compose-context-policy 'ask-if-none)
(setq smtpmail-queue-mail t)  ;; start in queuing mode
(after! mu4e (setq mu4e-update-interval (* 5 60)))

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

                    ;; Ivchepro gmail
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

(use-package erc-log :after erc)
(use-package erc-notify :after erc)
(use-package erc-nick-notify :after erc)
(use-package erc-spelling :after erc)
(use-package erc-autoaway :after erc)


(use-package erc
  :commands erc erc-tls
  :config
    ;; Join the a couple of interesting channels whenever connecting to Freenode.
    (setq erc-autojoin-channels-alist '(("myanonamouse.net"
                                        "#am-members")
                                        ("libera.chat"
                                        "#spodeli")))

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
    (if (get-buffer "irc.libera.chat:6697")
        (erc-track-switch-buffer 1)
        (when (y-or-n-p "Start ERC? ")
        (erc-tls :server "irc.libera.chat" :port 6697 :nick "ivche")
        (erc-tls :server "irc.myanonamouse.net" :port 6697 :nick "Ivche1337")
        )))

    (defun my/erc-count-users ()
    "Displays the number of users connected on the current channel."
    (interactive)
    (if (get-buffer "irc.libera.chat:6697")
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
        (erc-quit-server "cya nerds! - sent from ERC"))))
)

(use-package erc-hl-nicks
  :after erc)

(setq default-tab-width 4)
(setq company-minimum-prefix-length 2)
(setq company-idle-delay 0)

(setq org-list-demote-modify-bullet '(("+" . "-") ("-" . "+") ("*" . "+") ("1." . "a.")))
(setq org-directory "~/Dropbox/org")

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

(setq org-agenda-files '("~/Dropbox/org/ivches-system/Personal"))
(setq org-agenda-search-headline-for-time nil)
(setq org-agenda-custom-commands
      '(("h" "Daily habits"
         ((agenda ""))
         ((org-agenda-show-log t)
          (org-agenda-ndays 11)
          (org-agenda-log-mode-items '(state))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp ":DAILY:"))))
        ))

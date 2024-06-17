;;; erlang-ts-imenu --- Jump-tables for imenu.
;;; Commentary:
;;; e.g. by
;;; M-x imenu[RET] CATEGORY[RET] DISPLAY-NAME[RET]
;;;
;;; When testing remember to evaluate `imenu-flush-cache' in between
;;; reevaluations of any of these functions to clear the imenu cache.
;;;
;;; You can use `treesit-explore-mode' to find the nodes to match.
;;; Code:

(require 'treesit)
(defun erlang-ts-imenu-function-node-p (node)
  "Predicate for NODE being a function."
  (let ((node-type (treesit-node-type node)))
    (string-match-p "function_clause" node-type)))

(defun erlang-ts-imenu-function-name (node)
  "Return NODEs function name and args as a string."
  (let ((fun-name (treesit-node-text (treesit-node-child-by-field-name node "name")))
        (fun-args (treesit-node-text (treesit-node-child-by-field-name node "args"))))
    (concat fun-name fun-args)))

(defun erlang-ts-imenu-spec-node-p (node)
  "Predicate for NODE being a spec."
  (let ((node-type (treesit-node-type node)))
    (string-match-p "spec" node-type)))

(defun erlang-ts-imenu-spec-name (node)
  "Return NODEs spec as a string."
  (let* ((fun-name (treesit-node-text (treesit-node-child-by-field-name node "fun")))
         (type-sig (treesit-node-child node 1 t))
         (fun-args (treesit-node-text (treesit-node-child-by-field-name type-sig "args")))
         (fun-return (treesit-node-text (treesit-node-child-by-field-name type-sig "ty"))))
    (concat fun-name fun-args " -> " fun-return)))

(defun erlang-ts-imenu-type-node-p (node)
  "Predicate for NODE being a type alias."
  (let ((node-type (treesit-node-type node)))
    (string-match-p "type_alias" node-type)))

(defun erlang-ts-imenu-type-name (node)
  "Return NODEs type alias as a string."
  (let ((type-name (treesit-node-text (treesit-node-child-by-field-name node "name")))
        (type-def (treesit-node-text (treesit-node-child node 1 t))))
    (concat type-name " :: " type-def)))

(defun erlang-ts-imenu-record-node-p (node)
  "Predicate for NODE being a record declaration."
  (let ((node-type (treesit-node-type node)))
    (string-match-p "record_decl" node-type)))

(defun erlang-ts-imenu-node-name (node)
  "Return NODEs name."
  (treesit-node-text (treesit-node-child-by-field-name node "name")))

(defun erlang-ts-imenu-record-name (node)
  "Return NODEs record field names."
  (let ((rec-name (erlang-ts-imenu-node-name node))
        (rec-fields (cdr (treesit-node-children node t))))
    (concat "#" rec-name "{" (mapconcat 'erlang-ts-imenu-node-name rec-fields ", ") "}")))

(defun erlang-ts-treesit-simple-imenu-settings-setup()
  "Set up imenu for treesit."
  (setq-local treesit-simple-imenu-settings
              ;; List is in the form (CATEGORY NODE-MATCH-P-FUNCTION ? DISPLAY-FUNCTION)
              `(("funs" erlang-ts-imenu-function-node-p nil erlang-ts-imenu-function-name)
                ("specs" erlang-ts-imenu-spec-node-p nil erlang-ts-imenu-spec-name)
                ("types" erlang-ts-imenu-type-node-p nil erlang-ts-imenu-type-name)
                ("records" erlang-ts-imenu-record-node-p nil erlang-ts-imenu-record-name))))

(provide 'erlang-ts-imenu)
;;; erlang-ts-imenu.el ends here

; Code by Jada Bonnett and Noah Gegner

(defun check_facts (con facts)
    (if (null facts)
        nil
        (if (eql (car facts) con)
            t
            (check_facts con (cdr facts))))
)

(defun check_and_recursive (facts rules current_rule)
    (if (null current_rule)
        t
        (if (prove? (car current_rule) facts rules)
            (check_and_recursive facts rules (cdr current_rule))
            nil
        )
    )
)

(defun check_or_recursive (facts rules current_rule)
    (if (null current_rule)
        nil
        (if (prove? (car current_rule) facts rules)
            t
            (check_or_recursive facts rules (cdr current_rule))
        )
    )
)

(defun check_rules_helper (con facts rules all_rules)
    (or
        (check_current_rule con facts rules all_rules)
        (check_rules con facts (cdr rules) all_rules)
    )
)

(defun check_list_con (con facts rules)
    (if (eql (car con) 'AND)
        (check_and_recursive facts rules (cdr con))
        (if (eql (car con) 'OR)
            (check_or_recursive facts rules (cdr con))
        )
    )
)

(defun check_current_rule (con facts rules all_rules)
    (setf current_rule (car rules))
    (if (typep con 'list)
        (check_list_con con facts all_rules)
        (if (eql (car (cdr current_rule)) con)
            (if (eql (car (car current_rule)) 'AND)
                (progn
                    (setf and_result (check_and_recursive facts all_rules (cdr (car current_rule))))
                    (if and_result
                        (format t "~A proved by ~A~%" con current_rule)
                    )
                    (or
                        and_result
                        (check_rules con facts (cdr rules) all_rules)
                    )
                )
                (if (eql (car (car current_rule)) 'OR)
                    (progn
                        (setf or_result (check_or_recursive facts all_rules (cdr (car current_rule))))
                        (if or_result
                            (format t "~A proved by ~A~%" con current_rule)
                        )
                        (or
                            or_result
                            (check_rules con facts (cdr rules) all_rules)
                        )
                    )
                    (if (eql (car (car current_rule)) 'NOT)
                        (progn
                            (setf not_result (prove? (car (cdr (car current_rule))) facts all_rule))
                            (if not_result
                                (format t "~A proved by ~A~%" con current_rule)
                            )
                            (or
                                not_result
                                (check_rules con facts (cdr rules) all_rules)
                            )
                        )
                        (progn
                            (setf result (prove? (car (car current_rule)) facts all_rules))
                            (if result
                                (format t "~A proved by ~A~%" con current_rule)
                            )
                            (or
                                result
                                (check_rules con facts (cdr rules) all_rules)
                            )
                        )
                    )
                )
            )
        )
    )
)

(defun check_rules (con facts rules all_rules)
    (if (null rules)
        (progn
            (format t "Failed to prove ~A~%" con)
            nil
        )
        (check_rules_helper con facts rules all_rules)
    )
)

(defun prove? (con facts rules)
    (if (check_facts con facts)
        (progn
            (format t "~A is a fact~%" con)
            t
        )
        (check_rules con facts rules rules)
    )
)

(setf rules '(
 ((and A B) D)
 ((or A C) E)
 ((or (not B) A) F)
 ((F) G)
 ((and F (or H D)) I)
 ((or (not D) (and Y F)) J)
 ))

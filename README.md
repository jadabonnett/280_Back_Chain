# 280_Back_Chain

For this project, the goal was to create a backwards-chaining expert system in lisp, that took in a letter, and proved it based off of the given rules and facts handed to it.
For example, if handed: 

(setf facts '(A B C))

(setf rules '(
 ((and A B) D)
 ((or A C) E)
 ((or (not B) A) F)
 ((F) G)
 ((and F (or H D)) I)
 ((or (not D) (and Y F)) J)
 ))

(prove? 'A facts rules)

the prove function would return true, since it's in the facts.

(prove? 'G facts rules) 

this would also work, becuase of the various rules that tie back into the facts. So, G is provable, and returns true.

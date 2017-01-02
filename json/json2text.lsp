(context 'json)

(define (have-atom? lst)
  (and (list? lst)
       (not (empty? lst))
       (apply or (map atom? lst))))

(define (pairs? lst)
  (and (list? lst)
       (= 2 (length lst))
       (first lst)
       (string? (first lst))
       (last lst)))

(define (json-obj-expr? lst)
  (and (list? lst)
       (not (empty? lst))
       (pairs? (first lst))))

(define (all-json-obj? arr)
  (and (list? arr)
       (apply and (map json-obj-expr? arr))))

(define (json-array-expr? lst)
  (and (list? v)
       (not (empty? v))
       (or (have-atom? v)
           (all-json-obj? v))))

(define (value2text v)
  (cond
   ((atom? v) (cond
               ((symbol? v) (let (sep (find ":" (string v)))
                              (if sep
                                  ((+ sep 1) (string v))
                                  (string v))))
               ((string? v) (append "\"" v "\""))
               ((number? v) (string v))
               (true (string v))))
   ((pairs? v)
    (append "\"" (v 0) "\" : " (value2text (v 1))))
   ((json-obj-expr? v)
    (let ((n (length v)) (str ""))
      (for (i 0 (- n 1) 1)
           (if (!= 0 i)
               (setq str (append str ", " (value2text (v i))))
               (setq str (append str (value2text (v i))))))
      (append "{" str "}")))
   ((json-array-expr? v)
    (let ((n (length v)) (str ""))
        (for (i 0 (- n 1) 1)
             (if (!= 0 i)
                 (setq str (append str ", " (value2text (v i))))
                 (setq str (append str (value2text (v i))))))
        (append "[" str "]")))
   (true nil)))

(define (expr2text lst)
  (cond
   ((atom? lst) nil)
   (true (value2text lst))))

(context MAIN)

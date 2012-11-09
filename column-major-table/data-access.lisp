(in-package :numeric-table)

(defmethod table-size ((table column-major-table))
  (list (row-count table) (column-count table)))

(defmethod nth-row ((n integer) (table column-major-table))
  (with-slots (row-count column-count table) table
      (assert (< n row-count) ()
	      "Row index ~a exceeds row-count ~a" n row-count)
    (let ((row (make-array column-count)))
      (loop :for column across table
	 :for i from 0
	 :do (setf (aref row i) (aref column n)))
      row)))

(defmethod nth-column ((n integer) (table column-major-table))
  (with-slots (column-count table) table
  (assert (< n column-count) ()
	  "Column index ~a is greater than number of columns ~a"
	  n column-count)
  (aref table n)))

(define-test table-column
  (with-bare-test-table
    (insert-row '(3 4) test-table)
    (insert-row '(8 5) test-table)
    (assert-number-equal 2 (row-count test-table))
    (assert-numerical-equal #(3 4)
			    (nth-row 0 test-table))
    (assert-numerical-equal #(8 5)
			    (nth-row 1 test-table))
    (assert-numerical-equal #(3 8)
			    (table-column 0 test-table))))


(defmethod table-column ((column-name symbol)
			 (table column-major-table))
  "Return column contents of column matching COLUMN-NAME"
  (nth-column
   (position column-name (table-schema table)
	     :key #'name)
   table))

(defmethod table-column ((column-index integer)
			 (table column-major-table))
  "Return column contents of column at COLUMN-INDEX position"
  (nth-column column-index table))
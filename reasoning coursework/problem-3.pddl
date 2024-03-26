(define (problem supermarketextension2)
  (:domain supermarketextension2)
  
  (:objects
    c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 - cell
    s1 s2 s3 s4 s5 s6 s7 s8 - cell 
    stack - cell
    checkout - cell
    scale - cell
    station - cell
    cabbage potato ice_lolly pizza toothpaste shampoo bread ketchup - item
    b1 b2 - basket 
    shopbot - robot
  )

  (:init
    ;; Define the aisle cells
    (is-aisle c1) (is-aisle c2) (is-aisle c3) (is-aisle c4) (is-aisle c5)
    (is-aisle c6) (is-aisle c7) (is-aisle c8) (is-aisle c9) (is-aisle c10)
    (is-aisle c11) (is-aisle c12) (is-aisle c13) (is-aisle c14) (is-aisle c15)
    (is-aisle c16) (is-aisle c17) (is-aisle c18) (is-aisle c19) (is-aisle c20)

    ;; define the shelves
    (is-shelf s1) (is-shelf s2) (is-shelf s3) (is-shelf s4) (is-shelf s5)
    (is-shelf s6) (is-shelf s7) (is-shelf s8)

    ;; Define the special cells
    (is-scale scale) 
    (is-checkout checkout)
    (is-stack-of-baskets stack)
    (is-top-up-station station)

    ;; Define the adjacencies
    (adjacent scale c4) (adjacent scale c1) 
    (adjacent c1 scale) (adjacent c1 s3) (adjacent c1 c2)
    (adjacent c2 c1) (adjacent c2 s4) (adjacent c2 c3)
    (adjacent c3 c2) (adjacent c3 c5) (adjacent c3 s1)
    (adjacent s1 c3) (adjacent s1 c6) (adjacent s1 s2)
    (adjacent s2 s1) (adjacent s2 c7) (adjacent s2 station)
    (adjacent station s2) (adjacent station c8)
    (adjacent c4 c9) (adjacent c4 s3) (adjacent c4 scale)
    (adjacent s3 c4) (adjacent s3 c10) (adjacent s3 s4) (adjacent s3 c1)
    (adjacent s4 s3) (adjacent s4 c11) (adjacent s4 c5) (adjacent s4 c2)
    (adjacent c5 s4) (adjacent c5 c12) (adjacent c5 c6) (adjacent c5 c3)
    (adjacent c6 c5) (adjacent c6 s5) (adjacent c6 c7) (adjacent c6 s1)
    (adjacent c7 c6) (adjacent c7 s6) (adjacent c7 c8) (adjacent c7 s2)
    (adjacent c8 c7) (adjacent c8 c13) (adjacent c8 station)
    (adjacent c9 c14) (adjacent c9 c10) (adjacent c9 c4)
    (adjacent c10 c9) (adjacent c10 s7) (adjacent c10 c11) (adjacent c10 s3)
    (adjacent c11 c10) (adjacent c11 s8) (adjacent c11 c12) (adjacent c11 s4)
    (adjacent c12 c11) (adjacent c12 c15) (adjacent c12 s5) (adjacent c12 c5)
    (adjacent s5 c12) (adjacent s5 c16) (adjacent s5 s6) (adjacent s5 c6)
    (adjacent s6 s5) (adjacent s6 c17) (adjacent s6 c13) (adjacent s6 c7)
    (adjacent c13 s6) (adjacent c13 c18) (adjacent c13 c8)
    (adjacent c14 checkout) (adjacent c14 s7) (adjacent c14 c9)
    (adjacent s7 c14) (adjacent s7 s8) (adjacent s7 c10)
    (adjacent s8 s7) (adjacent s8 c15) (adjacent s8 c11)
    (adjacent c15 s8) (adjacent c15 c16) (adjacent c15 c12)
    (adjacent c16 c15) (adjacent c16 stack) (adjacent c16 c17) (adjacent c16 s5)
    (adjacent c17 c16) (adjacent c17 c19) (adjacent c17 c18) (adjacent c17 s6)
    (adjacent c18 c17) (adjacent c18 c20) (adjacent c18 c13)
    (adjacent checkout c14)
    (adjacent stack c19) (adjacent stack c16)
    (adjacent c19 stack) (adjacent c19 c20) (adjacent c19 c17)
    (adjacent c20 c19) (adjacent c20 c18)

    ;; Define the initial bot position and state
    (bot-is-at shopbot c20)
    (empty-hands shopbot)
    
    ;; Define where the items are
    (item-is-at ice_lolly s1) 
    (item-is-at pizza s2) 
    (item-is-at cabbage s3) 
    (item-is-at potato s4)
    (item-is-at toothpaste s5) 
    (item-is-at shampoo s6) 
    (item-is-at bread s7) 
    (item-is-at ketchup s8)

    ;; Define where the baskets are
    (basket-is-at b1 stack)
    (basket-is-at b2 stack)
    
    ;; Define items that need weighing
    (needs-weighing cabbage)
    (needs-weighing potato)

    ;; Define items that have to be checked out
    (needs-to-be-checked-out potato)
    (needs-to-be-checked-out ketchup)
    (needs-to-be-checked-out toothpaste)
    (needs-to-be-checked-out pizza)

    ;; define the credit balance and price of items
    (= (credit-balance shopbot) 15)
    (= (price ice_lolly) 4)
    (= (price pizza) 6)
    (= (price cabbage) 3)
    (= (price potato) 4)
    (= (price toothpaste) 7)
    (= (price shampoo) 9)
    (= (price bread) 5)
    (= (price ketchup) 8)
  )

  (:goal
    (and
      (checked-out potato) 
      (checked-out ketchup) 
      (checked-out toothpaste) 
      (checked-out pizza)
    )
  )
)

(define (problem supermarket-problem-1-hard)
  (:domain supermarket)
  
  (:objects
    c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 - cell
    s1 s2 s3 s4 s5 s6 s7 s8 S9 S10 s11 - cell 
    checkout - cell
    scale - cell
    onion cabbage potato ice_lolly tomato pizza toothpaste shampoo bread ketchup toothbrush - item
    shopbot - robot
  )

  (:init
    ;; Define the aisle cells
    (is-aisle c1) (is-aisle c2) (is-aisle c3) (is-aisle c4) (is-aisle c5)
    (is-aisle c6) (is-aisle c7) (is-aisle c8) (is-aisle c9) (is-aisle c10)
    (is-aisle c11) (is-aisle c12) (is-aisle c13) (is-aisle c14) (is-aisle c15)
    (is-aisle c16) (is-aisle c17) (is-aisle c18)

    ;; define the shelves
    (is-shelf s1) (is-shelf s2) (is-shelf s3) (is-shelf s4) (is-shelf s5)
    (is-shelf s6) (is-shelf s7) (is-shelf s8) (is-shelf s9) (is-shelf s10)
    (is-shelf s11)

    ;; Define the special cells
    (is-scale scale) 
    (is-checkout checkout)

    ;; Define adjacencies
    (adjacent s1 s4) (adjacent s1 c1)
    (adjacent c1 s1) (adjacent c1 s5) (adjacent c1 c2)
    (adjacent c2 c1) (adjacent c2 s6) (adjacent c2 c3)
    (adjacent c3 c2) (adjacent c3 c4) (adjacent c3 s2)
    (adjacent s2 c3) (adjacent s2 c5) (adjacent s2 s3)
    (adjacent s3 s2) (adjacent s3 c6)
    (adjacent s4 c7) (adjacent s4 s5) (adjacent s4 s1)
    (adjacent s5 s4) (adjacent s5 c8) (adjacent s5 s6) (adjacent s5 c1)
    (adjacent s6 s5) (adjacent s6 c9) (adjacent s6 c4) (adjacent s6 c2)
    (adjacent c4 s6) (adjacent c4 c10) (adjacent c4 c5) (adjacent c4 c3)
    (adjacent c5 c4) (adjacent c5 s8) (adjacent c5 c6) (adjacent c5 s2)
    (adjacent c6 c5) (adjacent c6 s9) (adjacent c6 s7) (adjacent c6 s3)
    (adjacent s7 c6) (adjacent s7 c11) 
    (adjacent c7 c12) (adjacent c7 c8) (adjacent c7 s4)
    (adjacent c8 c7) (adjacent c8 s10) (adjacent c8 c9) (adjacent c8 s5)
    (adjacent c9 c8) (adjacent c9 s11) (adjacent c9 c10) (adjacent c9 s6)
    (adjacent c10 c9) (adjacent c10 c13) (adjacent c10 s8) (adjacent c10 c4)
    (adjacent s8 c10) (adjacent s8 c14) (adjacent s8 s9) (adjacent s8 c5)
    (adjacent s9 s8) (adjacent s9 c15) (adjacent s9 c11) (adjacent s9 c6)
    (adjacent c11 s9) (adjacent c11 c16) (adjacent c11 s7)
    (adjacent c12 checkout) (adjacent c12 s10) (adjacent c12 c7)
    (adjacent s10 c12) (adjacent s10 s11) (adjacent s10 c8)
    (adjacent s11 s10) (adjacent s11 c13) (adjacent s11 c9)
    (adjacent c13 s11) (adjacent c13 c14) (adjacent c13 c10)
    (adjacent c14 c13) (adjacent c14 scale) (adjacent c14 c15) (adjacent c14 s8)
    (adjacent c15 c14) (adjacent c15 c17) (adjacent c15 c16) (adjacent c15 s9)
    (adjacent c16 c15) (adjacent c16 c18) (adjacent c16 c11)
    (adjacent checkout c12)
    (adjacent scale c17) (adjacent scale c14)
    (adjacent c17 scale) (adjacent c17 c18) (adjacent c17 c15)
    (adjacent c18 c17) (adjacent c18 c16)

    ;; Define the initial bot position
    (bot-is-at shopbot c18)
    
    ;; Define where the items are
    (item-is-at onion s1) 
    (item-is-at ice_lolly s2) 
    (item-is-at tomato s3) 
    (item-is-at pizza s4)
    (item-is-at cabbage s5) 
    (item-is-at potato s6) 
    (item-is-at toothbrush s7) 
    (item-is-at toothpaste s8)
    (item-is-at shampoo s9) 
    (item-is-at bread s10) 
    (item-is-at ketchup s11)

    ;; Define initial bot state
    (empty-hands shopbot)
    
    ;; Define items that need weighing
    (needs-weighing onion)
    (needs-weighing tomato)
    (needs-weighing cabbage)
    (needs-weighing potato)
  )

  (:goal
    (and
      (checked-out potato) 
      (checked-out onion) 
      (checked-out ketchup) 
      (checked-out toothpaste) 
      (checked-out toothbrush)
      (checked-out pizza)
      (checked-out cabbage)
      (checked-out tomato)
    )
  )
)
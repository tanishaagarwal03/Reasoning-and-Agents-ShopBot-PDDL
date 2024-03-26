(define (domain supermarket)
  (:requirements :strips :typing)

  (:types
    cell                 ;; Represents each cell to check location of the object
    item                 ;; Shopping items
    robot                
  )

  (:predicates
    (is-aisle ?c - cell)             ;; Checks if a cell is part of the aisles.
    (is-scale ?c - cell)             ;; Identifies a cell as containing a weighing scale.
    (is-shelf ?c - cell)             ;; Identifies a cell as containing a shelf.
    (is-checkout ?c - cell)          ;; Identifies a cell as containing a checkout stand.
    (adjacent ?c1 ?c2 - cell)        ;; Cells are adjacent if ShopBot is up, down, left or right from it.

    (bot-is-at ?r - robot ?c - cell) ;; ShopBot is at a certain cell.
    (empty-hands ?r - robot)         ;; Indicates the ShopBot is not holding any items.
    (holding ?r - robot ?i - item)   ;; ShopBot is holding an item.

    (item-is-at ?i - item ?c - cell) ;; Item is at a certain cell/shelf.
    (needs-weighing ?i - item)       ;; Item needs to be weighed if you want to checkout.
    (weighed ?i - item)              ;; Item has been weighed.

    (ready-for-checkout ?i)          ;; Indicates item is ready for checkout, assuming all conditions met (weighed if needed).
    (checked-out ?i - item)          ;; Item has been checked out.
  )

  ;; ShopBot can move (only) between two adjacent aisle cells. 
  ;; ShopBot cannot move diagonally.
  (:action move 
    :parameters (?r - robot ?from - cell ?to - cell)
    :precondition (
      and 
        (is-aisle ?from)            
        (is-aisle ?to)               
        (not (is-checkout ?to))
        (not (is-shelf ?to))
        (not (is-scale ?to))
        (adjacent ?from ?to)        
        (bot-is-at ?r ?from))        
    :effect (
      and 
        (bot-is-at ?r ?to)           ;; bot is at target cell
        (not (bot-is-at ?r ?from)))  ;; bot is not at starting cell
  )

  ;; ShopBot can pick up an object if ShopBot is in a cell adjacent to the location containing the item. 
  ;; ShopBot can hold at most one object at a time.
  (:action pick-up 
    :parameters (?r - robot ?i - item ?c - cell ?to - cell)
    :precondition (
      and 
        (bot-is-at ?r ?to) 
        (is-shelf ?c)
        (item-is-at ?i ?c) 
        (adjacent ?c ?to) 
        (empty-hands ?r))
    :effect (
      and 
        (holding ?r ?i) 
        (not (empty-hands ?r))
        (not (item-is-at ?i ?c)))
  )
  
  ;; ShopBot can drop an object it is carrying to an adjacent target location, freeing its hand.
  ;; It seems needlessly inefficient to allow the bot to drop an item at any location, 
  ;; therefore, we only allow the bot to drop the item at checkout
  (:action drop
    :parameters (?r - robot ?i - item ?from - cell ?to - cell)
    :precondition (
      and 
        (holding ?r ?i)
        (adjacent ?from ?to)
        (bot-is-at ?r ?from)
        (is-checkout ?to))
    :effect (
      and 
        (not (holding ?r ?i)) 
        (empty-hands ?r)
        (item-is-at ?i ?to)
        (ready-for-checkout ?i))
  )

  ;; ShopBot can weigh a shopping item at an adjacent weighing scale. 
  ;; The item has to be of type that needs to be weighed before checkout.
  (:action weigh-item
    :parameters (?r - robot ?i - item ?from - cell ?to - cell)
    :precondition (
      and 
        (bot-is-at ?r ?from)
        (holding ?r ?i) 
        (adjacent ?from ?to)
        (is-scale ?to)
        (needs-weighing ?i)
        (not (weighed ?i)))
    :effect (and (weighed ?i))
  )
  
  ;; ShopBot can check out a shopping item placed on an adjacent checkout stand. 
  ;; ShopBot must not be holding anything when checking out an item. 
  ;; Weighable items must have been weighed beforehand.
  (:action check-out
    :parameters (?r - robot ?i - item ?to - cell ?from - cell)
    :precondition (
      and 
        (bot-is-at ?r ?from)
        (ready-for-checkout ?i)
        (is-checkout ?to)
        (item-is-at ?i ?to) 
        (adjacent ?from ?to)
        (or (not (needs-weighing ?i)) (weighed ?i)))
    :effect (
      and 
        (checked-out ?i)
        (not (item-is-at ?i ?to))
        (not (ready-for-checkout ?i)))  ;; Clean up, item is no longer ready for checkout
  )
)
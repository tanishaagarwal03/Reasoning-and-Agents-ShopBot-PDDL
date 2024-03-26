(define (domain supermarketextension1)
  (:requirements :strips :typing)
  
  ;; Define types
  (:types
    cell                 ;; Represents each cell to check location of the object
    item                 ;; Shopping items
    robot                
    basket
  )

  (:predicates

    (is-aisle ?c - cell)                ;; Checks if a cell is part of the aisles.
    (is-scale ?c - cell)                ;; Identifies a cell as containing a weighing scale.
    (is-shelf ?c - cell)                ;; Identifies a cell as containing a shelf.
    (is-checkout ?c - cell)             ;; Identifies a cell as containing a checkout stand.
    (is-stack-of-baskets ?c - cell)     ;; Identifies a cell as a location for picking up baskets.
    (adjacent ?c1 ?c2 - cell)           ;; Cells are adjacent if ShopBot is up, down, left, or right from it.

    (bot-is-at ?r - robot ?c - cell)        ;; ShopBot is at a certain cell.
    (empty-hands ?r - robot)                ;; Indicates the ShopBot is not holding any items or baskets.
    (holding-basket ?r - robot ?b - basket) ;; ShopBot is holding a basket.
    (basket-is-at ?b - basket ?c - cell)    ;; Indicates the location of a basket.
    (basket-is-empty ?b)                    ;; Indicates whether a basket is empty.

    (item-is-at ?i - item ?c - cell)    ;; Item is at a certain cell/shelf.
    (contains ?b - basket ?i - item)    ;; A basket contains an item.
    (needs-weighing ?i - item)          ;; Item needs to be weighed if you want to checkout.
    (weighed ?i - item)                 ;; Item has been weighed.
    
    (needs-to-be-checked-out ?i - item) ;; Item needs to be checked out before leaving.
    (checked-out ?i - item)             ;; Item has been checked out.
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

  (:action pickup_basket
    :parameters (?r - robot ?b - basket ?from - cell ?to - cell)
    :precondition (
      and 
        (is-stack-of-baskets ?from)
        (bot-is-at ?r ?to)              ;; Shopbot is at starting cell
        (adjacent ?from ?to)            ;; Shopbot and stack of baskets is adjacent
        (not (holding-basket ?r ?b))    ;; Shopbot is not holding basket 
        (empty-hands ?r)
        (basket-is-at ?b ?from))
    :effect (
      and  
        (not (empty-hands ?r))
        (holding-basket ?r ?b))         ;; Basket is being held
   )

  ;; ShopBot can pick up an item if ShopBot is in a cell adjacent to the location containing the item. 
  ;; ShopBot can hold at most one object at a time which will be the basket here.
  (:action put-in-basket
    :parameters (?r - robot ?i - item ?from - cell ?to - cell ?b - basket)
    :precondition (
      and 
        (bot-is-at ?r ?to) 
        (is-shelf ?from)
        (item-is-at ?i ?from) 
        (adjacent ?from ?to) 
        (holding-basket ?r ?b)
        (needs-to-be-checked-out ?i))
    :effect (
      and 
        (contains ?b ?i)
        (not (basket-is-empty ?b))
        (not (item-is-at ?i ?from)))
  )
  
  ;; ShopBot can drop an object it is carrying to an adjacent target location, freeing its hand.
  ;; It seems needlessly inefficient to allow the bot to drop an item at any location, 
  ;; therefore, we only allow the bot to drop the item at checkout
  (:action drop-basket
    :parameters (?r - robot ?from - cell ?to - cell ?b - basket)
    :precondition (
      and 
        (holding-basket ?r ?b)
        (adjacent ?from ?to)
        (bot-is-at ?r ?from)
        (not (basket-is-empty ?b))
        (is-checkout ?to))
    :effect (
      and 
        (not (holding-basket ?r ?b))
        (empty-hands ?r)
        (basket-is-at ?b ?to))
  )

  ;; ShopBot can weigh a shopping item at an adjacent weighing scale. 
  ;; The item has to be of type that needs to be weighed before checkout.
  (:action weigh-item
    :parameters (?r - robot ?i - item ?from - cell ?to - cell ?b - basket)
    :precondition (
      and 
        (bot-is-at ?r ?from)
        (holding-basket ?r ?b) 
        (adjacent ?from ?to)
        (is-scale ?to)
        (contains ?b ?i)
        (needs-weighing ?i)
        (not (weighed ?i)))
    :effect (and (weighed ?i))
  )
  
  ;; ShopBot can check out a shopping item placed on an adjacent checkout stand. 
  ;; ShopBot must not be holding anything when checking out an item. 
  ;; Weighable items must have been weighed beforehand.
  (:action check-out
    :parameters (?r - robot ?i - item ?to - cell ?from - cell ?b - basket ?c - cell)
    :precondition (
      and 
        (bot-is-at ?r ?from)
        (is-checkout ?to)
        (contains ?b ?i)
        (adjacent ?from ?to)
        (basket-is-at ?b ?to)
        (needs-to-be-checked-out ?i)
        (or (not (needs-weighing ?i)) (weighed ?i))
        (is-stack-of-baskets ?c))
    :effect (
      and 
        (checked-out ?i)
        (not (contains ?b ?i))
        (basket-is-at ?b ?to)
        (not (basket-is-at ?b ?c)))
  )

  (:action return-basket
    :parameters (?r - robot ?from - cell ?to - cell ?b - basket ?c - cell)
    :precondition (
      and 
        (bot-is-at ?r ?from) 
        (is-checkout ?to)
        (adjacent ?from ?to)
        (basket-is-at ?b ?to)
        (basket-is-empty ?b))
    :effect (
      and 
        (not (holding-basket ?r ?b))
        (empty-hands ?r)
        (and (basket-is-at ?b ?c) (is-stack-of-baskets ?c)))
  )
)

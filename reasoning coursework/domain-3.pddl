(define (domain supermarketextension2)
  (:requirements :strips :typing :fluents)
  
  ;; Define types
  (:types
    cell                 ;; Represents each cell to check location of the object
    item                 ;; Shopping items
    robot                ;; The ShopBot
    basket
  )

  (:functions
    (credit-balance ?r - robot)       ;; Track the credit balance of ShopBot
    (price ?i - item)                 ;; Price of each item
  )
  
  (:predicates

    (is-aisle ?c - cell)                   ;; Checks if a cell is part of the aisles.
    (is-scale ?c - cell)                   ;; Identifies a cell as containing a weighing scale.
    (is-shelf ?c - cell)                   ;; Identifies a cell as containing a shelf.
    (is-checkout ?c - cell)                ;; Identifies a cell as containing a checkout stand.
    (is-top-up-station ?c - cell)          ;; Identifies a cell as a top-up station for adding credits.
    (is-stack-of-baskets ?c - cell)        ;; Identifies a cell as containing a stack of baskets.
    (adjacent ?c1 ?c2 - cell)              ;; Cells are adjacent if ShopBot can move directly between them.

    (bot-is-at ?r - robot ?c - cell)       ;; ShopBot is at a specific cell.
    (empty-hands ?r - robot)               ;; Indicates the ShopBot is not holding any items or baskets.
    (holding-basket ?r - robot ?b - basket);; ShopBot is holding a specific basket.
    (basket-is-at ?b - basket ?c - cell)   ;; A basket is located at a specific cell.
    (basket-is-empty ?b)                   ;; Indicates a basket is empty, containing no items.
    (contains ?b - basket ?i - item)       ;; A basket contains a specific item.

    (item-is-at ?i - item ?c - cell)       ;; An item is located at a specific cell/shelf.
    (needs-weighing ?i - item)             ;; An item needs to be weighed before checkout.
    (weighed ?i - item)                    ;; Indicates an item has been weighed.

    (needs-to-be-checked-out ?i - item)    ;; An item needs to be checked out.
    (checked-out ?i - item)                ;; Indicates an item has been checked out.
  )

  ;; ShopBot can move (only) between two adjacent aisle cells. ShopBot cannot move diagonally.
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
  (:action pickup_basket
    :parameters (?r - robot ?b - basket ?from - cell ?to - cell)
    :precondition (
      and 
        (is-stack-of-baskets ?from)
        (bot-is-at ?r ?to)              ; Shopbot is at starting cell
        (adjacent ?from ?to)            ; Shopbot and stack of baskets is adjacent
        (not (holding-basket ?r ?b))    ; Shopbot is not holding basket 
        (empty-hands ?r)
        (basket-is-at ?b ?from))
    :effect (
      and  
        (not (empty-hands ?r))
        (holding-basket ?r ?b))       ; Basket is being held
   )

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
  ;; It seems needlessly inefficient to allow the bot to drop an object at any location, 
  ;; thus, we only allow the bot to drop the basket at checkout
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
  
  (:action top-up-credits
    :parameters (?r - robot ?from - cell ?to - cell)
    :precondition (
      and
        (is-top-up-station ?from)
        (bot-is-at ?r ?to)
        (adjacent ?from ?to))
    :effect (increase (credit-balance ?r) 5)
  )

  ;; ShopBot can check out a shopping item placed on an adjacent checkout stand. 
  ;; ShopBot must not be holding anything when checking out an item. Weighable items must have been weighed beforehand.
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
        (>= (credit-balance ?r) (price ?i))  ;; Ensure enough credits
        (or (not (needs-weighing ?i)) (weighed ?i))
        (is-stack-of-baskets ?c))
    :effect (
      and 
        (checked-out ?i)
        (not (contains ?b ?i))
        (basket-is-at ?b ?to)
        (decrease (credit-balance ?r) (price ?i))  ;; Deduct price from balance
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

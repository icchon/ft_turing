open Action

module Tape = struct
  type t = {
    left: char list;
    head: char;
    right: char list;
    blank: char;
  }

  let string_of_tape tape =
    let left_part = List.rev tape.left in
    let s_left = String.of_seq (List.to_seq left_part) in 
    let s_right = String.of_seq (List.to_seq tape.right) in
    let s_head = Printf.sprintf "{%c}" tape.head in
    s_left ^ s_head ^ s_right
  
  let create input blank = 
    let char_list = List.of_seq (String.to_seq input) in
    match char_list with
    | [] -> {
      left = [];
      head = blank;
      right = [];
      blank = blank;
    }
    | x::xs -> {
      left = [];
      head = x;
      right = xs;
      blank = blank;
    }

  let write tape c = 
    {
      left = tape.left;
      head = c;
      right = tape.right;
      blank = tape.blank;
    }
  
  let move tape (action : Action.t) : t = 
  match action with 
  | Action.Right -> 
    (match tape.right with
    | [] ->
      {
        left = tape.head :: tape.left;
        head = tape.blank;
        right = [];
        blank = tape.blank;
      }
    | x::xs ->
      {
        left = tape.head :: tape.left;
        head = x;
        right = xs;
        blank = tape.blank;
      })
  | Action.Left ->
    (match tape.left with
    | [] ->
      {
        left = [];
        head = tape.blank;
        right = tape.head :: tape.right;
        blank = tape.blank;
      }
    | x::xs ->
      {
        left = xs;
        head = x;
        right = tape.head :: tape.right;
        blank = tape.blank;
      })
end

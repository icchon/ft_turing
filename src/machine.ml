open Action
open Yojson.Basic.Util

module Machine = struct
  type transition = {
    read: char;
    write: char;
    next_state: string; 
    action: Action.t;
  }

  type t = {
    name: string;
    alphabet: char list;
    blank: char;
    initial: string;
    finals: string list;
    states: string list;
    transitions: (string, transition list) Hashtbl.t; 
  }
  let string_of_transition_list (transitions: transition list) : string =
    if transitions = [] then "[]"
    else
      let s = List.map (fun t ->
        Printf.sprintf "      { read: '%c', write: '%c', next: %s, action: %s }"
          t.read t.write t.next_state (match t.action with Action.Left -> "Left" | Action.Right -> "Right")
      ) transitions
      |> String.concat "\n"
      in
      "\n" ^ s

  let string_of_transitions_table (table: (string, transition list) Hashtbl.t) : string =
    Hashtbl.fold (fun state_name transitions acc ->
      let transition_str = string_of_transition_list transitions in
      acc ^ Printf.sprintf "\n  [%s]: %s\n" state_name transition_str
    ) table ""

  let string_of_machine (m: t) : string =
    let alphabet_str = String.of_seq (List.to_seq m.alphabet) in
    let finals_str = String.concat ", " m.finals in
    let states_str = String.concat ", " m.states in
    Printf.sprintf
    "=== MACHINE DEFINITION ===\n\
     Name:           %s\n\
     Alphabet:       [%s]\n\
     Blank Char:     '%c'\n\
     Initial State:  %s\n\
     Final States:   [%s]\n\
     All States:     [%s]\n\
     --- TRANSITIONS ---\n%s\n\
     =========================="
    m.name
    alphabet_str
    m.blank
    m.initial
    finals_str
    states_str
    (string_of_transitions_table m.transitions)

  let action_of_string = function
    | "Right" -> Action.Right
    | "Left" -> Action.Left
    | s -> failwith ("Invalid action: " ^ s)

  let transition_of_json json =
    {
      read = member "read" json |> to_string |> (fun x -> String.get x 0);
      write = member "write" json |> to_string |> (fun x -> String.get x 0);
      next_state = member "next_state" json |> to_string;
      action = member "action" json |> to_string |> action_of_string
    }

  let read_machine path =
    let json = Yojson.Basic.from_file path in
    let transitions_json = member "transitions" json |> to_assoc in
    let transitions_tbl = Hashtbl.create (List.length transitions_json) in
    List.iter (fun (state_name, trans_list_json) ->
      let trans_list = trans_list_json |> to_list |> List.map transition_of_json in
      Hashtbl.add transitions_tbl state_name trans_list
    ) transitions_json;
    {
      name = member "name" json |> to_string;
      alphabet = member "alphabet" json |> to_string |> (fun s -> List.of_seq (String.to_seq s));
      blank = member "blank" json |> to_string |> (fun s -> String.get s 0);
      initial = member "initial" json |> to_string;
      finals = member "finals" json |> to_list |> List.map to_string;
      states = member "states" json |> to_list |> List.map to_string;
      transitions = transitions_tbl
    }
  
  let find_transition m current_state read_char =
    match Hashtbl.find_opt m.transitions current_state with
    | None -> None
    | Some rules -> List.find_opt (fun rule -> rule.read = read_char) rules  
end

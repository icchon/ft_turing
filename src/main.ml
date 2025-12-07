open Machine
open Simulator  
open Tape
open Yojson.Basic.Util


let () =
  if Array.length Sys.argv <> 3 then
    Printf.eprintf "Usage: %s <machine.json> <input_file>\n" Sys.argv.(0)
  else
    let machine_file = Sys.argv.(1) in
    let input_file = Sys.argv.(2) in
    try
      let machine = Machine.read_machine machine_file in
      let input_string =
        In_channel.with_open_text input_file (fun ic ->
          match In_channel.input_line ic with
          | Some s -> String.trim s
          | None -> ""
        )
      in
      print_endline (Machine.string_of_machine machine);
      print_endline ("Input: " ^ input_string);
      let initial_s = Simulator.initial_state machine (String.trim input_string) in
      let (final_s, reason) = Simulator.run_until_halt machine initial_s in
      let final_tape_str = Tape.string_of_tape final_s.tape in
      let reason_str = match reason with
        | Simulator.Halted -> "Halted"
        | Simulator.Blocked -> "Blocked"
      in
      Printf.printf "Execution finished in %d steps.\n" final_s.steps;
      Printf.printf "Final state: %s\n" final_s.current_state;
      Printf.printf "Final tape: %s\n" final_tape_str;
      Printf.printf "Reason: %s\n" reason_str
    with
    | Yojson.Json_error msg -> Printf.eprintf "Error parsing JSON file: %s\n" msg
    | Sys_error msg -> Printf.eprintf "Error reading file: %s\n" msg


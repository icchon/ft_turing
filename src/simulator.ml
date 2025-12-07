open Tape
open Machine

module Simulator = struct
  type state = {
    current_state: string;
    tape: Tape.t;
    steps: int;
  }

  type termination_reason = 
  | Halted 
  | Blocked
  
  let initial_state (m: Machine.t) input = 
    let initial_tape = Tape.create input m.blank in
    {
      current_state = m.initial;
      tape = initial_tape;
      steps = 0;
    }

  let step (m: Machine.t) (s: state) = 
    match Machine.find_transition m s.current_state s.tape.head
    with 
    | None -> None
    | Some rule -> 
      let new_tape = s.tape
        |> (fun t -> Tape.write t rule.write)
        |> (fun t -> Tape.move t rule.action)
      in
      let new_state = {
        current_state = rule.next_state;
        tape = new_tape;
        steps = s.steps + 1;
      } in
      Some new_state

  let rec run_until_halt (m: Machine.t) (s: state) = 
    print_endline (Tape.string_of_tape s.tape);
    if List.mem s.current_state m.finals then 
      (s, Halted)
  else
    match step m s with
    | None -> (s, Blocked)
    | Some next_s -> run_until_halt m next_s
end

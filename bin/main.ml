
let encrypt text =
  Printf.printf "Encrypting: %s\n" text;
  Itmo_insec.Bigram.encrypt text
let decrypt text =
  Printf.printf "Decrypting: %s\n" text;
  Itmo_insec.Bigram.decrypt text

let main () =
  let mode = ref "encrypt" in

  let speclist = [
    ("-m", Arg.String (fun m -> mode := m), "Mode: 'encrypt' or 'decrypt'")
  ] in

  Arg.parse speclist (fun _ -> ()) "Usage: main -m <mode>";

  let input_text = try
    let line = read_line () in
    if line = "" then failwith "No input provided" else line
  with End_of_file ->
    Printf.eprintf "Error: No input provided.\n";
    exit 1
  in
  
  let result =
    match !mode with
    | "encrypt" -> encrypt input_text
    | "decrypt" -> decrypt input_text
    | _ ->
      Printf.eprintf "Error: Invalid mode. Use 'encrypt' or 'decrypt'.\n";
      exit 1
  in
  
  Printf.printf "%s\n" result

let () = main ()

let write_file filename content =
  let oc = open_out filename in
  output_bytes oc content;
  close_out oc
;;

let read_file filename =
  let ic = open_in filename in
  let len = in_channel_length ic in
  let content = Bytes.create len in
  really_input ic content 0 len;
  close_in ic;
  content
;;

let iv = Bytes.of_string "DancingPickle420"

let main () =
  let mode = ref "encrypt" in
  let input_file = ref "input" in
  let output_file = ref "output" in
  let speclist =
    [ "-m", Arg.String (fun m -> mode := m), "Mode: 'encrypt' or 'decrypt'"
    ; "-i", Arg.Set_string input_file, "Specify input file name"
    ; "-o", Arg.Set_string output_file, "Specify output file name"
    ]
  in
  Arg.parse speclist (fun _ -> ()) "Usage: main -m <mode> -i <input> -o <output>";
  let result =
    match !mode with
    | "encrypt" -> Itmo_insec.Rc6.encrypt (read_file !input_file)
    | "decrypt" -> Itmo_insec.Rc6.decrypt (read_file !input_file)
    | _ ->
      Printf.eprintf "Error: Invalid mode. Use 'encrypt' or 'decrypt'.\n";
      exit 1
  in
  write_file !output_file (result iv)
;;

let () = main ()

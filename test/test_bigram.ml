open OUnit2

let encrypt = Itmo_insec.Bigram.encrypt
let decrypt = Itmo_insec.Bigram.decrypt

let square1 =
  Random.init 42;
  Itmo_insec.Bigram.random_square ()
;;

let square2 =
  Random.init 42;
  Itmo_insec.Bigram.random_square ()
;;

let test_encrypt_decrypt _ =
  let original_text = "ABOB" in
  let encrypted_text = encrypt original_text square1 square2 in
  Printf.printf "Encrypted: %s\n" encrypted_text;
  let decrypted_text = decrypt encrypted_text square1 square2 in
  Printf.printf "Decrypted: %s\n" decrypted_text;
  assert_equal original_text decrypted_text ~msg:"Decrypted text should match original"
;;

let test_encrypt_decrypt_odd _ =
  let original_text = "ABOBAAB" in
  let encrypted_text = encrypt original_text square1 square2 in
  Printf.printf "Encrypted: %s\n" encrypted_text;
  let decrypted_text = decrypt encrypted_text square1 square2 in
  Printf.printf "Decrypted: %s\n" decrypted_text;
  assert_equal "ABOBAABB" decrypted_text ~msg:"Decrypted text should match original"
;;

let test_encrypt_empty_string _ =
  let encrypted_text = encrypt "" square1 square2 in
  assert_equal
    ""
    encrypted_text
    ~msg:"Encrypting an empty string should return an empty string"
;;

let test_decrypt_empty_string _ =
  let decrypted_text = decrypt "" square1 square2 in
  assert_equal
    ""
    decrypted_text
    ~msg:"Decrypting an empty string should return an empty string"
;;

let suite =
  "Bigram Tests"
  >::: [ "test_encrypt_decrypt" >:: test_encrypt_decrypt
       ; "test_encrypt_decrypt_odd" >:: test_encrypt_decrypt_odd
       ; "test_encrypt_empty_string" >:: test_encrypt_empty_string
       ; "test_decrypt_empty_string" >:: test_decrypt_empty_string
       ]
;;

let () = run_test_tt_main suite

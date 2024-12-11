let block_size = 16
let key = "key"

let encrypt plaintext =
  (* Implement the actual encryption algorithm here *)
  plaintext
;;

let decrypt ciphertext =
  (* Implement the actual decryption algorithm here *)
  ciphertext
;;
(* let cfb_encrypt key iv plaintext =
   let ciphertext = Bytes.create (Bytes.length plaintext) in
   let mutable_block = Bytes.copy iv in

   for i = 0 to (Bytes.length plaintext / RC6.block_size) do
     let block_start = i * RC6.block_size in
     let block_end = min ((i + 1) * RC6.block_size) (Bytes.length plaintext) in
     let block_length = block_end - block_start in

     let encrypted_block = RC6.encrypt key mutable_block in

     for j = block_start to block_end - 1 do
       if j < Bytes.length plaintext then
         Bytes.set ciphertext j (char_of_int ((int_of_char (Bytes.get plaintext j)) lxor (int_of_char (Bytes.get encrypted_block (j mod RC6.block_size)))))
     done;

     (* Update mutable_block with ciphertext *)
     mutable_block := Bytes.sub ciphertext block_start block_length;
   done;

   ciphertext *)

(* let cfb_decrypt key iv ciphertext =
   let plaintext = Bytes.create (Bytes.length ciphertext) in
   let mutable_block = Bytes.copy iv in
   for i = 0 to (Bytes.length ciphertext / RC6.block_size) do
     let block_start = i * RC6.block_size in
     let block_end = min ((i + 1) * RC6.block_size) (Bytes.length ciphertext) in
     let block_length = block_end - block_start in

     (* Encrypt the mutable block *)
     let encrypted_block = RC6.encrypt key mutable_block in

     (* XOR with ciphertext to produce plaintext *)
     for j = block_start to block_end - 1 do
       if j < Bytes.length ciphertext then
         Bytes.set plaintext j (char_of_int ((int_of_char (Bytes.get ciphertext j)) lxor (int_of_char (Bytes.get encrypted_block (j mod RC6.block_size)))))
     done;

     (* Update mutable_block with ciphertext *)
     mutable_block := Bytes.sub ciphertext block_start block_length;
done;

plaintext *)

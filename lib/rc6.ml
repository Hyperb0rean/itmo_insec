let block_size = 16


let ( >> ) x y = x lsr y;; 
let ( << ) x y = x lsl y;; 

let ( && ) x y = x land y;; 

let ( || ) x y = x lor y;; 

let circular_left_shift x n =
  ((x << n) || (x >> (32 - n))) && 0xFFFFFFFF

let bytes_to_int input_blocks start =
  let get_int idx shift = (int_of_char ((Bytes.get input_blocks  (start + idx))) << shift)  in

  (get_int 0 24) ||
  (get_int 1 16) ||
  (get_int 2 8) ||
  (get_int 3 0)

let set_output_bytes output_bytes a b c d =
  let set_byte idx value = Bytes.set output_bytes idx (char_of_int(value && 255)) in

  set_byte 0 (!a >> 24);
  set_byte 1 (!a >> 16);
  set_byte 2 (!a >> 8);
  set_byte 3 (!a);

  set_byte 4 (!b >> 24);
  set_byte 5 (!b >> 16);
  set_byte 6 (!b >> 8);
  set_byte 7 (!b);

  set_byte 8 (!c >> 24);
  set_byte 9 (!c >> 16);
  set_byte 10 (!c >> 8);
  set_byte 11 (!c);

  set_byte 12 (!d >> 24);
  set_byte 13 (!d >> 16);
  set_byte 14 (!d >> 8);
  set_byte 15 (!d)

let rc6_encrypt plainbytes =
   let input_blocks = Bytes.create block_size in
   Printf.printf "%d\n" block_size ;
   Printf.printf "%d\n" (Bytes.length plainbytes) ;

   Bytes.blit plainbytes 0 input_blocks 0 block_size;

   (* Initialize A, B, C, D using the helper function *)
   let a = ref (bytes_to_int input_blocks 0) in
   let b = ref (bytes_to_int input_blocks 4) in
   let c = ref (bytes_to_int input_blocks 8) in
   let d = ref (bytes_to_int input_blocks 12) in

   let r =20 in

   for _ = 0 to r -1 do 
       d := circular_left_shift(!d + !a)(!a land ((1 << 5)-1));
       c := circular_left_shift(!c + !d)(!d land((1 << 5)-1));
       b := circular_left_shift(!b + !c)(!c land((1 << 5)-1));
       a := circular_left_shift(!a + !b)(!b land((1 << 5)-1));
   done;

   (* Create output bytes from A, B, C, D using the helper function *)
   let output_bytes = Bytes.create block_size in
   set_output_bytes output_bytes a b c d;
   output_bytes;;

let rc6_decrypt cipherbytes =
    let input_blocks = Bytes.create block_size in
    Bytes.blit cipherbytes 0 input_blocks 0 block_size; 

    let a = ref (bytes_to_int input_blocks 0) in
    let b = ref (bytes_to_int input_blocks 4) in
    let c = ref (bytes_to_int input_blocks 8) in
    let d = ref (bytes_to_int input_blocks 12) in
    let rounds =20 in
    for _ = rounds-1 downto 0 do 
        a := circular_left_shift(!a - !b)(!b && ((1<<5)-1));
        b := circular_left_shift(!b - !c)(!c &&((1<<5)-1));
        c := circular_left_shift(!c - !d)(!d &&((1<<5)-1));
        d := circular_left_shift(!d - !a)(!a && ((1<<5)-1));
    done;

    let output_bytes=Bytes.create block_size in
    set_output_bytes output_bytes a b c d;
    output_bytes;;

let encrypt plainbytes iv =
     let num_blocks=(Bytes.length plainbytes + block_size - 1) / block_size in 
     Printf.printf "%d\n" num_blocks;
     let ciphertext= Bytes.create(num_blocks * block_size) in 

     for i=0 to num_blocks -1 do 
         let block_start=i * block_size in 
         let block_end=min(block_start + block_size)(Bytes.length plainbytes) in 
         let block_length=block_end - block_start in 

         let encrypted_iv=rc6_encrypt iv in 

         for j=0 to block_length -1 do 
             if block_start + j < Bytes.length plainbytes then 
                 Bytes.set ciphertext (block_start + j) (char_of_int ((int_of_char(Bytes.get plainbytes (block_start + j)) lxor int_of_char(Bytes.get encrypted_iv j))));
         done;

         for j=0 to block_length -1 do 
             if block_start + j < Bytes.length ciphertext then 
                Bytes.set iv (block_start + j)  (Bytes.get ciphertext (block_start + j))
         done;
     done;

     ciphertext 
;;

let decrypt cipherbytes iv =
     let num_blocks=(Bytes.length cipherbytes + block_size -1)/block_size in 
     let plaintext=Bytes.create(num_blocks * block_size) in 

     for i=0 to num_blocks -1 do 
         let block_start=i * block_size in 
         let block_end=min(block_start + block_size)(Bytes.length cipherbytes) in 
         let block_length=block_end - block_start in 

         let encrypted_iv=rc6_encrypt iv in 

         for j=0 to block_length -1 do 
             if block_start + j < Bytes.length cipherbytes then 
                 Bytes.set plaintext (block_start + j)
                     (char_of_int ((int_of_char(Bytes.get cipherbytes (block_start + j)) lxor int_of_char(Bytes.get encrypted_iv j))));
         done;

         for j=0 to block_length -1 do 
             if block_start + j < Bytes.length cipherbytes then 
                 Bytes.set iv (block_start + j) (Bytes.get cipherbytes (block_start + j))
         done;
     done;

     plaintext
;;

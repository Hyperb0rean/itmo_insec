open Batteries

(*NO 'Q'*)
let alphabet = "ABCDEFGHIJKLMNOPRSTUVWXYZ"

let shuffle arr =
  let len = Array.length arr in
  for i = len - 1 downto 1 do
    let j = Random.int (i + 1) in
    let temp = arr.(i) in
    arr.(i) <- arr.(j);
    arr.(j) <- temp
  done;
  arr
;;

let random_square () =
  let chars = List.init (String.length alphabet) (fun i -> alphabet.[i]) in
  shuffle (Array.of_list chars)
;;

let bigrams text =
  let text = String.uppercase_ascii text in
  let text = String.filter (fun c -> String.contains alphabet c) text in
  let len = String.length text in
  let rec aux i acc =
    if i >= len
    then List.rev acc
    else if i = len - 1
    then (
      let sym = String.sub text i 1 in
      aux (i + 1) ((sym ^ sym) :: acc))
    else aux (i + 2) (String.sub text i 2 :: acc)
  in
  aux 0 []
;;

let encrypt_bigram (b1, b2) (square1, square2) =
  let pos1 = Array.findi (fun c -> c = b1) square1 in
  let pos2 = Array.findi (fun c -> c = b2) square2 in
  let row1, col1 = pos1 / 5, pos1 mod 5 in
  let row2, col2 = pos2 / 5, pos2 mod 5 in
  square1.((row1 * 5) + col2), square2.((row2 * 5) + col1)
;;

let decrypt_bigram (b1, b2) (square1, square2) =
  let pos1 = Array.findi (fun c -> c = b1) square2 in
  let pos2 = Array.findi (fun c -> c = b2) square1 in
  let row1, col1 = pos1 / 5, pos1 mod 5 in
  let row2, col2 = pos2 / 5, pos2 mod 5 in
  square1.((row1 * 5) + col2), square2.((row2 * 5) + col1)
;;

let encrypt text square1 square2 =
  let bigrams_list = bigrams text in
  let encrypted_bigrams =
    List.map (fun bg -> encrypt_bigram (bg.[0], bg.[1]) (square1, square2)) bigrams_list
  in
  String.concat
    ""
    (List.map (fun (a, b) -> String.make 1 a ^ String.make 1 b) encrypted_bigrams)
;;

let decrypt text square1 square2 =
  let bigrams_list = bigrams text in
  let decrypted_bigrams =
    List.map (fun bg -> decrypt_bigram (bg.[0], bg.[1]) (square1, square2)) bigrams_list
  in
  String.concat
    ""
    (List.map (fun (a, b) -> String.make 1 a ^ String.make 1 b) decrypted_bigrams)
;;

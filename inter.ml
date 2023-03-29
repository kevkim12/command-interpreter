let write_file_example (file_path: string) : unit =
  let fp = open_out file_path in
  Printf.fprintf fp "writing this line!";
  close_out fp

type 'a commands =
  | Quit
  | Push of 'a
  | Pop
  | Add
  | Sub
  | Mul
  | Div
  | Swap
  | Neg
  | Concat

let reverse (l) =
  List.fold_left(fun acc x -> x :: acc) [] l;;

let fix_push_str (s : string) =
  String.fold_left(fun acc x ->
    if x = 'n' then
      acc
    else
      acc ^ Char.escaped(x)
    ) "" s

let push_val (x) =
  let fl = String.fold_left(fun (acc, count) x ->
    match (acc, count) with
    | (a, b) ->
      if b > 3 then
        (a ^ Char.escaped(x), b + 1)
      else
        (a, b + 1)
    ) ("", 0) x in
    match fl with
    | (a, b) -> String.trim(a)

let check_push_type (i) =
  String.fold_left(fun acc x ->
    if x = '\"' then
      acc + 1
    else
      acc
    ) 0 i

let convert_int (i) =
  match i with
  | Push v ->
  int_of_string v
  | _ -> 0
      
let add_vals (stck) =
  match stck with
  | hd::tl ->(
    match tl with
    | hd2::tl2 ->(
      if (check_push_type(hd) = 0) && (check_push_type(hd2) = 0) then
        string_of_int(int_of_string(hd) + int_of_string(hd2)) :: tl2
      else
        stck
        )
    |_ -> stck
        )
  |_ -> stck

let sub_vals (stck) =
  match stck with
  | hd::tl ->(
    match tl with
    | hd2::tl2 ->(
      if (check_push_type(hd) = 0) && (check_push_type(hd2) = 0) then
        string_of_int(int_of_string(hd) - int_of_string(hd2)) :: tl2
      else
        stck
        )
    |_ -> stck
        )
  |_ -> stck

let mul_vals (stck) =
  match stck with
  | hd::tl ->(
    match tl with
    | hd2::tl2 ->(
      if (check_push_type(hd) = 0) && (check_push_type(hd2) = 0) then
        string_of_int(int_of_string(hd) * int_of_string(hd2)) :: tl2
      else
        stck
        )
    |_ -> stck
        )
  |_ -> stck

let can_div (stck) =
  match stck with
  | hd::tl ->(
    match tl with
    | hd2::tl2 ->(
      if (check_push_type(hd) = 0) && (check_push_type(hd2) = 0) then
        if int_of_string(hd2) > 0 then
          1
        else
          0
      else
        0
        )
    |_ -> 0
        )
  |_ -> 0

let div_vals (stck) =
  match stck with
  | hd::tl ->(
    match tl with
    | hd2::tl2 ->(
      if (check_push_type(hd) = 0) && (check_push_type(hd2) = 0) then
        string_of_int(int_of_string(hd) / int_of_string(hd2)) :: tl2
      else
        stck
        )
    |_ -> stck
        )
  |_ -> stck

let neg_val (stck) =
  match stck with
  | hd::tl ->
    if (check_push_type(hd) = 0) then
      string_of_int((-1) * int_of_string hd) :: tl
    else
      stck
  | _ -> stck

let concat_vals (stck) =
  match stck with
  | hd::tl ->(
    match tl with
    | hd2::tl2 ->(
      if (check_push_type(hd) > 0) && (check_push_type(hd2) > 0) then
        let cv = (hd ^ hd2) in
        let fl = String.fold_left(fun acc x ->
          if x <> '\"' then
            acc ^ Char.escaped(x)
          else
            acc
          ) "" cv in
          (Char.escaped('\"') ^ fl ^ Char.escaped('\"')) :: tl2
      else
        stck
        )
    |_ -> stck
        )
  |_ -> stck

let swap_vals (stck) =
  match stck with
  | hd::tl ->(
    match tl with
    | hd2::tl2 ->(
      hd2 :: hd :: tl2
        )
    |_ -> stck
        )
  |_ -> stck

let validate_1 (stck) =
  match stck with
  | hd::tl ->
    check_push_type hd
  | [] -> (-10)

let validate_2 (stck) =
  match stck with
  | hd::tl ->(
    match tl with
    | hd2::tl2 ->(
      check_push_type hd2
    )
    | [] -> (-10)
    )
  | [] -> (-10)

let check_push_str (v) =
  String.fold_left(fun acc x ->
    if ((int_of_char('a') <= int_of_char(x)) && (int_of_char(x) <= int_of_char('z'))) || ((int_of_char('A') <= int_of_char(x)) && (int_of_char(x) <= int_of_char('Z'))) || x = '\"' then
      acc
    else
      acc + 1
    ) 0 v

let test = "Push 100\nPush 200\nDiv\nSwap\nNeg\nQuit\nPush \"MissingArg\"\nQuit" (*for debugging purposes*)

(*When it comes to parsing src, you should find it useful that fold_left is 
  defined on strings as String.fold_left *)
let interpreter (src : string) (output_file_path: string) : unit =
let src_filter1 = String.split_on_char '\n' src in
  let src_filter2 = List.fold_left(fun acc x ->
    match x with
    | "Quit" -> Quit :: acc
    | "Add" -> Add :: acc
    | "Pop" -> Pop :: acc
    | "Sub" -> Sub :: acc
    | "Mul" -> Mul :: acc
    | "Div" -> Div :: acc
    | "Swap" -> Swap :: acc
    | "Neg" -> Neg :: acc
    | "Concat" -> Concat :: acc
    | _ ->
      if (String.contains x 'P') && (String.contains x 'u') && (String.contains x 's') && (String.contains x 'h') then
        Push(push_val x) :: acc
      else
        acc
    ) [] src_filter1 in
    let res = reverse(src_filter2) in
    let stack_fold = List.fold_left(fun (acc, stck, quit, error) x ->
      match (acc, stck, quit, error) with
      | (a, b, c, d) ->(
        match x with
        | Quit -> (a, b, c + 1, d)
        | Push v -> (*check if they are all letters if string (no numbers and spaces)*)
          if c = 0 then
            if (check_push_type v) > 0 then (*string*)
              if (check_push_str v) = 0 then
                (a, v :: b, c, d)
              else
                (a, b, c, d + 1)
            else (*int*)
            (a, v :: b, c, d)
          else
            (a, b, c, d)
        | Pop ->(
          if c = 0 then
            match b with
            | hd :: tl ->(
              (a, tl, c, d)
            )
            | [] -> (a, b, c, d + 1)
          else
            (a, b, c, d)
        )
        | Add ->
          if c = 0 then
            if (((validate_1 b) + (validate_2 b)) = 0) then
              (a, add_vals b, c, d)
            else
              (a, b, c, d + 1)
          else
            (a, b, c, d)
        | Sub ->
          if c = 0 then
            if (((validate_1 b) + (validate_2 b)) = 0) then
              (a, sub_vals b, c, d)
            else
              (a, b, c, d + 1)
          else
            (a, b, c, d)
        | Mul ->
          if c = 0 then
            if (((validate_1 b) + (validate_2 b)) = 0) then
              (a, mul_vals b, c, d)
            else
              (a, b, c, d + 1)
          else
            (a, b, c, d)
        | Div ->
          if c = 0 then
            if (((validate_1 b) + (validate_2 b)) = 0) then
              if (can_div b > 0) then
                (a, div_vals b, c, d)
              else
                (a, b, c, d + 1)
            else
              (a, b, c, d + 1)
          else
            (a, b, c, d)
        | Neg ->
          if c = 0 then
            if (validate_1 b) = 0 then
              (a, neg_val b, c, d)
            else
              (a, b, c, d + 1)
          else
            (a, b, c, d)
        | Concat ->
          if c = 0 then
            if ((validate_1 b) > 0) && ((validate_2 b) > 0) then
              (a, concat_vals b, c, d)
            else
              (a, b, c, d + 1)
          else
            (a, b, c, d)
        | Swap ->
          if c = 0 then
            if ((validate_1 b) >= 0) && ((validate_2 b) >= 0) then
              (a, swap_vals b, c, d)
            else
              (a, b, c, d + 1)
          else
            (a, b, c, d)
      )
      ) ([], [], 0, 0) res in
      match stack_fold with
      | (a, b, c, d) ->
        if d > 0 then
          let fp = open_out output_file_path in
          Printf.fprintf fp "\"Error\"";
          close_out fp
        else
          let fp = open_out output_file_path in
          List.fold_left(fun acc x ->
            Printf.fprintf fp "%s\n" x;
            ) () b;
            close_out fp
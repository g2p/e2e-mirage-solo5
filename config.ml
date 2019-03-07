open Mirage

let port =
  let doc = Key.Arg.info ~doc:"The TCP listen port." ["port"] in
  Key.(create "port" Arg.(opt int 23 doc))

let init = 
  let doc = Key.Arg.info ~doc:"Initialise block device and exit." ["init"] in
  Key.(create "init" Arg.(flag doc))

let main =
  let packages = [ package "logs"; package "yojson" ] in
  foreign
    ~keys:[Key.abstract port; Key.abstract init] ~packages
    "Unikernel.Main" (stackv4 @-> block @-> job)

let stack = generic_stackv4 default_network

let img = block_of_file "disk.img"

let () = register "counter" [main $ stack $ img]
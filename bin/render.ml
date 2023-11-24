open Jingoo

let base_dir = "/users/peterpuha/code/ml/ml-htmx/ml_htmx"

let render view models =
  let tmpl = 
    Jg_template.from_file
      (base_dir ^ "/templates/" ^ view ^ ".html")
      ~models
  in
  tmpl |> Dream.html

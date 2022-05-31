let fromOption = (option: option<'a>, default: 'a) =>
  switch option {
  | Some(a) => Ok(a)
  | None    => Error(default)
  }

let toOption = (result: result<'a, 'a>) =>
  switch result {
  | Ok(a)     => Some(a)
  | Error(a)  => Some(a)
  }

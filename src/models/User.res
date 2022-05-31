open ResultUtils

let isNotEmpty = (input: string) =>
  switch input {
  | ""  => None
  | i   => Some(i)
  }

let isLongerThan5Characters = (input: string) =>
  input->Js.String.length >= 5 ? Ok(input) : Error(input)

let validateUserName = userName =>
  userName
  ->Some
  ->Belt.Option.flatMap(isNotEmpty)
  ->fromOption("")
  ->Belt.Result.flatMap(isLongerThan5Characters)

let validateName = name => name
  ->Some
  ->Belt.Option.flatMap(isNotEmpty)

type user =
  | InvalidUser({
      firstName: option<string>,
      lastName: option<string>,
      userName: result<string, string>,
    })
  | ValidUser({firstName: string, lastName: string, userName: string})

let createUser = (firstName: string, lastName: string, userName: string) => {
  switch (firstName |> validateName, lastName |> validateName, userName |> validateUserName) {
  | (Some(firstName), Some(lastName), Ok(userName)) => ValidUser({firstName, lastName, userName})
  | (firstName, lastName, userName) => InvalidUser({firstName, lastName, userName})
  }
}
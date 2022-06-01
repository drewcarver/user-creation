type inputError = { value:string, error: string }
type validatableInput = result<string, inputError>

let isNotEmpty = (input: string) =>
  switch input {
  | ""  => Error({ value: "", error: "Input cannot be empty." })
  | i   => Ok(i)
  }

let isLongerThan5Characters = (input: string) =>
  input->Js.String.length >= 5 ? Ok(input) : Error({ value: input, error: "Input must be longer than 5 characters."})

let validateUserName = userName =>
  userName
  ->Ok
  ->Belt.Result.flatMap(isNotEmpty)
  ->Belt.Result.flatMap(isLongerThan5Characters)

let validateName = name => name
  ->Ok
  ->Belt.Result.flatMap(isNotEmpty)

type user =
  | InvalidUser({
      firstName: validatableInput,
      lastName: validatableInput,
      userName: validatableInput,
    })
  | ValidUser({firstName: string, lastName: string, userName: string})

let createUser = (firstName: string, lastName: string, userName: string) => {
  switch (firstName |> validateName, lastName |> validateName, userName |> validateUserName) {
  | (Ok(firstName), Ok(lastName), Ok(userName)) => ValidUser({firstName, lastName, userName})
  | (firstName, lastName, userName) => InvalidUser({firstName, lastName, userName})
  }
}
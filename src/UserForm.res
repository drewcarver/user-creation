
type userAction = 
  | SetFirstName(string) 
  | SetLastName(string) 
  | SetUserName(string) 

type incompleteUser = {
  firstName: option<string>,
  lastName:  option<string>,
  userName:  option<string>
}

type validUser = {
  firstName: string,
  lastName:  string,
  userName:  string
}

type user = 
	| InvalidUser({ 
		firstName: option<string>,
 		lastName:  option<string>,
  		userName:  result<string, string>
	  })
	| ValidUser({ 
		firstName: string,
  		lastName:  string,
  		userName:  string 
	  })

let isNotEmpty = (input: string) => switch input {
	| "" 		=> None
	| i 		=> Some(i)
}

let fromOption = (option: option<'a>, default: 'a) => switch option {
	| Some(a)  	=> Ok(a)
	| None		=> Error(default)
}

let toOption = (result: result<'a, 'a>) => switch result {
	| Ok(a) 	=> Some(a)
	| Error(a)  => Some(a)
}

let isLongerThan5Characters = (input: string) => input -> Js.String.length >= 5
	? Ok(input)
	: Error(input) 

let validateUserName = (userName) => userName 
	-> Some 
	-> Belt.Option.flatMap(isNotEmpty)
	-> fromOption("")
	-> Belt.Result.flatMap(isLongerThan5Characters)

let validateName = (name) => name
	-> Some
	-> Belt.Option.flatMap(isNotEmpty)

let createUser = (firstName: string, lastName: string, userName: string) => {
	switch (
		firstName |> validateName, 
		lastName |> validateName, 
		userName |> validateUserName) {
		| (Some(fn), Some(ln), Ok(un)) => ValidUser({firstName: fn, lastName: ln, userName: un})
		| (fn, ln, un) => InvalidUser({firstName: fn, lastName: ln, userName: un})
	}
}

let getValue = (result: result<'a, 'b>) => switch result {
	| Ok(a)    => a
	| Error(a) => a
}

let reducer = (state: user, action: userAction) => { 
  switch (action) { 
    | SetFirstName(name) => switch state {
		| ValidUser(u)   => createUser(name, u.lastName, u.userName)
		| InvalidUser(u) => createUser(name, u.lastName |> Js.Option.getWithDefault(""), u.userName |> getValue )
	 }
    | SetLastName(name) => switch state {
		| ValidUser(u)   => createUser(u.firstName, name, u.userName)
		| InvalidUser(u) => createUser(u.firstName |> Js.Option.getWithDefault(""), name, u.userName |> getValue)
	 }
    | SetUserName(name) => switch state {
		| ValidUser(u)   => createUser(u.firstName, u.lastName, name)
		| InvalidUser(u) => createUser(u.firstName |> Js.Option.getWithDefault(""), u.lastName |> Js.Option.getWithDefault(""), name)
	 }
  }
}

let defaultUser: user = InvalidUser({
  firstName: None,
  lastName:  None,
  userName:  Error(""),
})

@react.component
let make = () => {
  open ReactEvent
  let (user, dispatch) = React.useReducer(reducer, defaultUser)
  let disabled = switch user {
	  | ValidUser(_)   => false
	  | InvalidUser(_) => true
  }

  <form> 
    <label htmlFor="firstName">{ "First Name:" -> React.string }</label>
	<input 
		id="firstName" 
		onChange={e => dispatch(SetFirstName(Form.target(e)["value"]))}
		value={ 
			switch (user) { 
			 | ValidUser(u)   => u.firstName 
			 | InvalidUser(u) => u.firstName |> Js.Option.getWithDefault("")
			} 
		} 
    />
    <label htmlFor="lastName">{ "Last Name:" -> React.string }</label>
	<input 
		id="lastName" 
		onChange={e => dispatch(SetLastName(Form.target(e)["value"]))}
		value={ 
			switch (user) { 
			 | ValidUser(u)   => u.lastName
			 | InvalidUser(u) => u.lastName |> Js.Option.getWithDefault("")
			} 
		} 
    />
    <label htmlFor="userName">{ "User Name:" -> React.string }</label>
	<input 
		id="userName" 
		onChange={e => dispatch(SetUserName(Form.target(e)["value"]))}
		value={ 
			switch (user) { 
				| ValidUser(u)   => u.userName
				| InvalidUser(u) => u.userName |> getValue
			} 
		} 
    />
	<button disabled >{ "Create" -> React.string }</button>
  </form>
}

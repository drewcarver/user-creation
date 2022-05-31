open User
%%raw("import  './UserForm.css';")

type userAction =
  | SetFirstName(string)
  | SetLastName(string)
  | SetUserName(string)

@module("./api/userApi.js") external saveUser: user => Js.Promise.t<user> = "default"

let getValue = (result: result<'a, 'b>) =>
  switch result {
  | Ok(a) => a
  | Error(a) => a
  }

let reducer = (state: user, action: userAction) => {
  switch action {
  | SetFirstName(name) =>
    switch state {
    | ValidUser(u) => createUser(name, u.lastName, u.userName)
    | InvalidUser(u) =>
      createUser(name, u.lastName |> Js.Option.getWithDefault(""), u.userName |> getValue)
    }
  | SetLastName(name) =>
    switch state {
    | ValidUser(u) => createUser(u.firstName, name, u.userName)
    | InvalidUser(u) =>
      createUser(u.firstName |> Js.Option.getWithDefault(""), name, u.userName |> getValue)
    }
  | SetUserName(name) =>
    switch state {
    | ValidUser(u) => createUser(u.firstName, u.lastName, name)
    | InvalidUser(u) =>
      createUser(
        u.firstName |> Js.Option.getWithDefault(""),
        u.lastName |> Js.Option.getWithDefault(""),
        name,
      )
    }
  }
}

let defaultUser: user = InvalidUser({
  firstName: None,
  lastName: None,
  userName: Error(""),
})

@react.component
let make = () => {
  open ReactEvent
  let (user, dispatch) = React.useReducer(reducer, defaultUser)
  let disabled = switch user {
  | ValidUser(_) => false
  | InvalidUser(_) => true
  }
  let onClick = (event: ReactEvent.Mouse.t) => {
    saveUser(user) |> ignore

    ReactEvent.Mouse.stopPropagation(event)
  }

  <div className="user-page">
    <form
      className="user-form"
      onSubmit={e => {
        ReactEvent.Form.stopPropagation(e)
        ReactEvent.Form.preventDefault(e)
      }}>
      <h1 className="user-form__title"> {"Create New Account"->React.string} </h1>
      <label htmlFor="firstName"> {"First Name:"->React.string} </label>
      <input
        id="firstName"
		className="user-form__input"
        onChange={e => dispatch(SetFirstName(Form.target(e)["value"]))}
        value={switch user {
        | ValidUser(u) => u.firstName
        | InvalidUser(u) => u.firstName |> Js.Option.getWithDefault("")
        }}
      />
      <label htmlFor="lastName"> {"Last Name:"->React.string} </label>
      <input
        id="lastName"
		className="user-form__input"
        onChange={e => dispatch(SetLastName(Form.target(e)["value"]))}
        value={switch user {
        | ValidUser(u) => u.lastName
        | InvalidUser(u) => u.lastName |> Js.Option.getWithDefault("")
        }}
      />
      <label htmlFor="userName"> {"User Name:"->React.string} </label>
      <input
        id="userName"
		className="user-form__input"
        onChange={e => dispatch(SetUserName(Form.target(e)["value"]))}
        value={switch user {
        | ValidUser(u) => u.userName
        | InvalidUser(u) => u.userName |> getValue
        }}
      />
      <button 
	  	disabled 
		onClick
		className="user-form__create-button"
	  > 
	  {"Create"->React.string} 
	  </button>
    </form>
  </div>
}

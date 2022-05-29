
type userAction = 
  | SetFirstName(string) 

type userState = {
  firstName: option<string>,
  lastName:  option<string>,
	userName:  option<string>
}

let reducer = (state: userState, action: userAction) => { 
  switch (action) { 
    | SetFirstName(name) => {...state, firstName: Some(name) }
		| _ => state
	}
}

let defaultUser: userState = {
  firstName: None,
  lastName:  None,
  userName:  None,
}

@react.component
let make = () => {
  open ReactEvent
  let (user, dispatch) = React.useReducer(reducer, defaultUser)

  <form> 
    <label htmlFor="firstName">{ "First Name:" -> React.string }</label>
	  <input 
		  id="firstName" 
			onChange={e => dispatch(SetFirstName(Form.target(e).value))}
			value={ 
				switch (user.firstName) { 
				  | Some(firstName) => firstName 
					| None => ""
	      } 
      } 
    />
    <label htmlFor="lastName">{ "Last Name:" -> React.string }</label>
	  <input 
		  id="lastName" 
			value={ 
				switch (user.lastName) { 
				  | Some(lastName) => lastName 
					| None => ""
	      }
      } 
    />
    <label htmlFor="userName">{ "User Name:" -> React.string }</label>
	  <input 
      id="userName" 
			value={ 
				switch (user.userName) { 
				  | Some(userName) => userName 
					| None => ""
	      }
      } 
    />
  </form>
}

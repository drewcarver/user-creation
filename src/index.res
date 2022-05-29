
let startApp = {
  switch(ReactDOM.querySelector("#root")) {
    | Some (root) => ReactDOM.render(<App />, root)
		| None => Js.Console.log("Failed to start app")
	}
}

startApp

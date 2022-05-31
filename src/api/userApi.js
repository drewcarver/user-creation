
export default (user) => {
    console.log("user saved")
    Promise.resolve({ ...user, id: 1 })
}

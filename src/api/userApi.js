
export default (user) => {
    console.log("user saved")
    
    return new Promise(resolve => {
        setTimeout(() => resolve({ ...user, id: 1 }), 1 * 1000)
    })
}

const {run} = require("hardhat")

const verify = async (conttactAddress, args) => {
    console.log("Verfying contract...")
    try{
        await run("verify:verify", {
            address: conttactAddress,
            constructorArguments: args,
        })
    } catch(e){{
        if (e.message.toLowerCase().includes("already verified")){
            console.log("Already Verified")
        }else{
            console.log(e)
        }
    }}
}

module.exports = { verify }
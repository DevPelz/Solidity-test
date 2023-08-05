// import
// main function
// calling oof main function

// function deployFunc(){
//     console.log("Hi");
// }

// module.exports.default = deployFunc;
const {networkConfig} = require("../helper-hardhat-config")

module.exports = async ({getNamedAccounts, deployments})=> {
    const {deploy, log} = deployments;
    const {deployer} = await getNamedAccounts();
    const chainId = network.config.chainId;

    const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"];

    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: [address],
        log: true,
    });

}
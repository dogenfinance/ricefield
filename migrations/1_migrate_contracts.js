const Rice = artifacts.require("RiceToken");
const RiceFeild = artifacts.require("RiceField");
const RiceMarket = artifacts.require("RiceMarket");

const ricePerBlock = web3.utils.toWei("338","ether");           //REPLACE 10 WITH AMM of WHOLE RICE per block
const startBlock = 0;
const bonusEndBlock = 0;

const dev = "0x27d2c7F2729029440bE539EaA61657d35b5A4AEA";

module.exports = async function (deployer) {
    await deployer.deploy(Rice);

    const riceToken = await Rice.deployed();
    await deployer.deploy(
        RiceFeild,
        riceToken.address,
        dev,
        ricePerBlock,
        startBlock,
        bonusEndBlock,
        );

    await deployer.deploy(RiceMarket,"URI not yet set",riceToken.address);
};
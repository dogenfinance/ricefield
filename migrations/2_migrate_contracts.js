const Rice = artifacts.require("RiceToken");
const RiceFeild = artifacts.require("RiceField");

const ricePerBlock = web3.utils.toWei("10","ether");           //REPLACE 10 WITH AMM of WHOLE RICE per block
const startBlock = 0;
const bonusEndBlock = 15555;

module.exports = async function (deployer, network, [dev]) {
    await deployer.deploy(Rice);

    const riceToken = await Rice.deployed();
    await deployer.deploy(
        RiceFeild,
        riceToken.address,
        dev,
        ricePerBlock,
        startBlock,
        bonusEndBlock,
        {from: dev}
        );
};
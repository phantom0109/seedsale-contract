// const TestKata = artifacts.require("TestKata");
const Seedsale = artifacts.require("Seedsale");

module.exports = async function (deployer) {
  // await deployer.deploy(TestKata, "KATANA INU", "$KATA");
  // const kataInstance = await TestKata.deployed();
  
  // console.log("$KATA token deployed at:", kataInstance.address);

  await deployer.deploy(Seedsale,1638269523);

  const saleInstance = await Seedsale.deployed();

  console.log("Seedsale deployed at:", saleInstance.address);
};


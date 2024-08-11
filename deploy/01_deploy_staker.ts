import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

/**
 * Deploys a contract named "YourContract" using the deployer account and
 * constructor arguments set to the deployer address
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployStaker: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy, get } = hre.deployments;
  const exampleExternalContract = await get("ExampleExternalContract");

  await deploy("Staker", {
    from: deployer,
    args: [exampleExternalContract.address],
    log: true,
    autoMine: true,
  });
};

export default deployStaker;

deployStaker.tags = ["Staker"];

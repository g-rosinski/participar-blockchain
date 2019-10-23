var Participar = artifacts.require('./ParticiparContract.sol')

module.exports = function(deployer){
    deployer.deploy(Participar);
}
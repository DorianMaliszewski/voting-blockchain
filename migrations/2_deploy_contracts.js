var Election = artifacts.require("./Election.sol");

module.exports = function(deployer) {
  deployer.deploy(
    Election,
    [
      web3.utils.fromUtf8("Dorian Maliszewski").padEnd(66, "0"),
      web3.utils.fromUtf8("Emilien Gauthier").padEnd(66, "0"),
      web3.utils.fromUtf8("Antoine Franc").padEnd(66, "0"),
      web3.utils.fromUtf8("Aymeric Nosjean").padEnd(66, "0"),
      web3.utils.fromUtf8("Frédéric Malphat").padEnd(66, "0")
    ],
    9999999999999
  );
};

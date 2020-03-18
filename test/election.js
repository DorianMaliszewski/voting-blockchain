var Election = artifacts.require("./Election.sol");

contract("Election", function(accounts) {
  var appInstance;
  var candidateId;

  it("Initializes with 4 candidates", function() {
    return Election.deployed()
      .then(function(instance) {
        return instance.candidatesCount();
      })
      .then(function(count) {
        assert.equal(count, 4);
      });
  });

  it("Check the candidates", function() {
    return Election.deployed()
      .then(function(instance) {
        appInstance = instance;
        return appInstance.candidates(1);
      })
      .then(function(candidate1) {
        assert.equal(candidate1[0], 1, "Check the id");
        assert.equal(candidate1[1], "Candidate 1", "Check the name");
        assert.equal(candidate1[2], 0, "Check the votes count");
        return appInstance.candidates(2);
      })
      .then(function(candidate2) {
        assert.equal(candidate2[0], 2, "Check the id");
        assert.equal(candidate2[1], "Candidate 2", "Check the name");
        assert.equal(candidate2[2], 0, "Check the votes count");
        return appInstance.candidates(3);
      })
      .then(function(candidate3) {
        assert.equal(candidate3[0], 3, "Check the id");
        assert.equal(candidate3[1], "Candidate 3", "Check the name");
        assert.equal(candidate3[2], 0, "Check the votes count");
        return appInstance.candidates(4);
      })
      .then(function(candidate4) {
        assert.equal(candidate4[0], 4, "Check the id");
        assert.equal(candidate4[1], "Candidate 4", "Check the name");
        assert.equal(candidate4[2], 0, "Check the votes count");
      });
  });

  it("Allows a voter to cast a vote", function() {
    return Election.deployed()
      .then(function(instance) {
        appInstance = instance;
        candidateId = 1;
        return appInstance.vote(candidateId, { from: accounts[0] });
      })
      .then(function(receipt) {
        assert.equal(receipt.logs.length, 1, "An event was triggered");
        assert.equal(
          receipt.logs[0].event,
          "votedEvent",
          "The event type is correct"
        );
        assert.equal(
          receipt.logs[0].args._candidateId.toNumber(),
          candidateId,
          "The candidate id is correct"
        );
        return appInstance.voters(accounts[0]);
      })
      .then(function(voter) {
        assert(voter, "The voter was marked as voted");
        return appInstance.candidates(candidateId);
      })
      .then(function(candidate) {
        var voteCount = candidate[2];
        assert.equal(voteCount, 1, "The vote count is correct");
      });
  });

  it("Check that the candidate exists", function() {
    return Election.deployed()
      .then(function(instance) {
        appInstance = instance;
        return appInstance.vote(99, { from: accounts[1] });
      })
      .then(assert.fail)
      .catch(function(error) {
        assert(
          error.message.indexOf("revert") >= 0,
          "Error message must contain revert string"
        );
        return appInstance.candidates(1);
      })
      .then(function(candidate1) {
        assert.equal(1, candidate1[2], "Candidate 1 did not receive votes");
        return appInstance.candidates(2);
      })
      .then(function(candidate2) {
        assert.equal(0, candidate2[2], "Candidate 2 did not receive votes");
        return appInstance.candidates(3);
      })
      .then(function(candidate3) {
        assert.equal(0, candidate3[2], "Candidate 3 did not receive votes");
        return appInstance.candidates(4);
      })
      .then(function(candidate4) {
        assert.equal(0, candidate4[2], "Candidate 4 did not receive votes");
      });
  });

  it("Can't vote twice", function() {
    return Election.deployed()
      .then(function(instance) {
        appInstance = instance;
        candidateId = 2;
        appInstance.vote(candidateId, { from: accounts[2] });
        return appInstance.candidates(candidateId);
      })
      .then(function(candidate) {
        assert.equal(candidate[2], 1, "Vote was accepted");
        return appInstance.vote(candidateId, { from: accounts[2] });
      })
      .then(assert.fail)
      .catch(function(error) {
        assert(
          error.message.indexOf("revert") >= 0,
          "Error message must contains revert string"
        );
        return appInstance.candidates(1);
      })
      .then(function(candidate1) {
        assert.equal(1, candidate1[2], "Candidate 1 did not receive votes");
        return appInstance.candidates(2);
      })
      .then(function(candidate2) {
        assert.equal(1, candidate2[2], "Candidate 2 did not receive votes");
        return appInstance.candidates(3);
      })
      .then(function(candidate3) {
        assert.equal(0, candidate3[2], "Candidate 3 did not receive votes");
        return appInstance.candidates(4);
      })
      .then(function(candidate4) {
        assert.equal(0, candidate4[2], "Candidate 4 did not receive votes");
      });
  });
});

pragma solidity >=0.4.21 <0.7.0;

contract Election {
    //Model a Candidate
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    // Store accounts that havec voted
    mapping(address => bool) public voters;

    // Store Candidates

    // Fetch Candidate
    mapping(uint256 => Candidate) public candidates;

    // Store Candidates Count
    uint256 public candidatesCount;

    // Event
    event votedEvent(uint256 indexed _candidateId);

    //Constructor
    constructor() public {
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
        addCandidate("Candidate 3");
        addCandidate("Candidate 4");
    }

    function addCandidate(string memory _name) private {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint256 _candidateId) public {
        // Require that they haven't voted
        require(!voters[msg.sender], "The voter has already voted");

        // Check valid candidate
        require(
            _candidateId <= candidatesCount && _candidateId > 0,
            "The candidate doesn't exist"
        );

        //Record that voter has voted
        voters[msg.sender] = true;

        // Increase vote count of candidate
        candidates[_candidateId].voteCount++;

        emit votedEvent(_candidateId);
    }
}

pragma solidity >=0.4.21 <0.7.0;

contract Election {
    //Model a Candidate
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    struct Voter {
        uint256 weight;
        uint256 vote;
        bool voted;
        address delegate_to;
    }

    // Store accounts that havec voted
    mapping(address => Voter) public voters;

    // Store Candidates

    // Fetch Candidate
    mapping(uint256 => Candidate) public candidates;

    // Store Candidates Count
    uint256 public candidatesCount;

    address public chairPerson;

    uint256 private endDate;

    // Event
    event votedEvent(uint256 indexed _candidateId);
    event addRightToVote(address newVoter);

    constructor(bytes32[] memory participants, uint256 _endTimeInMinute)
        public
    {
        chairPerson = msg.sender;
        voters[chairPerson].weight = 1;

        for (uint256 i = 0; i < participants.length; i++) {
            addCandidate(participants[i]);
        }
        endDate = now + (_endTimeInMinute * 1 minutes);

    }

    function giveRightToVote(address voter) public {
        require(
            msg.sender == chairPerson,
            "Only chairperson can give right to vote."
        );
        require(!voters[voter].voted, "The voter already voted.");
        require(voters[voter].weight == 0, "The voter can't vote");
        voters[voter].weight = 1;
        emit addRightToVote(voter);
    }

    function giveMultipleRightToVote(address[] memory _voters) public {
        require(
            msg.sender == chairPerson,
            "Only chairperson can give right to vote."
        );
        for (uint256 i = 0; i < _voters.length; i++) {
            giveRightToVote(_voters[i]);
        }
    }

    function setTimeBeforeEnd(uint256 _timeInMinutes) public {
        endDate = now + (_timeInMinutes * 1 minutes);
    }

    function addCandidate(bytes32 _name) private {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(
            candidatesCount,
            bytes32ToString(_name),
            0
        );
    }

    function vote(uint256 _candidateId) public {
        // Check if can vote
        require(voters[msg.sender].weight != 0, "You have no right to vote");

        // Require that they haven't voted
        require(!voters[msg.sender].voted, "The voter has already voted");

        // Check valid candidate
        require(
            _candidateId <= candidatesCount && _candidateId > 0,
            "The candidate doesn't exist"
        );

        // Check if vote is not overtime
        require(now < endDate, "It's too late to vote");

        //Record that voter has voted
        voters[msg.sender].voted = true;
        voters[msg.sender].vote = _candidateId;

        // Increase vote count of candidate
        candidates[_candidateId].voteCount = voters[msg.sender].weight;

        emit votedEvent(_candidateId);
    }

    function delegate(address to) public {
        address _to = to;
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");

        require(_to != msg.sender, "Self-delegation is disallowed.");

        while (voters[_to].delegate_to != address(0)) {
            _to = voters[_to].delegate_to;
            require(_to != msg.sender, "Found loop in delegation.");
        }

        sender.voted = true;
        sender.delegate_to = _to;
        Voter storage delegate_ = voters[_to];
        if (delegate_.voted) {
            candidates[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    function winningProposal() public view returns (uint256 winningProposal_) {
        uint256 winningVoteCount = 0;
        for (uint256 p = 0; p < candidatesCount; p++) {
            if (candidates[p].voteCount > winningVoteCount) {
                winningVoteCount = candidates[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() public view returns (string memory winnerName_) {
        winnerName_ = candidates[winningProposal()].name;
    }

    function bytes32ToString(bytes32 x) private view returns (string memory) {
        bytes memory bytesString = new bytes(32);
        uint256 charCount = 0;
        uint256 j = 0;
        for (j = 0; j < 32; j++) {
            bytes1 char = bytes1(bytes32(uint256(x) * 2**(8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
}

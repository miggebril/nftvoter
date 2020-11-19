
//unused
pragma solidity ^0.7.4;

contract ElectionERC20 {

    
    uint electionEndTime;
    string[] public candidates;

    mapping (string => uint) votes; // voter id to number of votes
    mapping (address => bool) voters; // voter's registration status
    mapping (address => bool) hasVoted; // has voted

    struct Voter {
        uint delegateWeight; // delegateWeight is accumulated by delegation
        bool voteSpent;  // if true, that person already used their vote
        address delegateTo; // the person that the voter chooses to delegate their vote to instead of voting themselves
        uint voteIndex;   // index of the proposal that was voted for
    }

    // This is a type for a single proposal.
    struct Proposal {
        bytes32 proposalName;   // short name for the proposal (up to 32 bytes)
        uint voteCount; // the number of votes accumulated
    }

    uint256 public yesTransfer;
    uint256 public noTransfer;
    uint256 public voteEnd;
    uint32 public voterCount;
    Proposal[] public proposals;
    
    mapping(address => Voter) public voterList;
    mapping(uint => address) public idToAddress;
    
    struct Voter {
        uint id;
        bool voted;
        address voterAddress;
    }

    address electionAuthority;
    constructor() public {
        electionAuthority = msg.sender;
        voters[electionAuthority].weight = 1;
    }

    // custom access modifiers
    modifier only_election_authority() {
        if (msg.sender != electionAuthority) revert();
        _;
    }

    modifier only_registered_voters() {
        if (!voters[msg.sender]) revert();
        _;
    }

    modifier vote_only_once() {
        if (hasVoted[msg.sender]) revert();
        _;
    }

    modifier only_during_election_time() {
        if (electionEndTime == 0 || electionEndTime > block.timestamp) revert();
        _;
    }

    function start_election(uint duration) public
        only_election_authority
    {
        electionEndTime = block.timestamp + duration;
    }

    function register_candidate(string memory id) public
        only_election_authority
    {
        candidates.push(id);
    }

    function register_voter(string memory id) public
        only_election_authority
    {
            voters[addr] = true;
    }

    function get_num_candidates() public view returns(uint)
    {
        return candidates.length;
    }
    
    function get_candidate(uint i) public
        view returns(string memory _candidate, uint _votes)
    {
        _candidate = candidates[i];
        _votes = votes[_candidate];
    }

    function vote(string memory id) public
        only_registered_voters
        vote_only_once
        only_during_election_time
    {
        votes[id] += 1;
        hasVoted[msg.sender] = true;
    }

    function assessVoter() public view returns(uint)
    {
        uint weight = (msg.sender).balance;
        return (weight);
    }

    function decideToTransfer() public view returns(bool)
    {
        bool shouldTransfer;
        if (yesTransfer > noTransfer){
            shouldTransfer = true;
        }
        return shouldTransfer;
    }

    function voteYesTransfer() public returns(uint)
    {
        //require(block.timestamp < voteEnd);
        yesTransfer = yesTransfer + 1;
        return yesTransfer;
    }

     function voteNoTransfer() public returns(uint)
     {
        //require(block.timestamp < voteEnd);
        noTransfer = noTransfer + 1;
        return noTransfer;
    }

    function checkYesTransfer() public view returns(uint)
    {
        return yesTransfer;
    }

    modifier voteApproved()
    {
        bool approveTransfer;
        if(decideToTransfer() == true)
        {
            approveTransfer = true;
        }

        require(approveTransfer == true);
        _;
    }

    function transfer() public voteApproved view returns(uint)
    {
        return(1);
    }
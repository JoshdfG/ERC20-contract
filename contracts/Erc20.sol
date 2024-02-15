// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Erc20 {
    string tokenName;
    string tokenSymbol;
    address feeRecipient;
    uint256 totalSupply_;

    event Approval(
        address indexed tokenOwner,
        address indexed spender,
        uint tokens
    );
    event Transfer(address indexed from, address indexed to, uint tokens);

    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowed;

    constructor(uint256 total, string memory name_, string memory symbol_) {
        totalSupply_ = total;
        balances[msg.sender] = totalSupply_;
        tokenName = name_;
        tokenSymbol = symbol_;
    }

    function name() external view returns (string memory) {
        return tokenName;
    }

    function symbol() external view returns (string memory) {
        return tokenSymbol;
    }

    function decimal() external pure returns (uint) {
        return 18;
    }

    function totalSupply() external view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) external view returns (uint) {
        return balances[tokenOwner];
    }

    function transfer(
        address to,
        uint _tokens
    ) external returns (bool _success) {
        require(balances[msg.sender] >= _tokens, "Insufficient balance");

        uint _feeAmount = (_tokens * 10) / 100;
        uint _netAmount = _tokens;

        require(_netAmount > 0, "Transfer amount too small");

        balances[msg.sender] -= _tokens;
        totalSupply_ -= _tokens;
        balances[to] += _netAmount;
        balances[address(0)] += _feeAmount;
        totalSupply_ = totalSupply_ - _feeAmount;

        balances[msg.sender] = balances[msg.sender] - _feeAmount;

        emit Transfer(msg.sender, to, _netAmount);
        emit Transfer(msg.sender, address(0), _feeAmount);

        return true;
    }

    function approve(address delegate, uint numTokens) external returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(
        address _owner,
        address _delegate
    ) external view returns (uint) {
        return allowed[_owner][_delegate];
    }

    function transferFrom(
        address _owner,
        address _buyer,
        uint _numTokens
    ) external returns (bool) {
        require(_numTokens <= balances[_owner], "Insufficient balance");
        require(
            _numTokens <= allowed[_owner][msg.sender],
            "Insufficient allowance"
        );

        uint feeAmount = (_numTokens * 10) / 100;
        uint netAmount = _numTokens;

        require(netAmount > 0, "Transfer amount too small");

        balances[_owner] -= netAmount;
        balances[_buyer] += netAmount;
        emit Transfer(_owner, _buyer, netAmount);
        balances[_owner] = balances[_owner] - feeAmount;
        totalSupply_ = balances[_owner];
        emit Transfer(address(0), address(0), feeAmount);

        return true;
    }
}

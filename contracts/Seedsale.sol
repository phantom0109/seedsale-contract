// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract Seedsale is Ownable {

    IERC20 kataToken;

    uint256 public price = 1000;       // 1 ETH = 1000 $KATA

    mapping(address => uint256) public buyTokens;
    mapping(address => uint256) public claimedTokens;

    uint256 public tgeAmount = 50;
    uint256 public tgeTime;
    uint256 public duration = 60 * 60 * 24 * 30 * 6;    // 6 months (180 days)

    constructor(uint256 _tgeTime) {
        tgeTime = _tgeTime;
    }

    function getClaimable() public view returns(uint256) {
        if (block.timestamp < tgeTime) return 0;
        if (buyTokens[msg.sender] <= 0) return 0;
        if (buyTokens[msg.sender] <= claimedTokens[msg.sender]) return 0;

        uint256 timeElapsed = block.timestamp - tgeTime;

        if (timeElapsed > duration)
            timeElapsed = duration;
        
        uint256 _tge = 100 - tgeAmount;
        uint256 unlockedPercent = _tge * timeElapsed / duration;
        unlockedPercent = unlockedPercent + tgeAmount;

        uint256 unlockedAmount = buyTokens[msg.sender] * unlockedPercent / 100;

        uint256 claimable = unlockedAmount - claimedTokens[msg.sender];

        return claimable;
    }
    
    function claim() external {
        require(block.timestamp > tgeTime, "Claim not started yet");
        require(buyTokens[msg.sender] > 0, "No token purcahsed");
        require(buyTokens[msg.sender] > claimedTokens[msg.sender], "You already claimed all");

        uint256 claimable = getClaimable();

        require (claimable > 0, "No token to claim");

        kataToken.transfer(msg.sender, claimable);

        claimedTokens[msg.sender] = claimedTokens[msg.sender] + claimable;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function setVesting(uint256 _tgeAmount, uint256 _tgeTime, uint256 _duration) external onlyOwner {
        tgeAmount = _tgeAmount;
        tgeTime = _tgeTime;
        duration = _duration;
    }

    function setKataToken(address _kata) external onlyOwner {
        kataToken = IERC20(_kata);
    }

    function registerMember(address[] memory addrs, uint256[] memory amounts) external onlyOwner {
        require(addrs.length == amounts.length, "Two array have different lengths");
        for (uint256 i = 0; i < addrs.length; i++){
            buyTokens[addrs[i]] = buyTokens[addrs[i]] + amounts[i];
    }
  }
}
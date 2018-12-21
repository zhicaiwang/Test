pragma solidity ^0.4.23;

/**
* @title SafeMath
* @dev Math operations with safety checks that throw on error
*/
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract BinaryOption {

  /**
  * Private variables
  */
  uint256 private developerShare = 5;
  uint256 private winnerShare = 95;
  bool locked; // FOR MODIFIER

  /**
  * Storage
  */
  mapping (uint256 => Game) public games;
  mapping (address => uint256) public gameBank;
  address public contractModifier;
  address public developer;

  /**
  * Constructor
  * Define contract modifier, developer address.
  * Initialize values.
  */
  constructor() public {
    contractModifier = msg.sender;
    developer = msg.sender;
  }

  /**
  * Data structure
  */
  struct Game {
    uint256 gameId;
    uint256 startTime;
    uint256 endTime;
    uint256 result; // 0->NOT SET, 1->UP, 2->DOWN, 3->TIE
    uint256 upPoolAmount;
    uint256 downPoolAmount;
    uint256 upBettersCount;
    uint256 downBettersCount;
    mapping(uint256 => Better) betters;
  }

  struct Better {
    address add;
    uint256 investedAmount;
    uint256 bet; // 1->UP, 2->DOWN
  }

  /**
  * Modifier
  */
  modifier onlyContractModifier() {
    require(msg.sender == contractModifier);
    _;
  }

  modifier noReentrancy() {
    if(locked) revert();
    locked = true;
    _;
    locked = false;
  }

  /**
  * Events
  */
  //event test_value(uint256 indexed value1);

  /**
  * Public functions
  */

  // Fallback
  function () public payable {
    revert();
  }

  function destroy() public onlyContractModifier {
    selfdestruct(contractModifier);
  }

  // Create games
  function addGame(uint256 gameId, uint256 startTime, uint256 endTime) public onlyContractModifier returns (bool result) {
    require(startTime > now && endTime > startTime);
    require(gameId >= 0);
    Game memory _game = Game(gameId, startTime, endTime, 0, 0, 0, 0, 0);
    games[gameId] = _game;
    return true;
  }

  function getGame(uint256 gameId) public constant returns(uint256) {
    require(gameId > 0);
    uint256 result = games[gameId].startTime;
    return result;
  }

  function getUpAmount(uint256 gameId) public constant returns(uint256) {
    require(gameId > 0);
    uint256 result = games[gameId].upPoolAmount;
    return result;
  }

  function getDownAmount(uint256 gameId) public constant returns(uint256) {
    require(gameId > 0);
    uint256 result = games[gameId].downPoolAmount;
    return result;
  }

  function getResult(uint256 gameId) public constant returns(uint256) {
    require(gameId > 0);
    uint256 result = games[gameId].result;
    return result;
  }

  function getBetterPlay(uint256 gameId, address add) public view returns (uint256 _result) {
    require(gameId > 0);
    uint256 index = getBetterIndex(gameId, add);
    _result = games[gameId].betters[index].bet;
  }

  function getBetterInvested(uint256 gameId, address add) public view returns (uint256 _result) {
    require(gameId > 0);
    uint256 index = getBetterIndex(gameId, add);
    _result = games[gameId].betters[index].investedAmount;
  }

  function getBalance() public view returns (uint256 _balance) {
    _balance = gameBank[msg.sender];
  }

  function getContractBalance() public view returns (uint256 _contractBalance) {
    _contractBalance = address(this).balance;
  }

/*
  function getGameDetails(uint256 gameId) public constant returns (uint256[]) {
    require(gameId > 0);
    Game memory _game = games[gameId];

    uint256[] memory data = new uint256[](8);
    data[0] = _game.gameId;
    data[1] = _game.startTime;
    data[2] = _game.endTime;
    data[3] = _game.result;
    data[4] = _game.upPoolAmount;
    data[5] = _game.downPoolAmount;
    data[6] = _game.upBettersCount;
    data[7] = _game.downBettersCount;

    return data;
  }
*/

  function betGame(uint256 gameId, uint256 bet) public payable returns(bool result) {
    require(gameId > 0 && bet > 0 && bet < 3);
    require(msg.value > 0);
    require(msg.sender != developer);

    Game storage _game = games[gameId];
    require(_game.result == 0);

    uint256 total = SafeMath.add(_game.upBettersCount, _game.downBettersCount);
    Better storage _better = _game.betters[total];
    _better.add = msg.sender;
    _better.investedAmount = msg.value;
    _better.bet = bet;

    if(bet == 1) {
      _game.upPoolAmount = SafeMath.add(_game.upPoolAmount, msg.value);
      _game.upBettersCount++;
    } else if(bet == 2) {
      _game.downPoolAmount = SafeMath.add(_game.downPoolAmount, msg.value);
      _game.downBettersCount++;
    }

    return true;
  }

  // Set game result and distribute prizes
  function setGameResult(uint256 gameId, uint256 result) public onlyContractModifier returns(bool) {
     require(gameId > 0 && result > 0 && result < 4);
     Game storage _game = games[gameId];

     require(_game.result == 0);
     _game.result = result;

     // Winners profit = losers invested
     uint256 profit = 0;
     uint256 winnersTotalInvested = 0;
     if (result == 1){
       profit = _game.downPoolAmount;
       winnersTotalInvested = _game.upPoolAmount;
     } else if (result == 2){
       profit = _game.upPoolAmount;
       winnersTotalInvested = _game.downPoolAmount;
     }

     uint256 onePercent = SafeMath.div(profit, 100);
     uint256 developerProfit = SafeMath.mul(onePercent, developerShare);
     gameBank[contractModifier] = SafeMath.add(gameBank[contractModifier], developerProfit);

     uint256 winnersProfit = SafeMath.mul(onePercent, winnerShare);

     for(uint256 i = 0; i < SafeMath.add(_game.upBettersCount, _game.downBettersCount); i++) {
       Better memory better = _game.betters[i];

       // Winner profit = (winner invest / all winners invested) * winners profit
       if(better.bet == result && better.investedAmount > 0 && winnersProfit > 0){
         uint256 _gain = SafeMath.div(SafeMath.mul(better.investedAmount, winnersProfit), winnersTotalInvested);
         uint256 _balance = SafeMath.add(better.investedAmount, _gain);
         gameBank[better.add] = SafeMath.add(gameBank[better.add], _balance);
       }
     }
     return true;
  }

  function playerWithdraw() external noReentrancy returns(bool) {
    uint256 refund = gameBank[msg.sender];
    require (refund > 0);
    gameBank[msg.sender] = 0;

    //TODO
    msg.sender.transfer(refund);
    //if(!msg.sender.call.gas(3000000).value(refund)) throw;
    return true;
  }

  /**
   * Private functions
   */
  function getBetterIndex(uint256 gameId, address add) private view returns (uint256 result) {
    require(gameId > 0);
    uint256 betterCount = SafeMath.add(games[gameId].upBettersCount, games[gameId].downBettersCount);
    for(uint256 i = 0; i < betterCount; i++){
      if(games[gameId].betters[i].add == add){
        result = i;
        break;
      }
    }
  }
}

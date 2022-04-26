// SPDX-License-Identifier: GPL-3.0
// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //
//   
//      ┃┃┃┃┃┏━┓┏━┓┃┓┃┓┃┃┃┃┃━━━┓
//      ┃┃┃┃┃┃┏┛┃┏┛┃┃┃┃┃┃┃┃┃┏━┓┃
//      ┏━━┓┃┛┗┓┛┗┓┓┃┃┃┃┓┃┏┓┗━┛┃
//      ┗┃┓┃┃┓┏┛┓┏┛┫┃┃┃┃┃┃┃┃┏━┓┃
//      ┃┗┛┗┓┃┃┃┃┃┃┃┗┓┗┓┗━┛┃┗━┛┃
//      ┗━━━┛┗┛┃┗┛┃┛━┛━┛━┓┏┛━━━┛
//      ┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃━┛┃┃┃┃┃┃
//      ┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃┃━━┛┃┃┃┃┃
// 
// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //

// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //                                                                                                                                             //
//                                                                                                                                                                                  //
//      @dev ::             stereoIII6.dao                                                                                                                                          //
//      @msg ::             type.stereo@pm.me                                                                                                                                       //
//      @github ::          stereoIII6                                                                                                                                              //
//                                                                                                                                                                                  //
//      @codev ::           WillDera                                                                                                                                                //
//      @msg ::                                                                                                                                                                     //
//      @github ::          WillDerra                                                                                                                                               //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //
//                                                                                                                                                                                  //
// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//      @title ::  affilly8                                                                                                                                                         //
//      @description ::                                                                                                                          //
//      @version ::         0.0.1                                                                                                                                                   //
//      @purpose ::                                                                                                                              //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //

pragma solidity ^0.8.0;

contract Affilliate{
    address admin;
    uint8 UserRole; // 0-guets, 1-producer, 2-promoter, 3-both, 9-admin    
    uint8 CampaignType; // 0-View, 1-Click, 2-Referal, 3-Sale, 4-Lifetime
    uint8 ActionType; // 0-Sign, 1-Transfer, 2-Mint, 3-Burn, 4-Approve
    struct Campaign{
        uint256 id;
        address author;
        bytes description;
        uint8 txAction;
        uint256 txPrice;
        uint256 fee;
        uint256 max;
        address txTo; 
        uint8 ppType;
        uint256 safeWallet;
        uint256 interval;  
        uint256 end;
    }
    struct User{
        uint256 id;
        address user;
        uint8 role;
        bytes name;
        bytes status;
    }
    struct RefLinks{
        uint256 id;
        uint256 campaigId;
        address promoter;
    }
    Campaign[] public campaigns;
    User[] public users;
    RefLinks[] public links;
    mapping(address => uint256) internal myId;
    mapping(address => uint256) internal myCampaignCount;
    mapping(address => mapping(uint256 => Campaign)) public showCampaign;
    mapping(address => uint256) internal mylinkCount;
    mapping(address => mapping(uint256 => RefLinks)) public showLinks;
    uint256 c;
    uint256 u;
    uint256 l;
    function signIn(string memory _name, string memory _status) external returns(bool){
        users.push(User(u, msg.sender, 0, bytes(_name), bytes(_status)));
        myId[msg.sender] = u;
        u++;
        return true;
    }
    function beProducer() external returns(bool){
        uint256 id = myId[msg.sender];
        require(users[id].role != 1, "you are producer");
        if(users[id].role == 0) { users[id].role = 1;}
        if(users[id].role == 2) { users[id].role = 3;}
        return true;
    }
    function bePromoter() external returns(bool){
        uint256 id = myId[msg.sender];
        require(users[id].role != 2, "you are promoter");
        if(users[id].role == 0) { users[id].role = 2;}
        if(users[id].role == 1) { users[id].role = 3;}
        return true;
    }

    function makeCampaign(string memory _desc, uint8 _txAction, uint256 _price, uint256 _fee,uint256 _max,address _to, uint8 _type, uint256 _int, uint256 _end) external payable returns(bool){
        uint256 id = myId[msg.sender];
        require(users[id].role == 1 || users[id].role == 3, "you are not producer");
        require(_fee * 10 ** 18 < msg.value);
        campaigns.push(Campaign(c, msg.sender, bytes(_desc), _txAction, _price,_fee * 10 ** 18, _max,_to, _type,msg.value, _int, _end));
        myCampaignCount[msg.sender]++;
        showCampaign[msg.sender][c] = campaigns[c];
        c++;
        return true;
    }
    function makeLink(uint256 _cid) external returns(bool){
        uint256 id = myId[msg.sender];
        require(users[id].role == 2 || users[id].role == 3, "you are not promoter");
        links.push(RefLinks(l, _cid, msg.sender));
        showLinks[msg.sender][mylinkCount[msg.sender]] = links[l];
        mylinkCount[msg.sender]++;
        l++;
        return true;
    }
    function finalize(uint256 _rlid) external view returns(bool){
        require(_rlid < mylinkCount[msg.sender]);
        uint256 cid = showLinks[msg.sender][_rlid].campaigId;
        if(campaigns[cid].txAction == 0){
            require(campaigns[cid].fee < campaigns[cid].safeWallet);
            // sign for pay per view , pay per click and pay per referal
        }
        if(campaigns[cid].txAction == 1){
            // transfer for pay per sale 
        }
        if(campaigns[cid].txAction == 2){
            // mint for pay per sale and pay per lifetime
        }
        if(campaigns[cid].txAction == 3){
            // burn for pay per lifetime
        }
        if(campaigns[cid].txAction == 4){
            // approve for pay per lifetime
        }
        return true;
    }
}

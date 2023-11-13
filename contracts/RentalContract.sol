// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract RentalContract {
    address owner;
    constructor(){
        owner=msg.sender;

    }
    struct Property{
        address owner;
        string addressDetails;
        string propertyType;
        bool isActive;
    }
    struct Rental{
        uint propertyID;
        address tenant;
        uint256 startDate;
        uint256 endDate;
        bool isActive;
    }
    struct Complaint{
        uint contractID;
        string complain;
        bool isResolved;
    }

    Property[] public properties;
    Rental[] public rentals;
    Complaint[] public complains;

    mapping(address => uint[]) public ownerProperties;
    mapping(address => uint[]) public tenantContracts;
    mapping(uint => bool) public hasActiveContract;
    mapping(address => bool) public penalyList;

    function addProperty(string memory addressDetails,string memory propertyType) public{
        properties.push(Property({
            owner:msg.sender,
            addressDetails: addressDetails,
            propertyType:propertyType,
            isActive:true
        }));
        ownerProperties[msg.sender].push(properties.length-1);
    }

    function startContract(uint propertyID,address tenant,uint256 startDate,uint256 endDate) public {
        require(properties[propertyID].owner == msg.sender, "Only property owner can initiate contract");
        require(!hasActiveContract[propertyID], "Property is already rented");
        require(!penalyList[tenant], "Tenant is on the penalty list");

        rentals.push(Rental({
            propertyID:propertyID,
            tenant:tenant,
            startDate:startDate,
            endDate:endDate,
            isActive:true
        }));
        tenantContracts[tenant].push(rentals.length-1);
        hasActiveContract[propertyID] = true;
    }

    function addComplaint(uint contractID,string memory complaint) public {
        complains.push(Complaint({
            contractID:contractID,
            complain:complaint,
            isResolved:false
        }));
    }

    function resolveComplaint(uint complaintID) public {
        require(complaintID < complains.length,"Invalid ID");

        Complaint storage complain = complains[complaintID];
        Rental storage rental = rentals[complain.contractID];

        require(
            msg.sender == rental.tenant || msg.sender == properties[rental.propertyID].owner,
            "Only tenant or owner can resolve the complaint"
        );
        complain.isResolved=true;
    }

    function endContract(uint contractID) public{
        Rental storage rental = rentals[contractID];
        require(
            msg.sender == rental.tenant || msg.sender == properties[rental.propertyID].owner,
            "Only tenant or owner of the property can end contract");
        require(block.timestamp == rental.startDate,"Cannot end contract before start date");
        if(block.timestamp < rental.endDate -15 days){
            require(penalyList[msg.sender]==false,"Cannot end contract if you are in Penalty List");
        }
        rental.isActive=false;
        hasActiveContract[rental.propertyID] = false;
    }

    function addPenalty(address user) public {
        require(msg.sender==owner,"Only owner can add Penalty");
        penalyList[user] = true;
    }
    

}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BarleyHarvestTracker {
    address public owner;

    enum Role { NONE, FARMER, MALTSTER, EXPORTER, BREWERY }
    mapping(address => Role) public roles;

    struct SensorReading {
        uint256 timestamp;
        uint8 leafColorationIndex;
        uint256 soilMoisture;
        uint256 nitrogenContent;
        uint256 predictedHarvestDate;
        uint256 actualHarvestDate;
    }

    mapping(uint256 => SensorReading) public readings;
    uint256 public readingCount;

    event NewReading(uint256 indexed id, uint256 timestamp, uint256 predictedHarvestDate);
    event HarvestRecorded(uint256 indexed id, uint256 actualHarvestDate);

    constructor(address _farmer, address _maltster, address _exporter, address _brewery) {
        owner = msg.sender;
        roles[_farmer] = Role.FARMER;
        roles[_maltster] = Role.MALTSTER;
        roles[_exporter] = Role.EXPORTER;
        roles[_brewery] = Role.BREWERY;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyFarmer() {
        require(roles[msg.sender] == Role.FARMER, "Only farmer");
        _;
    }

    function addSensorReading(
        uint8 _leafColorationIndex,
        uint256 _soilMoisture,
        uint256 _nitrogenContent,
        uint256 _predictedHarvestDate
    ) public onlyFarmer {
        readings[readingCount] = SensorReading(
            block.timestamp,
            _leafColorationIndex,
            _soilMoisture,
            _nitrogenContent,
            _predictedHarvestDate,
            0
        );
        emit NewReading(readingCount, block.timestamp, _predictedHarvestDate);
        readingCount++;
    }

    function recordActualHarvestDate(uint256 _id, uint256 _actualHarvestDate) public onlyFarmer {
        require(_id < readingCount, "Invalid ID");
        readings[_id].actualHarvestDate = _actualHarvestDate;
        emit HarvestRecorded(_id, _actualHarvestDate);
    }
}
